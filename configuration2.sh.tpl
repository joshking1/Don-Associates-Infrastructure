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

# Create the financial company front page with new client registration and all requested features
cat <<EOF > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
  <title>Don & Associates Financial Company</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
    header { background: #003366; color: white; padding: 1em 0; text-align: center; }
    nav { text-align: center; margin: 1em 0; }
    nav a { margin: 0 1em; text-decoration: none; color: #003366; }
    .container { padding: 2em; }
    .section { margin: 2em 0; padding: 1em; background: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    footer { background: #003366; color: white; text-align: center; padding: 1em 0; }
    img.logo { width: 150px; }
  </style>
</head>
<body>
  <header>
    <div>
      <img src="Logo for the company.JPG" alt="Company Logo" class="logo">
      <h2>Welcome to Don & Associates Financial Company</h2>
      <p>Director of Trading and Financial Instruments: Josh Wahome</p>
      <p>Address: 22 W 32nd St, New York, NY 10001</p>
      <p>Hours: Closed ⋅ Opens 9 AM Fri</p>
      <p>Phone: (917) 746-1193</p>
    </div>
  </header>
  <nav>
    <a href="#services">Services</a>
    <a href="#team">Our Team</a>
    <a href="#appointments">Appointments</a>
    <a href="#contact">Contact Us</a>
    <a href="#client-portal">Client Portal</a>
    <a href="#news">News</a>
    <a href="#resources">Financial Resources</a>
    <a href="#testimonials">Testimonials</a>
    <a href="#directions">Directions</a>
    <a href="#careers">Careers</a>
  </nav>
  <div class="container">
    <div id="services" class="section">
      <h2>Our Services</h2>
      <p>At Don & Associates Financial Company, we offer a comprehensive range of financial services tailored to meet the unique needs of our clients. Our services include wealth management, investment advisory, financial planning, and risk management. We also specialize in financial instruments such as Bank Guarantees. Our goal is to help you achieve financial stability and growth through personalized strategies and expert guidance.</p>
    </div>
    <div id="team" class="section">
      <h2>Our Team</h2>
      <p>Our team of experienced financial advisors and professionals is dedicated to providing exceptional service and support. Led by Josh Wahome, the Director of Trading and Financial Instruments, our team brings a wealth of knowledge and expertise to help you navigate the complex world of finance. We are committed to building long-term relationships with our clients based on trust, integrity, and excellence.</p>
    </div>
    <div id="appointments" class="section">
      <h2>Appointment Scheduling</h2>
      <p>Scheduling an appointment with us is easy and convenient. Whether you need financial advice, investment planning, or any other financial service, you can book your appointment online or by calling our office. Our advisors are available to meet with you at a time that works best for you. We look forward to assisting you with your financial needs.</p>
      <p><a href="appointments.php">Schedule your appointment online</a></p>
    </div>
    <div id="contact" class="section">
      <h2>Contact Us</h2>
      <p>We are here to answer any questions you may have about our services. You can reach us by phone at (917) 746-1193, by email at info@donandassociates.com, or by visiting our office at 22 W 32nd St, New York, NY 10001. Our team is dedicated to providing prompt and professional assistance to all our clients.</p>
    </div>
    <div id="client-portal" class="section">
      <h2>Client Portal</h2>
      <p>Our client portal provides you with secure access to your financial statements, investment reports, and other important documents. You can manage your account, track your investments, and stay informed about your financial status anytime, anywhere. Our client portal is designed to provide you with the convenience and transparency you need to stay on top of your finances.</p>
      <p><a href="client-portal.php">Access your financial statements and reports</a></p>
    </div>
    <div id="news" class="section">
      <h2>News and Announcements</h2>
      <p>Stay updated with the latest news and announcements from Don & Associates Financial Company. We provide insights into market trends, financial updates, and company news to keep you informed. Our goal is to empower you with the knowledge you need to make informed financial decisions.</p>
    </div>
    <div id="resources" class="section">
      <h2>Financial Resources</h2>
      <p>Our financial resources section offers a wealth of information to help you understand and manage your finances better. From articles and guides to tools and calculators, we provide valuable resources to support your financial journey. Explore our resources to gain insights and make informed decisions about your financial future.</p>
    </div>
    <div id="testimonials" class="section">
      <h2>Client Testimonials</h2>
      <p>Read stories and testimonials from our clients who have experienced the exceptional service and support of Don & Associates Financial Company. Our clients' success and satisfaction are our top priorities. Discover how we have helped individuals and businesses achieve their financial goals.</p>
    </div>
    <div id="directions" class="section">
      <h2>Location and Directions</h2>
      <p>Find us on the map and get directions to our office. Don & Associates Financial Company is conveniently located at 22 W 32nd St, New York, NY 10001. Our office is easily accessible by public transportation and offers ample parking for your convenience. We look forward to your visit.</p>
    </div>
    <div id="careers" class="section">
      <h2>Careers and Opportunities</h2>
      <p>Explore job openings and career opportunities at Don & Associates Financial Company. We are always looking for talented and dedicated professionals to join our team. If you are passionate about finance and committed to excellence, we would love to hear from you. Visit our careers page to learn more about available positions and how to apply.</p>
    </div>
  </div>
  <footer>
    <p>&copy; 2024 Don & Associates Financial Company. All rights reserved.</p>
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






