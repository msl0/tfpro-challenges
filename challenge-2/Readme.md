
## Challenge 2

This challenge is primarily designed to test your understanding of Modules by requiring you to refactor large configuration by splitting into multiple child  modules.


### Tasks:

#### 1. Deploy the Resources

Deploy all the resources by running `terraform apply -auto-approve`

#### 2. Replace Hard Coded Value with Data Source

Use the `aws_ami` data source to replace the hardcoded AMI ID from the configuration and fetch the value dynamically.

> [!CAUTION]
> The EC2 instance should not be recreated and must use same AMI ID as Step 1.

#### 3. Split to Multiple Modules

Split the code into multiple child modules as described in below table

| Resources  | Child Module Name | 
| :---        |    :----:   | 
| `aws_instance`,`aws_ami`  | ec2      | 
| `aws_security_group` | sg    | 
| `aws_vpc_security_group_ingress_rule` | sg    | 
| `aws_s3_bucket`  | s3        |
| `aws_s3_object`  | s3        |  
| `aws_iam_*`  | iam      | 
| Random Pet  | random      | 

Run the `terraform init` command to re-initialize.

#### 4. Temporarily Add Hardcoded Values

Comment out `bucket` argument in S3 module and add a new argument with hardcoded value.
Comment out `name` argument in IAM  module and add a new argument with hardcoded value.
Comment out `instance_profile` argument in EC2 module and add a new argument with hardcoded value.


Ensure there are no errors when you run `terraform plan`

#### 5. Configure Addressing

Change the resource address in state file so that it reflects the splitting of resources to multiple child modules.

After completing previous step, run `terraform plan` and ensures there are no changes
```sh
Plan: 0 to add, 0 to change, 0 to destroy.
```
### 6. Remove the Hard Coded Values added in Step 4

* The hardcoded values that were added in Step 4 needs to be removed.
  
* EC2 module must fetch the value of `iam_instance_profile` dynamically so that any change in value of `iam_instance_profile` can also be addressed in EC2 module.
  
* IAM and S3 module must fetch the values of random_pet dynamically similar to the previous step.
  
* After completing previous step, run `terraform apply` and ensure there are no changes.

#### 7. Destroy Infrastructure

Destroy all the created infrastructure with `terraform destroy -auto-approve`