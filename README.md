## Deploy DASH easily!

DASH deployer is a small project that can be used to easily deploy Microsoft's [DASH](https://github.com/MicrosoftDX/Dash) project to an Azure cloud service.
The project first creates the namespace account and the scaleout storage accounts, builds the *.cscfg* configuration file based on the created storage account names and keys, generates an Account Name and an Account Key for the DASH service and finally deploys the cloud service package file to a new cloud service.

### Usage

```
docker run -it sequenceiq/dash-deployer:0.4 --accounts 5 --prefix dash --location "West Europe"
```

*Options:*

**--accounts**: The number of *scaleout* storage accounts to create. The number specified here doesn't include the namespace storage account. Default is *5*.

**--prefix**: The name prefix of the storage accounts and cloud service that will be created by the tool. The generated names include a 10 chars alphanumeric hash because storage account names should be globally unique in Azure. Default is *dash*.

**--location**: The Azure region where the resources will be created. Default is "West Europe". 

### Notes

The project uses the Azure Xplat CLI's patched version, because the original version doesn't contain any commands to deploy a package to a cloud service.
