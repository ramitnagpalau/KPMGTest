#NOTE: Considering below commands would run on remote host.
#Installing npm dependencies
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs
sudo npm install

#Installing yarn through npm
sudo npm install --global yarn

#Performing unit tests
sudo yarn test a --watchAll=false

#Creating Production build and compress archieve of production build
sudo yarn build && tar -zcf build.tar.gz build

#Deployment
sudo npm install -g serve
sudo serve -s build
