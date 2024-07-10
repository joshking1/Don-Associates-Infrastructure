#!/bin/bash
# Update package lists
apt-get update

# Install necessary packages
apt-get install -y apache2 wget php php-mysql mysql-client

# Change Apache to listen on port 8080 instead of 80
sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
sed -i 's/<VirtualHost *:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf

# Download lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/

# Create a simple registration form
cat <<EOF > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
  <title>Student Registration</title>
</head>
<body>
  <h2>Student Registration Form</h2>
  <form action="register.php" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required><br><br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br><br>
    <input type="submit" value="Register">
  </form>
</body>
</html>
EOF

# Create PHP script to handle form submission
cat <<EOF > /var/www/html/register.php
<?php
\$servername = "${db_endpoint}";
\$username = "admin";
\$password = "password";
\$dbname = "mydatabase";

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
  die("Connection failed: " . \$conn->connect_error);
}

if (\$_SERVER["REQUEST_METHOD"] == "POST") {
  \$user = \$_POST['username'];
  \$pass = \$_POST['password'];

  // Insert user into database
  \$sql = "INSERT INTO users (username, password) VALUES ('\$user', '\$pass')";
  if (\$conn->query(\$sql) === TRUE) {
    echo "New record created successfully";
  } else {
    echo "Error: " . \$sql . "<br>" . \$conn->error;
  }
}

\$conn->close();
?>
EOF

# Create the database and table
mysql -h ${db_endpoint} -P 3306 -u admin -ppassword -e "CREATE DATABASE IF NOT EXISTS mydatabase;"
mysql -h ${db_endpoint} -P 3306 -u admin -ppassword -e "USE mydatabase; CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL, password VARCHAR(50) NOT NULL);"

# Turn on web server
systemctl enable apache2
systemctl start apache2


