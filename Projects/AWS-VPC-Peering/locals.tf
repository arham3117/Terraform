# ============================================================================
# Local Values
# ============================================================================
# This file defines local values that are computed and reused throughout
# the Terraform configuration. Locals help reduce repetition and improve
# maintainability.

locals {
  # --------------------------------------------------------------------------
  # User Data - Primary Instance
  # --------------------------------------------------------------------------
  # Bootstrap script that runs on first launch of the primary EC2 instance
  # Installs and configures Apache web server with a custom landing page
  # This allows us to test VPC peering by accessing the web server from the other VPC
  primary_user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update -y

    # Install Apache web server
    apt-get install -y apache2

    # Start Apache and enable it to start on boot
    systemctl start apache2
    systemctl enable apache2

    # Create custom index page with instance information
    echo "<h1>Primary VPC Instance - ${var.primary}</h1>" > /var/www/html/index.html
    echo "<p>Private IP: $(hostname -I)</p>" >> /var/www/html/index.html
  EOF

  # --------------------------------------------------------------------------
  # User Data - Secondary Instance
  # --------------------------------------------------------------------------
  # Bootstrap script that runs on first launch of the secondary EC2 instance
  # Installs and configures Apache web server with a custom landing page
  # This allows us to verify cross-region VPC peering connectivity
  secondary_user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update -y

    # Install Apache web server
    apt-get install -y apache2

    # Start Apache and enable it to start on boot
    systemctl start apache2
    systemctl enable apache2

    # Create custom index page with instance information
    echo "<h1>Secondary VPC Instance - ${var.secondary}</h1>" > /var/www/html/index.html
    echo "<p>Private IP: $(hostname -I)</p>" >> /var/www/html/index.html
  EOF
}