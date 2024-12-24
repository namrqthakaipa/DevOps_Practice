#!/bin/bash

# Define variables
REPO_URL="https://github.com/namrqthakaipa/react_deploy.git"  # Replace with your GitHub repository URL
DEST_DIR="/var/www/html/react"
APP_NAME="react_deploy"  # Replace with your desired app name
NGINX_CONF="/etc/nginx/sites-available/react"
NGINX_LINK="/etc/nginx/sites-enabled/react"

# Step 1: Check if Nginx is installed, and install it if not
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing Nginx..."
    sudo apt update
    sudo apt install -y nginx
    echo "Nginx installed successfully."
else
    echo "Nginx is already installed."
fi

# Step 2: Start and enable Nginx
echo "Starting and enabling Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Step 3: Clone the React project from GitHub (if not already cloned)
if [ ! -d "$APP_NAME" ]; then 
    echo "Cloning React project from GitHub..."                                                                                                 
    git clone $REPO_URL $APP_NAME
else
    echo "Repository already cloned. Pulling latest changes..."
    cd $APP_NAME
    git pull origin main
    cd ..
fi

# Step 4: Navigate to the project directory
cd $APP_NAME

# Step 5: Install dependencies
echo "Installing dependencies..."
npm install

# Step 6: Build the React application
echo "Building the React application..."
npm run build

# Step 7: Create the target directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating directory $DEST_DIR..."
    sudo mkdir -p $DEST_DIR
fi

# Step 8: Deploy the build folder to /var/www/html/react
echo "Deploying build folder to $DEST_DIR..."
sudo rm -rf $DEST_DIR/*  # Remove any existing content in the destination folder
sudo cp -r build/* $DEST_DIR

# Step 9: Set permissions for the deployed files
sudo chown -R www-data:www-data $DEST_DIR
sudo chmod -R 755 $DEST_DIR

# Step 10: Create an Nginx configuration file for the React app
if [ ! -f "$NGINX_CONF" ]; then
    echo "Creating Nginx configuration file..."
    sudo bash -c "cat > $NGINX_CONF" <<EOL
server {
    listen 80;
    server_name localhost;

    root $DEST_DIR;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    error_page 404 /index.html;

    location ~* \.(?:manifest|json|xml|webmanifest)$ {
        expires 1y;
        access_log off;
    }

    location ~ \.js$ {
        expires 6M;
        access_log off;
    }
}
EOL

    # Create a soft link in /etc/nginx/sites-enabled
    echo "Creating symbolic link for Nginx configuration..."
    sudo ln -s $NGINX_CONF $NGINX_LINK
else
    echo "Nginx configuration file already exists."
fi

# Step 11: Test and reload Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t
if [ $? -eq 0 ]; then
    echo "Reloading Nginx..."
    sudo systemctl reload nginx
else
    echo "Nginx configuration test failed. Please check the configuration."
    exit 1
fi

# Step 12: Run React app locally (for development purposes, if needed)

echo "Deployment complete!"
