# 基于Nginx与iptables的限速策略

## 原理

1. Nginx自带的组件 `limit_req_zone`可以对单个IP发起的请求进行限速,采用的策略是令牌桶算法,划定一块内存空间用来建立桶即可使用,开销比较小.初步确定`10Requests/s`,对于超出的请求均返回503.
2. 对非浏览器端发起的API请求拒绝服务,初步的方法是拒绝无Referer或携带除`*.pasteme.cn`与`localhost(调试用)`之外的Referer头的请求,均返回403.

3. 通过`Fail2Ban`组件监视`error.log`,提取触发503限速的IP,通过写入iptables拒绝掉流量.从TCP层面过滤流量.

## 实现

#### 设置Nginx

````
limit_req_zone $binary_remote_addr zone=pasteme:10m rate=5r/s; 
# 开启limit_req_zone,以remote_address作为分类标准,分配10M内存空间pasteme,标准速度为5次请求每秒.
server
{
    listen 8080;
    server_name _;
    index index.html;
    root /www/pasteme;
    underscores_in_headers on;  
    gzip_http_version 1.0;

    location / {
        try_files $uri $uri/ /index.html;
        location ~ .*\.(js|css)?$ {
            gzip_static on;
        }
    }

    location /_api/backend/ { 
    #对/_api/backend/ 进行限流,使用上面划分的zone pasteme,允许有5次请求每秒的突发,因此
    #限流的速率要求为共10次请求每秒,nodelay表示超过限流就返回503拒绝请求.
        limit_req zone=pasteme burst=5 nodelay;
        valid_referers localhost pasteme.cn *.pasteme.cn;
        if ($invalid_referer) {
          return 403;
        }
        # 对referer 头部进行校验,只允许 localhost/pasteme.cn/*.pasteme.cn三种域名的referer,若无Referer或Referer中不以http(s)起始也算无效,返回403
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://pasteme-backend:8000/;
    }

    location ~ ^/(\.user.ini|\.htaccess|\.git|\.svn|\.project|LICENSE|README.md)
    {
        return 404;
    }

    access_log  /var/lib/pasteme/pasteme.log;
    error_log  /var/lib/pasteme/pasteme.error.log;
    #错误log位置
}
````

重载Nginx即可生效.

#### 安装Fail2Ban

```shell
sudo apt-get install fail2ban
```

#### 增加日志检测规则

```shell
vim /etc/fail2ban/filter.d/nginx-req-limit.conf
```

内容为

```shell
# Fail2Ban configuration file
#
# supports: ngx_http_limit_req_module module

[Definition]

failregex = limiting requests, excess:.* by zone.*client: <HOST>
#使用正则匹配,<HOST>部分即为提取出的封禁IP
# Option: ignoreregex
# Notes.: regex to ignore. If this regex matches, the line is ignored.
# Values: TEXT
#
ignoreregex =
```

可参见 

