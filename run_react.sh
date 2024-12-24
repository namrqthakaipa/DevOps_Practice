#!/bin/bash

# Define variables
REPO_URL="https://github.com/your-username/angular_deploy.git"  # Replace with your GitHub repository URL
DEST_DIR="/var/www/html/angular"
APP_NAME="angular_deploy"  # Replace with your desired app name
NGINX_CONF="/etc/nginx/sites-available/angular"
NGINX_LINK="/etc/nginx/sites-enabled/angular"
DOMAIN_NAME="angular.namkaipa.site"  # Replace with your desired domain name

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

# Step 3: Clone the Angular project from GitHub (if not already cloned)
if [ ! -d "$APP_NAME" ]; then 
    echo "Cloning Angular project from GitHub..."
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

# Step 6: Build the Angular application
echo "Building the Angular application..."
npm run build -- --prod

# Step 7: Create the target directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating directory $DEST_DIR..."
    sudo mkdir -p $DEST_DIR
fi

# Step 8: Deploy the build folder to /var/www/html/angular
echo "Deploying build folder to $DEST_DIR..."
sudo rm -rf $DEST_DIR/*  # Remove any existing content in the destination folder
sudo cp -r dist/* $DEST_DIR

# Step 9: Set permissions for the deployed files
sudo chown -R www-data:www-data $DEST_DIR
sudo chmod -R 755 $DEST_DIR

# Step 10: Create an Nginx configuration file for the Angular app
if [ ! -f "$NGINX_CONF" ]; then
    echo "Creating Nginx configuration file..."
    sudo bash -c "cat > $NGINX_CONF" <<EOL
server {
    listen 80;
    server_name $DOMAIN_NAME;

    root $DEST_DIR;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
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

# Step 12: Update hosts file for local testing (optional)
if ! grep -q "$DOMAIN_NAME" /etc/hosts; then
    echo "Updating /etc/hosts for local testing..."
    echo "127.0.0.1 $DOMAIN_NAME" | sudo tee -a /etc/hosts
fi

echo "Deployment complete!"
