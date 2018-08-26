!#/bash/sh
# 关闭所有正在运行容器
# docker ps | awk  '{print $1}' | xargs docker stop

# 删除所有容器应用
# docker ps -a | awk  '{print $1}' | xargs docker rm
# 或者
# docker rm $(docker ps -a -q)

# 有时候重新构建镜像的时候，该镜像正在被某容器使用中，那么在重新构建同名同版本镜像后，docker保留原来的镜像。 
# 那么原来的镜像名称变成NONE，TAG也成了NONE
docker ps -a | grep "Exited" | awk '{print $1 }' | xargs docker stop
docker ps -a | grep "Exited" | awk '{print $1 }' | xargs docker rm
docker images | grep none | awk '{print $3 }' | xargs docker rmi
