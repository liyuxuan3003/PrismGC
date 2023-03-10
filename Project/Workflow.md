# 工作流程

## 版本控制
我们的Git有四个分支，每个人在每个人的分支进行日常工作。
```
master
lyx
lmj
zy
```

## 项目成员的工作流
以下假定是李铭杰同学在进行操作。

每天早上（或者说开始工作前），先将自己的工作分支快进至`master`分支
```
git checkout master
git pull
git checkout lmj
git merge master
```

每天只要稍微有些值得记录的改动，就在本地提交一个版本
```
# 该命令应当在受git控制的根目录下运行
git add .
git commit -m "描述你的改动内容"
```
每天可以适时的向服务器同步你的更改
```
git push
```

## 项目管理员的工作流
以下仅适用于项目管理员李宇轩。

每天晚上，从服务器依次同步所有人的更改
```
git checkout lmj
git pull
git checkout zy
git pull
```
依次合并到主分支，解决冲突（如果存在的话）
```
git checkout master
git merge lyx
git merge lmj
git merge zy
```
推送主分支至服务器
```
git push
```