[Fail2Ban文档](https://fail2ban.readthedocs.io/en/latest/filters.html)



#### 增加封禁任务

```shell
vim /etc/fail2ban/jail.local
```

官方建议使用`*.local`文件来覆写同目录下`jail.conf`的默认设置.`jail.local`内容如下

```shell
[nginx-req-limit] 
#任务名称 nginx-req-limit
enabled = true
# 启用
filter = nginx-req-limit
#过滤器 即之前新建的filter.d下的nginx-req-limit.conf
action = iptables-multiport[name=ReqLimit, port="http,https,8080", protocol=tcp]
#封禁动作 使用iptables封禁 iptables规则名称为ReqLimit 端口为http,https和8080,协议为tcp,记得要更改为Nginx的监听端口.
logpath = /var/lib/pasteme/pasteme.error.log
#要检测日志文件路径
findtime = 600
#检测时间为 600秒为一个时间区间
bantime = 7200
#封禁时间 7200s
maxretry = 10
#时间区间内允许的失败次数,这里设置为600秒内超过限流10次即拉黑.
```

```shell
systemctl restart fail2ban
```

查看日志规则是否启动

```shell
tail -f /var/log/fail2ban.log

2020-12-08 19:48:47,423 fail2ban.jail           [6163]: INFO    Jail 'nginx-req-limit' uses pyinotify {}
2020-12-08 19:48:47,432 fail2ban.jail           [6163]: INFO    Initiated 'pyinotify' backend
2020-12-08 19:48:47,438 fail2ban.filter         [6163]: INFO    Added logfile: '/var/lib/pasteme/pasteme.error.log' (pos = 2070, hash = 838cc5f2d47c4bd59219f24814adb669d56e62db)
2020-12-08 19:48:47,439 fail2ban.filter         [6163]: INFO      encoding: UTF-8
2020-12-08 19:48:47,440 fail2ban.filter         [6163]: INFO      maxRetry: 10
2020-12-08 19:48:47,441 fail2ban.filter         [6163]: INFO      findtime: 600
2020-12-08 19:48:47,441 fail2ban.actions        [6163]: INFO      banTime: 7200
2020-12-08 19:48:47,445 fail2ban.jail           [6163]: INFO    Jail 'sshd' started #默认会自动启动对ssh尝试失败的封禁
2020-12-08 19:48:47,456 fail2ban.jail           [6163]: INFO    Jail 'nginx-req-limit' started #已启动
2020-12-08 19:48:47,649 fail2ban.actions        [6163]: NOTICE  [nginx-req-limit] Restore Ban 192.168.124.238
```

![image-20201208195801556](https://tva1.sinaimg.cn/large/0081Kckwly1glgp4nd9udj30yp06zgnz.jpg)

或者使用`fail2ban-client`

```shell
fail2ban-client status nginx-req-limit

Status for the jail: nginx-req-limit
|- Filter
|  |- Currently failed: 0 #fail指检测到日志中的超限记录条数
|  |- Total failed:     0 
|  `- File list:        /var/lib/pasteme/pasteme.error.log
`- Actions
   |- Currently banned: 1 #ban掉的IP
   |- Total banned:     1
   `- Banned IP list:   192.168.124.238
```

#### 如何解封

```shell
fail2ban-client set <规则名称> unbanip <IP>

fail2ban-client set nginx-req-limit unbanip 192.168.124.238
```

## 验证Fail2Ban效果

`Fail2Ban`的核心在于改写iptables规则.执行`iptables -L`你会看到filter表中的所有规则链,`Fail2Ban`默认会新建一条规则链,并在`INPUT`的最顶层引用它.而每一个封禁都是一条REJECT记录.

![image-20201208212729532](https://tva1.sinaimg.cn/large/0081Kckwly1glgrpo7c49j30pd03u0t9.jpg)

> 因此使用awk命令直接分析log文件,提取IP,iptables增加规则也是个好办法,但是请注意:
>
> iptables在大量规则的情况下存在效率低下的问题,可以考虑和ipsets结合,或者结合其他策略定时删除.

## 已知问题

1. Docker容器中开放端口的流量不受过滤.

   Docker默认的子网组成方式是使用`Bridge模式`,在iptables的nat表中就转发入Docker容器.而Fail2ban的规则链添加在filter的INPUT链中,通往容器的数据包在NAT的Forward链中已经送往Docker容器,无法执行规则.

   >表的处理优先级：raw>mangle>nat>filter.在表中又有5个规则链:PREROUTING,INPUT,FORWARD,OUTPUT,POSTROUTING.下图表示了一个数据包进入路由表所经过的规则处理链.
   >
   >![img](https://tva1.sinaimg.cn/large/0081Kckwly1glgqsirfz5j30i30uo79m.jpg)

#### 解决方案

设置为将规则添加在`FORWARD`链中即可.

```shell
vim /etc/fail2ban/action.d/iptables-common.conf
```

```shell
# Option:  chain
# Notes    specifies the iptables chain to which the Fail2Ban rules should be
#          added
# Values:  STRING  Default: INPUT
chain = FORWARD 
#将chain由INPUT改为 FORWARD
```

```shell
systemctl restart fail2ban
```

