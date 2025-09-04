locals {
  csv           = csvdecode(file("./ec2.csv"))
  instance_type = distinct([for v in local.csv : v.instance_type])
}

output "debug" {
  value = local.csv
}

output "list_amis" {
  value = [for value in local.csv : value.AMI_ID]
}


output "unique_team_names" {
  value = distinct([for value in local.csv : value.Team_Name])
}

output "regions_list_of_lists" {
  value = [for value in local.csv : [value.Region]]
}


output "list_list_condition" {
  value = [for value in local.csv : [value.Region] if value.instance_type == "nano"]
}


output "instance_count_by_type" {
  value = { for instance_type in distinct([for v in local.csv : v.instance_type]) : instance_type => length([for v in local.csv : v.instance_type if v.instance_type == instance_type]) }
}

output "instance_details" {
  value = [for instance in local.csv : {
    team = instance.Team_Name
    type = instance.instance_type
  }]
}

output "map_of_maps" {
  value = { for instance in local.csv : join("_", [instance.instance_type, instance.Region, instance.Team_Name]) => {
    ami_id = instance.AMI_ID
    type   = instance.instance_type
    region = instance.Region
    team   = instance.Team_Name
  } }
}
