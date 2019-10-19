# PasteUs README

新人指引

## 开发约定

1. 每个 `Java` 工程文件必须加上 `@author` ，代表参与编写的人，多个人用英文逗号分隔，`,` 后面需有空格
2. 每个 `Java` 工程文件必须加上 `@version`，在文件变更时对 `@version` 进行相应的变更
    + 2.1 小修补之类的对 *末* 位进行更改，如 `1.0.0` -> `1.0.1`
    + 2.2 有功能上的更新，对 *中间* 位进行更改，如 `1.0.0` -> `1.1.0`
    + 2.3 有较大更新，且 **移除** 或 **不兼容** 以往的接口，对 *首位* 进行变更，如 `1.0.0` -> `2.0.0`

```java
/**
 * @author Lucien, Irene
 * @version 1.0.0
 */
public class Example {}
```

3. 日志一律使用 `@Slf4j`
4. 不允许直接变更 `dev`、`master` 分支，需 `clone` 至自己的仓库之后进行 `pull request`
5. 代码规范参考 https://github.com/alibaba/p3c
6. 请正确配置 `git config user.name` 以及 `git config user.email`
7. `git commit` 时请尽可能使用英文
8. 在对 `submodule` 进行更改之前 **请务必执行** `git checkout master`
9. 请使用 Alibaba 代码规约插件 https://github.com/alibaba/p3c/tree/master/idea-plugin

## Markdown 书写规范

https://github.com/ruanyf/document-style-guide

## Commits、Issues 等排版

https://github.com/sparanoid/chinese-copywriting-guidelines/blob/master/README.zh-CN.md

## PasteMe 项目管理

https://github.com/orgs/PasteUs/projects/1

## 线上环境

对分支的更改将直接影响到线上的服务，请谨慎。

分支和线上的映射关系如下：

| 分支 / Tag | 网址 |
| :---: | :---: |
| release | [pasteme.cn](https://pasteme.cn) |
| master | [pre.pasteme.lucien.ink](http://pre.pasteme.lucien.ink) |
| dev | [dev.pasteme.lucien.ink](http://dev.pasteme.lucien.ink) |

将分支的更改应用至线上需要一定时间，同步状态可以在 [status.pasteme.lucien.ink](http://status.pasteme.lucien.ink) 查看

