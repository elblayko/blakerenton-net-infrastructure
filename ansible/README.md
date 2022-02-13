Ansible playbooks to create a baseline Ubuntu host.

## Configuration

Configure `.env.yml` as required:
- username:  The remote user account to create
- password_hash:  The SHA-512 encoded password hash.  Create this using `mkpasswd --hash=SHA-512` from the `whois` package.
- public_key_file:  The location of the OpenSSH public key file, i.e. `/home/blake/.ssh/id_rsa.pub`

Modify `inventory` as required.

## SSH Agent

In order to avoid entering the SSH private key passphrase for multiple hosts when running playbooks, add the key to the SSH agent.

- Start the agent: `eval "$(ssh-agent -s)"`
- Add the key: `ssh-add ~/.ssh/id_ed25519`

## Usage Examples
```
ansible-playbook -i inventory add-sudo-user.yml -u root
ansible-playbook -i inventory add-user.yml
ansible-playbook -i inventory disable-root.yml
ansible-playbook -i inventory install-docker.yml
ansible-playbook -i inventory update-all.yml
ansible-playbook -i inventory enable-firewall.yml
```