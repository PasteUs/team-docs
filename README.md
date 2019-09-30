# PasteUs README

新人指引

## 开发约定

1. 每个 `Java` 工程文件必须加上创建人以及日期

```java
/**
 * Created by Lucien on 2019/10/01 00:17
 * （如果有必要，这里写一些额外的文件说明）
 */
public class Example {}
```

2. 日志一律使用 `@Slf4j`
3. 不允许直接变更 `dev`、`master` 分支，需 `clone` 至自己的仓库之后进行 `pull request`
4. 代码规范参考 https://github.com/alibaba/p3c

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
