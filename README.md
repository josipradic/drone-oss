docker build -t drone-oss:latest .
docker run -d --rm --name drone-oss -p 3000:80 -p 3443:443 -e DRONE_GITEA_SERVER=http://gitea.192.168.1.158.xip.io -e DRONE_SERVER_HOST=drone.192.168.1.158.xip.io drone-oss:latest
