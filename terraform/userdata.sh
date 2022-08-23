#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo yum install git -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

cd /home/ec2-user
git clone "https://github.com/ogasimov7/phonebook.git"
cd phonebook/app
sudo docker-compose up -d