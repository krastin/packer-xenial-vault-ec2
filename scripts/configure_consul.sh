#!/usr/bin/env bash

## Variables
# $NODE_NAME
# $ACCESS_KEY_ID
# $SECRET_ACCESS_KEY
# $CLUSTER

# Set up basic consul settings
if [ ! -z "$NODE_NAME" ]
then
  echo '{ "node_name": "'`cat /etc/hostname`'"}' > /etc/consul.d/node_name.json
else
  echo "{ \"node_name\": \"$NODE_NAME\"}" > /etc/consul.d/node_name.json
fi

cat <<EOF > /etc/consul.d/basic_config.json
{
  "data_dir": "/opt/consul",
  "log_level": "DEBUG",
  "enable_debug": true
}
EOF

# setup client settings
cat <<EOF >/etc/consul.d/client.json
{
  "server": false
}
EOF

if [ ! -z "$ACCESS_KEY_ID" ] && [ ! -z "$SECRET_ACCESS_KEY" ] && [ ! -z "$CLUSTER" ]
then
  cat <<EOF >/etc/consul.d/cloud_join.hcl
retry_join = ["provider=aws tag_key=CLUSTER tag_value=${CLUSTER} access_key_id=${ACCESS_KEY_ID} secret_access_key=${SECRET_ACCESS_KEY}"]    
EOF
fi

systemctl enable consul
systemctl start consul

sleep 3s
