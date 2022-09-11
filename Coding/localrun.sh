#Installing npm dependencies
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs
sudo npm install

#Installing yarn through npm
sudo npm install --global yarn

#Starting the development server
sudo yarn start
