This configuration makes the assumption that there are matching SSH public keys available at GitHub and DigitalOcean.  The DigitalOcean public key is used during operating system provision with Terraform to allow access to the root user account.  The GitHub public key is applied to user accounts created with Ansible.  All keys available on GitHub may be used to log into the created user account.

The key ID or fingerprint must be added to `terraform/main.tf` under the `digitalocean_droplet` resource.

The GitHub public key may be modified at: 
https://github.com/settings/keys

The DigitalOcean public key may be modified at:
https://cloud.digitalocean.com/account/security

# Usage

## Required environment variables:

`.bashrc/.zshrc`:
```
# https://dash.cloudflare.com/profile/api-tokens
export TF_VAR_cf_key=cloudflare-api-key

# CloudFlare associated e-mail address.
export TF_VAR_cf_email=mail@domain.com

# Available in CloudFlare zone dashboard.
export TF_VAR_cf_zone_id=cloudflare-zone-id

# https://cloud.digitalocean.com/account/api/tokens
export TF_VAR_do_token=digital-ocean-token
```

## Apply provider configuration:

```
cd terraform && terraform apply
```
Annotate the IPv4 address.

## Apply Ansible configuration:

Create a unix user account with sudo capabilities.  Add a comma for in-line hosts or specify an inventory file.  The playbook expects "username", "password", and "gh_user" environment variables.
```
$ ansible-playbook -i 127.0.0.1, add-sudo-user.yml -u root
```

Run setup playbooks.
```
ansible-playbook -i 127.0.0.1, {disable-root.yml,rate-limit.yml,update-all.yml,install-docker.yml}
```

Deploy the web application.
```
$ ansible-playbook -i 127.0.0.1, deploy-web.yml
```

# CloudFlare SSL/TLS Configuration

CloudFlare's SSL/TLS encryption mode must be set to either Full or Full (strict) to prevent a redirect loop.  The setting may be managed in the zone's SSL/TLS settings page.