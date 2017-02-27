# Google Cloud Engine with Terraform

This project describe how to manage Google Cloud Engine infrastructure with Terraform.

For the moment there is just one example, a network with a compute instance (nginx inside) and a firewall which allows to 80 and 22 ports.

## Deployment

Firstly you need to get and your Service Account ( [here](https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances) ) and put your key in the parent folder of your project with the name `key.json`

Next, you need to export some environment variables

```
export GOOGLE_PROJECT="<your_project_id>"
export GOOGLE_CLOUD_KEYFILE_JSON=$(cat <your_exported_key_as_json)
```


Go to the example that you want to instanciate and do :
`terraform plan` or `terraform apply`



If you want to customize some variables. Create a file `terraform.tfvars`
```
region="<region_name>"
...
```

Enjoy !
