#! /bin/bash
sudo apt update -y
sudo apt install -y nginx
sudo systemctl enable nginx
sudo service nginx start

# remove the default Nginx welcome page if it already exists
sudo rm /var/www/html/index.html

# create and customize the Nginx welcome page
echo "<h1>Welcome to Globant</h1>" | sudo tee /var/www/html/index.html
echo "<h2>Hello, Anis!</h2>" | sudo tee -a /var/www/html/index.html
echo "<p>This is your customized Nginx welcome page.</p>" | sudo tee -a /var/www/html/index.html