#!/bin/bash

# Update Ansible Inventory Script
# This script extracts EC2 public IPs from Terraform outputs and updates Ansible inventory files

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/terraform"
ANSIBLE_DIR="$SCRIPT_DIR/ansible"

echo -e "${YELLOW}Starting Ansible inventory update...${NC}"

# Check if terraform directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
    echo -e "${RED}Error: Terraform directory not found at $TERRAFORM_DIR${NC}"
    exit 1
fi

# Check if ansible directory exists
if [ ! -d "$ANSIBLE_DIR" ]; then
    echo -e "${RED}Error: Ansible directory not found at $ANSIBLE_DIR${NC}"
    exit 1
fi

# Change to terraform directory
cd "$TERRAFORM_DIR"

# Check if terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    echo -e "${RED}Error: terraform.tfstate not found. Please run 'terraform apply' first.${NC}"
    exit 1
fi

echo -e "${YELLOW}Extracting IP addresses from Terraform outputs...${NC}"

# Function to update inventory file
update_inventory() {
    local env=$1
    local output_name=$2
    local inventory_file="$ANSIBLE_DIR/inventories/$env"
    
    echo -e "${YELLOW}Processing $env environment...${NC}"
    
    # Get IPs from terraform output
    local ips=$(terraform output -json "$output_name" | jq -r '.[]')
    
    if [ -z "$ips" ]; then
        echo -e "${RED}Error: No IPs found for $env environment${NC}"
        return 1
    fi
    
    # Convert IPs to array
    local ip_array=($ips)
    local server_count=${#ip_array[@]}
    
    echo -e "${GREEN}Found $server_count IP(s) for $env: ${ip_array[*]}${NC}"
    
    # Create backup directory if it doesn't exist
    local backup_dir="$ANSIBLE_DIR/inventories/backup"
    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
        echo -e "${YELLOW}Created backup directory: $backup_dir${NC}"
    fi
    
    # Backup existing inventory file
    if [ -f "$inventory_file" ]; then
        local backup_file="$backup_dir/${env}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$inventory_file" "$backup_file"
        echo -e "${YELLOW}Backed up existing inventory file to: $backup_file${NC}"
        
        # Keep only last 2 backups for this environment
        local backup_count=$(ls -1 "$backup_dir/${env}.backup."* 2>/dev/null | wc -l)
        if [ "$backup_count" -gt 2 ]; then
            # Remove oldest backups, keep only 2 most recent
            ls -1t "$backup_dir/${env}.backup."* | tail -n +3 | xargs rm -f
            echo -e "${YELLOW}Cleaned up old backups, keeping last 2 for $env${NC}"
        fi
    fi
    
    # Create new inventory file
    cat > "$inventory_file" << EOF
[servers]
EOF
    
    # Add server entries
    for i in "${!ip_array[@]}"; do
        local server_num=$((i + 1))
        echo "server$server_num ansible_host=${ip_array[$i]}" >> "$inventory_file"
    done
    
    # Add common variables
    cat >> "$inventory_file" << EOF

[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=path_to_your_private_key
ansible_python_interpreter=/usr/bin/python3
EOF
    
    echo -e "${GREEN}Updated $inventory_file${NC}"
}

# Update all environments
update_inventory "dev" "dev_infra_ec2_public_ips"
update_inventory "stg" "stg_infra_ec2_public_ips" 
update_inventory "prd" "prd_infra_ec2_public_ips"

echo -e "${GREEN}✅ All Ansible inventory files have been updated successfully!${NC}"
echo -e "${YELLOW}Backup files created with timestamp for rollback if needed.${NC}"

# Optional: Show what was updated
echo -e "\n${YELLOW}Current inventory status:${NC}"
for env in dev stg prd; do
    echo -e "\n${YELLOW}=== $env environment ===${NC}"
    if [ -f "$ANSIBLE_DIR/inventories/$env" ]; then
        grep "ansible_host" "$ANSIBLE_DIR/inventories/$env"
    else
        echo -e "${RED}Inventory file not found${NC}"
    fi
done