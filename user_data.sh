#!/bin/bash
sudo apt update
sudo apt install -y apache2 php
echo "<?php echo 'Hello From Terraform'; ?>" | sudo tee /var/www/html/index.php
sudo systemctl restart apache2
