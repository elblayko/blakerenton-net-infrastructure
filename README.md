This configuration makes the assumption that there are matching SSH public keys available at GitHub and DigitalOcean.  The DigitalOcean public key is used during operating system provision with Terraform to allow access to the root user account.  The GitHub public key is applied to user accounts created with Ansible.  All keys available on GitHub may be used to log into the created user account.

The key ID or fingerprint must be added to `terraform/main.tf` under the `digitalocean_droplet` resource.

The GitHub public key may be modified at: 
https://github.com/settings/keys

The DigitalOcean public key may be modified at:
https://cloud.digitalocean.com/account/security

# Usage

## Configure API keys:

`.bashrc/.zshrc` or in-line:
```
# https://cloud.digitalocean.com/account/api/tokens
export TF_VAR_do_token=digital-ocean-token

# https://dash.cloudflare.com/profile/api-tokens
export TF_VAR_cf_key=cloudflare-api-key

# CloudFlare associated e-mail address.
export TF_VAR_cf_email=mail@domain.com

# Available in CloudFlare zone dashboard.
export TF_VAR_cf_zone_id=cloudflare-zone-id
```

## Apply provider configuration:

```
cd terraform && terraform apply
```
Annotate the IPv4 address and add to `ansible/inventory`

## Apply Ansible configuration:

```
cd ansible

# Create a unix user account with sudo capabilities.
username="name" password="pw" gh_user="username" ansible-playbook -i inventory add-sudo-user.yml -u root

# Run remaining playbooks.  Add a comma for in-line hosts or specify an inventory file.
ansible-playbook -i 127.0.0.1, {disable-root.yml,rate-limit.yml,update-all.yml,install-docker.yml}
```
