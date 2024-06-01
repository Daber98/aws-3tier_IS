#!/bin/bash
set -e
set -o pipefail

# Run system update
apt-get update &&

# install curl
apt install curl -y &&

# install tar
apt install tar -y &&

## Install Nodejs

# Check available Node.js Version
apt policy nodejs &&

# Install Nodejs & NPM
apt-get install nodejs -y &&
apt install npm -y &&

# Install Nginx
apt-get install nginx -y &&

# Start nginx
service nginx start &&

# Ensure every time you restart your system Nginx starts up automatically.
systemctl enable nginx &&

# Install nano text editor
apt-get install nano -y &&

# Install pm2
npm install pm2 -g &&

# Configure PM2 to start Express application at startup.
env PATH=$PATH:/usr/local/bin pm2 startup -u ubuntu &&

# Start to listening in port 4000
echo "const http = require('http'); const server = http.createServer((req, res) => { res.statusCode = 200; res.setHeader('Content-Type', 'text/plain'); res.end('Hello, World!'); }); server.listen(4000, () => { console.log('Server running at http://localhost:3000'); });" > hello-world.js && pm2 start hello-world.js --name backend &&

git clone https://github.com/Daber98/Final_IS.git &&
cd Final_IS &&
cd client &&

# Deploying frontend for the first time
echo REACT_APP_API_URL="${backend_url}:4000/api/cruds" > .env &&

npm install &&
npm run build &&
chmod 777 /var/www/html -R &&
rm -rf /var/www/html/* &&
scp -r ./build/* /var/www/html &&
systemctl restart nginx &&

# Deploying backend for the first time
cd .. &&
cd server &&
echo MONGODB_URI="mongodb+srv://Frnn:noobculo@mongocluster.o2eojyk.mongodb.net/test?retryWrites=true&w=majority" > .env &&
# Start the application with PM2
npm install &&
pm2 delete backend &&
pm2 start index.js --name backend