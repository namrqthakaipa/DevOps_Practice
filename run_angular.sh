#!/bin/bash

# Define variables
REPO_URL="https://github.com/panda98r/Angular-HelloWorld.git"  # Replace with your GitHub repository URL
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
    echo "Repository not found locally. Cloning Angular project from GitHub..."
    git clone $REPO_URL $APP_NAME
else
    echo "Repository already exists locally. Checking for updates..."
    cd $APP_NAME

    # Fetch updates from the remote repository
    git fetch origin main

    # Check if there are new changes to pull
    LOCAL_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse origin/main)
    if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo "New updates found. Pulling latest changes..."
        git pull origin main
    else
        echo "No updates found. Repository is up to date."
    fi

    cd ..
fi


# Step 4: Navigate to the project directory
cd $APP_NAME


# Step 5: Install dependencies
echo "Installing dependencies..."
npm install

# Step 6: Build the Angular application
echo "Building the Angular application..."
ng build --configuration production

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
echo "Creating Nginx configuration file..."
sudo bash -c "cat > $NGINX_CONF" <<EOL
server {
    server_name angular.namkaipa.site;

    root $DEST_DIR/angular-hello-world;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOL

# Remove the existing symbolic link if it exists
if [ -L "$NGINX_LINK" ]; then
    echo "Removing existing symbolic link for Nginx configuration..."
    sudo rm "$NGINX_LINK"
fi

# Create a soft link in /etc/nginx/sites-enabled
echo "Creating symbolic link for Nginx configuration..."
sudo ln -s $NGINX_CONF $NGINX_LINK

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

echo "Deployment complete!"
