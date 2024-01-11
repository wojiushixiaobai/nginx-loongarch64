Code status:
------------

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by  [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.

## Debian Repository

- [x] linux/loongarch64

### Debian buster (10)

```sh
# Nginx 1.24.0
wget -qO - https://dl.cloudsmith.io/public/jumpserver/nginx/gpg.A88DE6DF47F26374.key | gpg --dearmor > /etc/apt/trusted.gpg.d/jumpserver-nginx.gpg

echo "deb [arch=loongarch64] https://dl.cloudsmith.io/public/jumpserver/nginx/deb/debian buster main" > /etc/apt/sources.list.d/jumpserver-nginx.list
```