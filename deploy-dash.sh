#!/bin/bash

: ${STORAGE_ACCOUNTS:=5}
: ${NAME_PREFIX:=cbdash}
: ${LOCATION:="West Europe"}
: ${CSCONFIG_FILE:="ServiceConfiguration.Cloud.cscfg"}

set_params() {
  if [ $# -ne 0 ]; then
    if [ $# -eq 2 ] || [ $# -eq 4 ]; then
      for ((i_flag=1;i_flag<=$#;i_flag=i_flag+2)); do
        case "${!i_flag}" in
          --prefix)
            local i_value=$((i_flag+1))
            NAME_PREFIX="${!i_value}"
            ;;
          --accounts)
            local i_value=$((i_flag+1))
            STORAGE_ACCOUNTS="${!i_value}"
            local re='^[0-9]+$'
            if ! [[ $STORAGE_ACCOUNTS =~ $re ]]; then
              echo "--accounts is not a number!"
              usage
            fi
            ;;
          *)
            usage
            ;;
        esac
      done
    else
      usage
    fi
  fi
}

print_params() {
  echo "Number of storage accounts: $STORAGE_ACCOUNTS"
  echo "Name prefix: $NAME_PREFIX"
  echo "Location of storage accounts: $LOCATION"
}

deploy_dash() {
  # TODO: exit if an azure command fails
  azure login
  azure config mode asm

  declare -a account_names

  for ((i=0;i<=STORAGE_ACCOUNTS;i++)); do
    # TODO: generate a hash to make them unique
    hash=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9'| fold -w 16 | head -n 1)
    account_name="$NAME_PREFIX$i$hash"
    account_names[$i]=$account_name
    # TODO: location as input parameter
    azure storage account create -l "$LOCATION" --type LRS "$account_name"
  done

  write_first_part

  # TODO: generate random
  hash=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9'| fold -w 16 | head -n 1)
  dash_account_name="${NAME_PREFIX}${hash}"
  dash_account_key=$(head -c 64 /dev/urandom | base64)
  echo '      <Setting name="AccountName" value="'"$dash_account_name"'" />' >> $CSCONFIG_FILE
  echo '      <Setting name="AccountKey" value="'"$dash_account_key"'" />' >> $CSCONFIG_FILE
  echo '      <Setting name="SecondaryAccountKey" value="" />' >> $CSCONFIG_FILE

  declare -i i=0
  for account_name in ${account_names[@]}; do
    account_key=$(azure storage account keys list --json "$account_name" | jq -r .primaryKey)
    [[ $i -eq 0 ]] && setting_name="StorageConnectionStringMaster" || setting_name="ScaleoutStorage$((i-1))"
    storage_setting='      <Setting name="'"$setting_name"'" value="DefaultEndpointsProtocol=https;AccountName='$account_name';AccountKey='"$account_key"'" />'
    echo "$storage_setting" >> $CSCONFIG_FILE
    ((i++))
  done

  write_final_part

  # TODO: create cloud service with the config file and the package uri 
  create_cloud_service $dash_account_name

  print_info $dash_account_name $dash_account_key
}

write_first_part() {
  # TODO: Instances count??
  cat>$CSCONFIG_FILE<<EOF
<?xml version="1.0" encoding="utf-8"?>
<ServiceConfiguration serviceName="DashServer.Azure" xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceConfiguration" osFamily="4" osVersion="*" schemaVersion="2014-06.2.4">
  <Role name="DashServer">
    <Instances count="1" />
    <ConfigurationSettings>
      <Setting name="Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" value="" />
EOF
}

write_final_part() {
  cat>>$CSCONFIG_FILE<<EOF
      <Setting name="LogNormalOperations" value="true" />
      <Setting name="ReplicationPathPattern" value="" />
      <Setting name="ReplicationMetadataName" value="" />
      <Setting name="ReplicationMetadataValue" value="" />
      <Setting name="WorkerQueueName" value="" />
      <Setting name="AsyncWorkerTimeout" value="" />
      <Setting name="WorkerQueueInitialDelay" value="" />
      <Setting name="WorkerQueueDequeueLimit" value="" />
    </ConfigurationSettings>
    <Certificates></Certificates>
  </Role>
</ServiceConfiguration>
EOF
}

create_cloud_service() {
  # TODO
  echo "creating cloud service $1"
}

print_info() {
  echo "AccountName = $1"
  echo "AccountKey = $2"
}

usage() {
  echo "usage: deploy-dash --accounts num --prefix value"
  exit 1
}

main() {
  set_params "$@"
  print_params
  deploy_dash
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"