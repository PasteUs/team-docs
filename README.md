# PasteUs README

PasteUs 团队新人指引

## 0. 加入我们

欢迎各位小伙伴加入我们：[join.pasteme.cn](https://www.wjx.top/jq/46847776.aspx)

QQ 群：

![](https://cdn.jsdelivr.net/gh/PasteUs/CDN@0.0.60/screenshot/pasteme/PasteUsQQGroup.JPG)

## 1. 规约

### 1.1 Java

1. 每个 `*.java` 文件必须加上 `@author` ，代表参与编写的人，多个人用英文逗号分隔，`,` 后面需有空格
2. 每个 `*.java` 工程文件必须加上 `@version`，在文件变更时对 `@version` 进行相应的变更
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
5. **请务必遵守阿里巴巴 Java 代码规范 https://github.com/alibaba/p3c**
6. 请使用 Alibaba 代码规约插件 https://github.com/alibaba/p3c/tree/master/idea-plugin

### 1.2 Git

1. 请正确配置 `git config user.name` 以及 `git config user.email`
2. `git commit` 时请尽可能使用英文
3. 在进行更改时先将项目克隆至自己的仓库，然后新建一个分支，分支名格式为 `feature/<feature_name>` 或 `bugfix/<bug_name>`，譬如 `feature/check_result_support`、`bugfix/fix_sql_error`，然后发 `pull request` 至项目的 `dev` 分支。
4. 对 `git` 不熟悉的话请先学习如何使用 `git`，以免浪费不必要的时间。推荐一个学习 `git` 的网站：[learngitbranching.js.org](https://learngitbranching.js.org/)，中文版：[learngitbranching.js.org/?locale=zh_CN](https://learngitbranching.js.org/?locale=zh_CN)

### 1.3 Markdown

https://github.com/ruanyf/document-style-guide

### 1.4 Commits、Issues 等排版

https://github.com/sparanoid/chinese-copywriting-guidelines/blob/master/README.zh-CN.md

## 2. PasteMe 项目进度

https://github.com/orgs/PasteUs/projects/1

### 2.1 参与开发

大致分以下几个步骤：

1. 开发
2. 功能自测
3. 向 `dev` 分支提交 `pull request`，review 通过后合并至 dev
4. `dev` 环境线上功能自测
5. 联调（如果需要）
6. 验收测试
7. 上线


## 3. 线上环境

目前线上的项目为 `PasteUs/PasteMeFrontend` 和 `PasteUs/PasteMeGoBackend`

对项目分支的更改将直接影响到线上的服务，请谨慎。

分支和线上的映射关系如下：

| 分支 / Tag | 网址 |
| :---: | :---: |
| release | [pasteme.cn](https://pasteme.cn) |
| master | [pre.pasteme.lucien.ink](http://pre.pasteme.lucien.ink) |
| dev | [dev.pasteme.lucien.ink](http://dev.pasteme.lucien.ink) |

将分支的更改应用至线上需要一定时间，同步状态可以在 [pasteus.github.io/PasteMeMonitor/](https://pasteus.github.io/PasteMeMonitor/) 查看


## 4. 项目说明

### 4.1 PasteMe 系

#### 4.1.1 Java

| 项目 | 作用 | 依赖 |
| :---: | :---: | :---: |
| [PasteMeRoot](https://github.com/PasteUs/PasteMeRoot) | 所有项目的 `parent`，作统一版本控制 | 无 |
| [PasteMeCommon](https://github.com/PasteUs/PasteMeCommon) | PasteMeBackend、PasteMeAdmin 共同的部分会下沉至 common 模块 | PasteMeRoot |
| [PasteMeJavaBackend](https://github.com/PasteUs/PasteMeJavaBackend) | PasteMe 的 Java 后端，主要负责 Paste 的增改，因为 PasteMeGoBackend 的存在，所以起名 JavaBackend 以区分 | PasteMeRoot、PasteMeCommon |
| [PasteMeAdmin](https://github.com/PasteUs/PasteMeAdmin) | PasteMe 后台管理模块，主要负责 Paste 的管理，以及算法业务化 | PasteMeRoot、PasteMeCommon、PasteMeAlgorithm |
| [PasteMeAlgorithm](https://github.com/PasteUs/PasteMeAlgorithm) | PasteMe 算法模块，主要负责各种算法实现 | PasteMeRoot |

#### 4.1.2 Vue

| 项目 | 作用 | 依赖 |
| :---: | :---: | :---: |
| [PasteMeFrontend](https://github.com/PasteUs/PasteMeFrontend) | PasteMe 前端 | 无 |
| [PasteMeMonitor](https://github.com/PasteUs/PasteMeMonitor) | PasteMe 监控模块，监控前后端的运行情况 | 无 |

#### 4.1.3 Golang

| 项目 | 作用 | 依赖 |
| :---: | :---: | :---: |
| [PasteMeLite](https://github.com/PasteUs/PasteMeLite) | 由于很多小伙伴并不太会部署，所以提供 Lite 版，做到**随处执行，随处使用** | PasteMeGoBackend、PasteMeFrontend |
| [PasteMeGoBackend](https://github.com/PasteUs/PasteMeGoBackend) | PasteMe 后端 Golang 实现的版本，线上准备切换至 Java 版本，Go 版本并入 PasteMeLite 项目 | 无 |

### 4.2 其它

| 项目 | 作用 | 依赖 |
| :---: | :---: | :---: |
| [pasteus.github.io](https://github.com/PasteUs/pasteus.github.io) | PasteUs 项目组 GitPages 页面，PasteMeMonitor 寄存在这里 | PasteMeMonitor |
| [CDN](https://github.com/PasteUs/CDN) | 前端的内容分发网络 | 无 |
| [MavenRepository](https://github.com/PasteUs/MavenRepository) | 团队 Maven 仓库 | 无 |
| [README](https://github.com/PasteUs/README) | 团队新人指引 | 无 |
