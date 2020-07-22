#!/bin/sh
echo "`date` : Started Setup.... `date`" > /tmp/log.script.log
sudo yum install -y yum-utils
echo "`date` : Configure docker-ce" >> /tmp/log.script.log
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
echo "`date` : Installing Docker docker-ce" >> /tmp/log.script.log
sudo yum install -y docker-ce --nobest
echo "`date` : Enable and start docker-ce" >> /tmp/log.script.log
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker azureuser
# sed -i -e "s/^#    AllowTcpForwarding no/AllowTcpForwarding yes/g" /etc/ssh/sshd_config
# systemctl restart sshd
echo "`date` : Finished installing Docker docker-ce" >> /tmp/log.script.log
docker container run -d -p 80:80 atamanch/dockerstore
exit