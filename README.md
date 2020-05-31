# rap2-docker

在 **Docker** 上快速搭建 **RAP2** 应用。

## 安装

克隆仓库

`git clone https://github.com/ganl/rap2-docker.git`

初始化并更新submodule,主要是下载最新rap2-delos和rap2-dolores

```
git submodule init
git submodule update

#官方代码经常不能正常编译，可修改.gitmodules中的url为自己的fork库；修改后执行
git submodule sync
git submodule update --remote
```

## 修改配置

复制env文件

`mv env-example .env`

修改.env，主要的几个地方：

* 修改dolores（前端）中访问delos（接口）服务serve相关值

```
# used in config.prod.ts, 
DELOS_SERVE_PROTOCOL=http
# local's IP or Domain or hostname
DELOS_SERVE_HOST=localhost
#Generally, same with DELOS_PORT, expose port
DELOS_SERVE_PORT=8888
```

后端和前端分离部署的（两个docker），此处配置会替换dolores的config.prod.ts中serve的值，修改后需要重新编译前端`dolores`镜像；如上配置dolores将通过 `http://localhost:8888` 访问后端`delos`。

* 修改本地存储路径

mysql存放路径，建议第一次部署确定好路径；修改路径数据不会自动Migrate，需手动导出再导入

`DATA_PATH_HOST=~/.rap2/data`

* 修改DOLORES本地映射端口（镜像内运行端口80不可配，expose端口可配）

`DOLORES_PORT=80`

* 修改DELOS运行端口（默认8080，代码取的环境变量`SERVE_PORT`的值）

`DELOS_PORT=8880`


**修改`DELOS_SERVE_PROTOCOL`和`DELOS_SERVE_HOST`以及`DELOS_SERVE_PORT`，需要执行`docker-compose build dolores`编译前端镜像；后端delos不用重新编译**

![](https://github.com/ganl/mdAssets/blob/master/img/rap2-docker/running.jpg?raw=true)

## 使用

1 - 启动

`docker-compose up dolores`

```
➜  rap2-docker git:(master) docker-compose ps
     Name                   Command               State                 Ports               
--------------------------------------------------------------------------------------------
rap2_delos_1     node dispatch.js                 Up      0.0.0.0:8088->80/tcp              
rap2_dolores_1   /bin/sh -c http-server -s  ...   Up      0.0.0.0:8888->80/tcp              
rap2_mysql_1     docker-entrypoint.sh mysqld      Up      0.0.0.0:13306->3306/tcp, 33060/tcp
rap2_redis_1     docker-entrypoint.sh redis ...   Up      0.0.0.0:16379->6379/tcp
```

2 - 初始化DB

```bash
➜  rap2-docker git:(master) docker-compose exec delos sh
/app # node scripts/init
```

3 - 后台运行容器

```
docker-compose down
docker-compose up -d dolores
```

4 - 修改admin密码

`docker-compose exec mysql bash`

用.env中设定的密码登录数据库，默认`root!pwd`

```bash
#mysql -u root -p 
> use rap2
> update Users set password = '14e1b600b1fd579f47433b88e8d85291' where fullname = 'admin';
```
修改后的admin密码为123456，初始化的登录邮箱为admin@rap2.com

## 升级

1 - 升级DB

```bash
➜  rap2-docker git:(master) docker-compose exec delos node scripts/updateSchema

/app # node scripts/updateSchema
```

2 - 升级镜像

```bash
docker-compose down
# 重新构建并启动
docker-compose up --build -d dolores

docker image prune -f
```

<a name="Docker"></a>
### [Docker]常用命令

<a name="List-current-running-Containers"></a>
### 列出正在运行的容器
```bash
docker ps
```

你也可以使用以下命令查看某项目的容器
```bash
docker-compose ps
```

<a name="Close-all-running-Containers"></a>
### 关闭所有容器
```bash
docker-compose stop
```

停止某个容器:

```bash
docker-compose stop {容器名称}
```

<a name="Delete-all-existing-Containers"></a>
### 删除所有容器
```bash
docker-compose down
```

<a name="Enter-Container"></a>
### 进入容器 (通过 SSH 进入一个运行中的容器)

1 - 首先使用 `docker ps` 命令查看正在运行的容器

2 - 进入某个容器使用:

```bash
docker-compose exec {container-name} bash # mysql redis
docker-compose exec {container-name} sh   # delos dolores
```

*例如: 进入 MySQL 容器*

```bash
docker-compose exec mysql bash
```

3 - 退出容器, 键入 `exit`.

### [使用阿里云镜像加速]

el7

```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

sudo service docker start
```

修改daemon配置文件/etc/docker/daemon.json来使用加速器, 加速地址获取：[https://cr.console.aliyun.com/cn-hangzhou/mirrors]()

`sudo mkdir -p /etc/docker`

```
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://9cujqpdr.mirror.aliyuncs.com"]
}
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

