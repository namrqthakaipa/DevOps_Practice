#!/bin/bash

REPO_URL="https://github.com/namrqthakaipa/react_deploy.git" 
DEST_DIR="/var/www/html/react"
APP_NAME="react_deploy"  

if [ ! -d "$APP_NAME" ]; then
    echo "Project cloned"
    git clone $REPO_URL $APP_NAME
else
    echo "Project  already cloned"
    cd $APP_NAME
    git pull origin main
    cd ..
fi

cd $APP_NAME

echo "Installing dependencies"
npm install

echo "Building the React application"
npm run build

if [ ! -d "$DEST_DIR" ]; then
    echo "Creating directory $DEST_DIR "
    sudo mkdir -p $DEST_DIR
fi

echo "Deploying build folder to $DEST_DIR "
sudo rm -rf $DEST_DIR/*  
sudo cp -r build/* $DEST_DIR

sudo chown -R www-data:www-data $DEST_DIR
sudo chmod -R 755 $DEST_DIR

echo "Restarting Nginx web server"
sudo systemctl restart nginx
echo "Deployment complete!"
npm start
