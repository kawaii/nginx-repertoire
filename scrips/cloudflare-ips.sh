#!/bin/bash

cloudFlareConf="/etc/nginx/cloudflare.conf"
IPV4=$(curl -s "https://www.cloudflare.com/ips-v4")
IPV6=$(curl -s "https://www.cloudflare.com/ips-v6")
DATE="$(date)"

echo "# Last updated ${DATE}" > ${cloudFlareConf}

for IPV4ip in ${IPV4}
do
  echo "set_real_ip_from ${IPV4ip};" >> ${cloudFlareConf}
done

for IPV6ip in ${IPV6}
do
  echo "set_real_ip_from ${IPV6ip};" >> ${cloudFlareConf}
done

echo "real_ip_header CF-Connecting-IP;" >> ${cloudFlareConf}
