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
  <title>SHEILA TRUCKS AND LOGISTICS</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
    header { background: #003366; color: white; padding: 1em 0; text-align: center; }
    nav { text-align: center; margin: 1em 0; }
    nav a { margin: 0 1em; text-decoration: none; color: #003366; }
    .container { padding: 2em; }
    .section { margin: 2em 0; padding: 1em; background: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    .form-container { display: flex; justify-content: space-between; align-items: center; }
    .form-container form { display: inline-block; }
    footer { background: #003366; color: white; text-align: center; padding: 1em 0; }
    img.logo { width: 150px; }
  </style>
</head>
<body>
  <header>
    <div>
      <img src="Logo for the company.JPG" alt="Company Logo" class="logo">
      <h2>Welcome to SHEILA TRUCKS AND LOGISTICS</h2>
      <p>Director of Trading and Financial Instruments: Josh Wahome</p>
      <p>Address: 1 Earhart Dr, Coatesville, PA 19320</p>
      <p>Hours: Closed ⋅ Opens 9 AM Fri</p>
      <p>Phone: (917) 746-1193</p>
    </div>
    <div class="form-container">
      <form action="signup.php" method="post">
        <button type="submit">Sign Up</button>
      </form>
      <form action="login.php" method="post">
        <button type="submit">Login</button>
      </form>
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
      <p>At SHEILA TRUCKS AND LOGISTICS, we offer a comprehensive range of financial services tailored to meet the unique needs of our clients. Our services include wealth management, investment advisory, financial planning, and risk management. We also specialize in financial instruments such as Bank Guarantees. Our goal is to help you achieve financial stability and growth through personalized strategies and expert guidance.</p>
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
      <p>We are here to answer any questions you may have about our services. You can reach us by phone at (917) 746-1193, by email at info@sheilalogistics.com, or by visiting our office at 1 Earhart Dr, Coatesville, PA 19320. Our team is dedicated to providing prompt and professional assistance to all our clients.</p>
    </div>
    <div id="client-portal" class="section">
      <h2>Client Portal</h2>
      <p>Our client portal provides you with secure access to your financial statements, investment reports, and other important documents. You can manage your account, track your investments, and stay informed about your financial status anytime, anywhere. Our client portal is designed to provide you with the convenience and transparency you need to stay on top of your finances.</p>
      <p><a href="client-portal.php">Access your financial statements and reports</a></p>
    </div>
    <div id="news" class="section">
      <h2>News and Announcements</h2>
      <p>Stay updated with the latest news and announcements from SHEILA TRUCKS AND LOGISTICS. We provide insights into market trends, financial updates, and company news to keep you informed. Our goal is to empower you with the knowledge you need to make informed financial decisions.</p>
    </div>
    <div id="resources" class="section">
      <h2>Financial Resources</h2>
      <p>Our financial resources section offers a wealth of information to help you understand and manage your finances better. From articles and guides to tools and calculators, we provide valuable resources to support your financial journey. Explore our resources to gain insights and make informed decisions about your financial future.</p>
    </div>
    <div id="testimonials" class="section">
      <h2>Client Testimonials</h2>
      <p>Read stories and testimonials from our clients who have experienced the exceptional service and support of SHEILA TRUCKS AND LOGISTICS. Our clients' success and satisfaction are our top priorities. Discover how we have helped individuals and businesses achieve their financial goals.</p>
    </div>
    <div id="directions" class="section">
      <h2>Location and Directions</h2>
      <p>Find us on the map and get directions to our office. SHEILA TRUCKS AND LOGISTICS is conveniently located at 1 Earhart Dr, Coatesville, PA 19320. Our office is easily accessible by public transportation and offers ample parking for your convenience. We look forward to your visit.</p>
    </div>
    <div id="careers" class="section">
      <h2>Careers and Opportunities</h2>
      <p>Explore job openings and career opportunities at SHEILA TRUCKS AND LOGISTICS. We are always looking for talented and dedicated professionals to join our team. If you are passionate about finance and committed to excellence, we would love to hear from you. Visit our careers page to learn more about available positions and how to apply.</p>
    </div>
  </div>
  <footer>
    <p>&copy; 2024 SHEILA TRUCKS AND LOGISTICS. All rights reserved.</p>
  </footer>
</body>
</html>
EOF

# Create a simple registration form
cat <<EOF > /var/www/html/signup.php
<!DOCTYPE html>
<html>
<head>
  <title>Sign Up</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
    .container { width: 300px; margin: 50px auto; background: white; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; }
    form { display: flex; flex-direction: column; }
    label { margin: 10px 0 5px; }
    input { padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; }
    button { padding: 10px; background: #003366; color: white; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background: #005bb5; }
  </style>
</head>
<body>
  <div class="container">
    <h2>Sign Up</h2>
    <form action="register.php" method="post">
      <label for="firstname">First Name:</label>
      <input type="text" id="firstname" name="firstname" required>
      <label for="lastname">Last Name:</label>
      <input type="text" id="lastname" name="lastname" required>
      <label for="phone">Phone Number:</label>
      <input type="tel" id="phone" name="phone" required>
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required>
      <label for="address">Address:</label>
      <input type="text" id="address" name="address" required>
      <button type="submit">Sign Up</button>
    </form>
  </div>
</body>
</html>
EOF

cat <<EOF > /var/www/html/login.php
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
    .container { width: 300px; margin: 50px auto; background: white; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; }
    form { display: flex; flex-direction: column; }
    label { margin: 10px 0 5px; }
    input { padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; }
    button { padding: 10px; background: #003366; color: white; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background: #005bb5; }
  </style>
</head>
<body>
  <div class="container">
    <h2>Login</h2>
    <form action="login-process.php" method="post">
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" required>
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required>
      <button type="submit">Login</button>
    </form>
  </div>
</body>
</html>
EOF

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
  \$firstname = \$_POST['firstname'];
  \$lastname = \$_POST['lastname'];
  \$phone = \$_POST['phone'];
  \$email = \$_POST['email'];
  \$address = \$_POST['address'];
  \$username = \$_POST['username'];
  \$password = \$_POST['password'];

  // Insert user into database
  \$sql = "INSERT INTO users (firstname, lastname, phone, email, address, username, password) VALUES ('\$firstname', '\$lastname', '\$phone', '\$email', '\$address', '\$username', '\$password')";
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
mysql -h ${db_endpoint} -P 3306 -u admin -ppassword -e "USE mydatabase; CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, firstname VARCHAR(50) NOT NULL, lastname VARCHAR(50) NOT NULL, phone VARCHAR(15) NOT NULL, email VARCHAR(50) NOT NULL, address VARCHAR(100) NOT NULL, username VARCHAR(50) NOT NULL, password VARCHAR(50) NOT NULL);"

# Enable and start Apache web server
systemctl enable apache2
systemctl restart apache2
