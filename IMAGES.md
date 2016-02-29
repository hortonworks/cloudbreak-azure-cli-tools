
We use this image also for automating the process of azure-rm image copy.

- Azure rm image is built in northeurope region only
- An extra step needed to copy the vhd to all other storage accounts.

## Usage

The script is built into a docker image:

```
docker run -it --rm \
  -v ~/.azure:/root/.azure \
  -v $PWD:/work \
  -w /work \
  -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
  -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
  -e ARM_GROUP_NAME=$ARM_GROUP_NAME \
  -e ARM_STORAGE_ACCOUNT=$ARM_STORAGE_ACCOUNT \
  -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
  -e ARM_TENANT_ID=$ARM_TENANT_ID \
  --entrypoint /bin/azure-functions \
  sequenceiq/azure-cli-tools:1.5
```

## Configuration

By default the source image name is queried from atlas, and will be used as the destination image name.

Source images are built by packer into `sequenceiqnortheurope2` storage account in the `system` container.
Destination image will be copied to the `images` container with the name queried from atlas (image_name meta-data)

If you want to customize the destination image name, for example for testimg the process, use the 
`AZURE_DESTINATION_IMAGE_PREFIX` env variable.

For the above docker command ypu can ad a new `-e` option:
```
docker run -it --rm \
  -v ~/.azure:/root/.azure \
  -v $PWD:/work \
  -w /work \
  -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
  -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
  -e ARM_GROUP_NAME=$ARM_GROUP_NAME \
  -e ARM_STORAGE_ACCOUNT=$ARM_STORAGE_ACCOUNT \
  -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
  -e ARM_TENANT_ID=$ARM_TENANT_ID \
  -e AZURE_DESTINATION_IMAGE_PREFIX=test- \
  --entrypoint /bin/azure-functions \
  sequenceiq/azure-cli-tools:1.5
```

