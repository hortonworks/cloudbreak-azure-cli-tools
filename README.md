## Deploy DASH easily!

DASH deployer is a small project that can be used to easily deploy Microsoft's [DASH](https://github.com/MicrosoftDX/Dash) project to an Azure cloud service.
The project first creates the namespace account and the scaleout storage accounts, builds the *.cscfg* configuration file based on the created storage account names and keys, generates an Account Name and an Account Key for the DASH service and finally deploys the cloud service package file to a new cloud service.

### Notes

- The project uses the Azure Xplat CLI's patched version, because the original version doesn't contain any commands to deploy a package to a cloud service.
- The generated Azure resource names include a 12 characters long alphanumeric hash because storage account names should be globally unique in Azure.

### Usage

#### With Docker (recommended)

```
docker run -it sequenceiq/dash-deployer:0.4 --accounts 5 --prefix dash --location "West Europe" --instances 3
```

*Options:*

**--accounts**: The number of *scaleout* storage accounts to create. The number specified here doesn't include the namespace storage account. Default is *5*.

**--prefix**: The name prefix of the storage accounts and cloud service that will be created by the tool. Must be between 1 and 10 characters, only numbers and lowercase letters are accepted. Default is *dash*.

**--location**: The Azure region where the resources will be created. Default is *West Europe*. 

**--instances**: The number of virtual machines to create in the cloud service. Default is *1*.

#### Without Docker

The script can be run without Docker, but it is not recommended (see Notes - the Docker container has all the required dependencies)

- get the patched Azure CLI by cloning it from Github: `git clone https://github.com/sequenceiq/azure-xplat-cli.git`
- run `npm install` in the `azure-xplat-cli` directory
- set the `AZURE_CLI_LOCATION` environment variable to the `azure-xplat-cli` directory
- set the `CSCONFIG_FILE` variable to a local path, where the `.cscfg` file will be created

**Example:**

```
AZURE_CLI_LOCATION=../azure-xplat-cli CSCONFIG_FILE=./ServiceConfiguration.Cloud.cscfg ./deploy_dash --accounts 5 --prefix dash --location "West Europe" --instances 3
```
