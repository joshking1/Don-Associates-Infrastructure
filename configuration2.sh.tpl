#!/bin/bash

# Update package lists
apt-get update

# Install necessary packages
apt-get install -y apache2 wget php libapache2-mod-php php-mysql mysql-client unzip

# Enable PHP module
a2enmod php7.4

# Restart Apache to apply changes
systemctl restart apache2

# Remove the default Apache index.html if it exists
if [ -f /var/www/html/index.html ]; then
    rm /var/www/html/index.html
fi

# Download lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/

# Create the hospital front page with new patient registration and all requested features
cat <<EOF > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
  <title>Cristiana Hospital</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
    header { background: #4CAF50; color: white; padding: 1em 0; text-align: center; }
    nav { text-align: center; margin: 1em 0; }
    nav a { margin: 0 1em; text-decoration: none; color: #4CAF50; }
    .container { padding: 1em; }
    .section { margin: 2em 0; }
    footer { background: #333; color: white; text-align: center; padding: 1em 0; }
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Add Logo Here</h1>
      <h2>Welcome to Cristiana Hospital</h2>
    </div>
  </header>
  <nav>
    <a href="#services">Services</a>
    <a href="#departments">Departments</a>
    <a href="#appointments">Appointments</a>
    <a href="#contact">Contact Us</a>
    <a href="#patient-portal">Patient Portal</a>
    <a href="#news">News</a>
    <a href="#resources">Health Resources</a>
    <a href="#testimonials">Testimonials</a>
    <a href="#directions">Directions</a>
    <a href="#insurance">Insurance</a>
    <a href="#covid">COVID-19</a>
    <a href="#careers">Careers</a>
  </nav>
  <div class="container">
    <div id="services" class="section">
      <h2>Our Services</h2>
      <p>We offer a wide range of medical services to cater to your health needs.</p>
    </div>
    <div id="departments" class="section">
      <h2>Departments</h2>
      <p>Explore our various departments such as Cardiology, Pediatrics, Orthopedics, and more.</p>
    </div>
    <div id="appointments" class="section">
      <h2>Appointment Scheduling</h2>
      <p><a href="appointments.php">Schedule your appointment online</a></p>
    </div>
    <div id="contact" class="section">
      <h2>Contact Us</h2>
      <p>For any inquiries, please contact us at (123) 456-7890 or email us at info@cristianahospital.com.</p>
    </div>
    <div id="patient-portal" class="section">
      <h2>Patient Portal</h2>
      <p><a href="patient-portal.php">Access your medical records and test results</a></p>
    </div>
    <div id="news" class="section">
      <h2>News and Announcements</h2>
      <p>Stay updated with the latest news and announcements from our hospital.</p>
    </div>
    <div id="resources" class="section">
      <h2>Health Resources</h2>
      <p>Read health articles and access patient education materials.</p>
    </div>
    <div id="testimonials" class="section">
      <h2>Patient Testimonials</h2>
      <p>Read stories and testimonials from our patients.</p>
    </div>
    <div id="directions" class="section">
      <h2>Location and Directions</h2>
      <p>Find us on the map and get directions to our hospital.</p>
    </div>
    <div id="insurance" class="section">
      <h2>Insurance and Billing</h2>
      <p>Information on accepted insurance plans, billing procedures, and financial assistance.</p>
    </div>
    <div id="covid" class="section">
      <h2>COVID-19 Information</h2>
      <p>Get updates and resources related to COVID-19, including vaccination information, testing locations, and safety protocols.</p>
    </div>
    <div id="careers" class="section">
      <h2>Careers and Volunteering</h2>
      <p>Explore job openings and volunteer opportunities at our hospital.</p>
    </div>
  </div>
  <footer>
    <p>&copy; 2024 Cristiana Hospital. All rights reserved.</p>
  </footer>
</body>
</html>
EOF

# Create a simple registration form
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

# Enable and start Apache web server
systemctl enable apache2
systemctl restart apache2





