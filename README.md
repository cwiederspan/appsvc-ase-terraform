# App Service Environment

This demo uses Terraform to create an Azure App Service Environment v3 (ASEv3) in a VNET.

## Inner Loop Development

```bash

cd terraform

# Use remote storage
terraform init --backend-config ./backend-secrets.tfvars

# Run the plan to see the changes
terraform plan \
-var 'base_name=cdw-asedemo-20210817' \
-var 'location=northcentralus' #\

# -var 'root_dns_name=something.com' \
# -var 'contact_name=John Doe' \
# -var 'contact_email=someemail@something.com' #\

#--var-file=secrets.tfvars


# Apply the script with the specified variable values
terraform apply \
-var 'base_name=cdw-asedemo-20210817' \
-var 'location=northcentralus' #\

# -var 'root_dns_name=something.com' \
# -var 'contact_name=John Doe' \
# -var 'contact_email=email@something.com' #\

#--var-file=secrets.tfvars

```
