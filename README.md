# Workstation Ansible playbooks

This repository sets up various operating systems to my own preference.
The playbooks can be run against the local machine:

    ./user-cli.yml -i ./local.ini

Or they can be run against a remote machine:

    ./user-cli.yml -i target.example.com,

Note that the trailing comma is important when using a remote hostname.

## Cloning without SSL verification

Some platforms (NetBSD, FreeBSD) do not include root SSL certificates by default.
This causes the initial git clone to fail with the error _server certificate verification failed_.
You can ignore SSL warnings with the `GIT_SSL_NO_VERIFY=true` environment variable:

    GIT_SSL_NO_VERIFY=true git clone https://github.com/acperkins/workstation.git

This will clone without checking the validation of the root certificates.
This should only be done for the initial clone.
The playbooks should be configured to set up SSL trust for all future actions (for example by installing and configuring the `mozilla-rootcerts-openssl` package on NetBSD, or the `ca_root_nss` package on FreeBSD).
