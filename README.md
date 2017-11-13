# Deploying GrayMeta Platform with Terraform

* We use the CentOS 7 (x86_64) AMI as a base. You must accept their software terms of service in order to successfully deploy our platform. Browse to https://aws.amazon.com/marketplace/pp/B00O7WM7QW, select the `Continue` button in the upper-right corner, then select the "Manual Launch" tab, then accept their software terms of service by clicking the button in the upper-right hand corner of the page.
* Pick a _platform instance id_ for this deployment of the GrayMeta platform. A short, descriptive name like `production`, `labs`, `test`, etc. that can be used to uniquely identify this deployment of the GrayMeta Platform within your environment. Record this as variable `platform_instance_id`
* Pick which AWS region you want to deploy into from the list below:
  * us-east-1
  * us-east-2
  * us-west-2
  * ap-southeast-2
  * eu-west-1
* Pick the hostname which will be used to access the platform (example: graymeta.example.com). Record this value as the `dns_name` variable.
* Procure a valid SSL certificate for the hostname chosen in the previous step. Self-signed certificates will NOT work. Upload the SSL certificate to Amazon Certificate Manager in the same region you will be deploying the platform into. After upload, record the ARN of the certificate as variable `ssl_certificate_arn`
* Create an S3 bucket to store thumbnails, transcoded video and audio preview files, and metadata files. Record the ARN of the s3 bucket as variable `file_storage_s3_bucket_arn`.
* Stand up a network. If you don't want to manually stand up a network the `modules/network` module can be used to stand up all of the networking components:
  * Single VPC. VPC must have DNS host names enabled. Attach an internet gateway.
  * Stand up 7 subnets as follows and record the subnet ID of each:
    * Public subnet 1:
      * size: /24
      * availability zone: different than Public subnet 2
      * route 0.0.0.0/0 through the Internet gateway
      * record the subnet id as variable `public_subnet_id_1`
    * Public subnet 2:
      * size: /24
      * availability zone: different than Public subnet 1
      * route 0.0.0.0/0 through the Internet gateway
      * record the subnet id as variable `public_subnet_id_2`
    * Services subnet 1:
      * size: /24
      * availability zone: different than Services subnet 2
      * route 0.0.0.0/0 through the Services NAT gateway
      * record the subnet id as variable `services_subnet_id_1`
    * Services subnet 2:
      * size: /24
      * availability zone: different than Services subnet 1
      * route 0.0.0.0/0 through the Services NAT gateway
      * record the subnet id as variable `services_subnet_id_2`
    * RDS subnet 1:
      * size: As small as a /29 or as large as a /24
      * availability zone: different than RDS subnet 2
      * route 0.0.0.0/0 through the Services NAT gateway
      * record the subnet id as variable `rds_subnet_id_1`
    * RDS subnet 2:
      * size: As small as a /29 or as large as a /24
      * availability zone: different than RDS subnet 1
      * route 0.0.0.0/0 through the Services NAT gateway
      * record the subnet id as variable `rds_subnet_id_2`
    * ECS subnet:
      * size: /21
      * availability zone: no hard requirement here, but typically deployed in the same AZ as Services subnet 1
      * route 0.0.0.0/0 through the ECS NAT gateway
      * record the subnet id as variable `ecs_subnet_id_1`
    * Elasticsearch Subnet 1:
      * size: /24 (needs to be as large as `instance_count` / 2 * 3 addresses available where `instance_count` is the number of instances not counting dedicated master nodes in the ES cluster)
      * availability zone: different than Elasticsearch Subnet 2, should be same AZ as Services Subnet 1
      * route 0.0.0.0/0 through the Services NAT gateway
      * record the subnet id as variable `elasticsearch_subnet_id_1`
    * Elasticsearch Subnet 2:
      * size: /24 (needs to be as large as `instance_count` / 2 * 3 addresses available where `instance_count` is the number of instances not counting dedicated master nodes in the ES cluster)
      * availability zone: different than Elasticsearch Subnet 1, should be same AZ as Services Subnet 2
      * route 0.0.0.0/0 through the Services NAT gateway
      * record the subnet id as variable `elasticsearch_subnet_id_1`
  * Create a NAT gateway for the Services\* subnets.
  * Create a NAT gateway for the ECS subnet. Record the EIP assigned to the NAT gateway as variable `ecs_nat_ip`. Note that it must be in CIDR notation: `1.2.3.4/32`
* Decide the CIDR or CIDRs that will be allowed access to the platform. Record as comma delimited lists of CIDR blocks.
  * `platform_access_cidrs` - The list of CIDRs that will be allowed to access the web ports of the platform
  * `ssh_cidr_blocks` - The list of CIDRs that will be allowed SSH access to the servers. This is typically an admin or VPN subnet somewhere within your VPC.
* Fill in the rest of the variables, review the output of a `terraform plan`, then apply the changes.
* Create a CNAME from your `dns_name` to the value of the `GrayMetaPlatformEndpoint` output. This needs to be publicly resolvable.
* Load `https://dns_name` where _dns\_name_ is the name you chose above. The default username is `admin@graymeta.com`. The password is set to the instance ID of one of the Services nodes of the platform. These are tagged with the name `GrayMetaPlatform-${platform_instance_id}-Services` in the EC2 console. There should be at least 2 nodes running. Try the instance ID of both. After logging in for the first time, change the password of the `admin@graymeta.com` account. Create other accounts as necessary.

## Example

```

locals {
    platform_instance_id = "labs"
    key_name             = "jhancock"
}

provider "aws" {
    region = "us-east-1"
}

module "network" {
    source = "github.com/graymeta/terraform-aws-platform//modules/network?ref=v0.0.2"

    platform_instance_id = "${local.platform_instance_id}"
    region               = "us-east-1"
    az1                  = "us-east-1a"
    az2                  = "us-east-1b"
}

module "platform" {
    source = "github.com/graymeta/terraform-aws-platform?ref=v0.0.2"

    platform_instance_id       = "${local.platform_instance_id}"
    region                     = "us-east-1"
    key_name                   = "${local.key_name}"
    platform_access_cidrs      = "0.0.0.0/0"
    file_storage_s3_bucket_arn = "arn:aws:s3:::cfn-file-api"
    dns_name                   = "foo.cust.graymeta.com"
    ssl_certificate_arn        = "arn:aws:acm:us-east-1:913397769129:certificate/507e54c3-51a4-45b3-ae21-9cb4647bb671"

    # RDS Configuration
    db_username      = "mydbuser"
    db_password      = "mydbpassword"
    db_instance_size = "db.t2.small"

    # ECS Cluster Configuration
    ecs_instance_type    = "c4.large"
    ecs_max_cluster_size = 2
    ecs_min_cluster_size = 1

    # Services Cluster Configuration
    services_instance_type    = "m4.large"
    services_max_cluster_size = 4
    services_min_cluster_size = 2

    # Encryption Tokens - 32 character alpha numberic strings
    client_secret_fe       = "012345678901234567890123456789ab"
    client_secret_internal = "012345678901234567890123456789ab"
    jwt_key                = "012345678901234567890123456789ab"
    encryption_key         = "012345678901234567890123456789ab"

    # Elasticache Configuration
    elasticache_instance_type_services = "cache.m4.large"
    elasticache_instance_type_facebox  = "cache.m4.large"

    ecs_nat_ip                = "${module.network.ecs_nat_ip}/32"
    ecs_subnet_id             = "${module.network.ecs_subnet_id}"
    public_subnet_id_1        = "${module.network.public_subnet_id_1}"
    public_subnet_id_2        = "${module.network.public_subnet_id_2}"
    rds_subnet_id_1           = "${module.network.rds_subnet_id_1}"
    rds_subnet_id_2           = "${module.network.rds_subnet_id_2}"
    services_subnet_id_1      = "${module.network.services_subnet_id_1}"
    services_subnet_id_2      = "${module.network.services_subnet_id_2}"
    elasticsearch_subnet_id_1 = "${module.network.elasticsearch_subnet_id_1}"
    elasticsearch_subnet_id_2 = "${module.network.elasticsearch_subnet_id_2}"
    ssh_cidr_blocks           = "10.0.0.0/24,10.0.1.0/24"

    ###############################################################
    # Cognitive Service Configuration
    ###############################################################

    # Facebox API Key
    facebox_key                      = ""

    # Azure Vision
    azure_emotion_key                = ""
    azure_face_api_key               = ""
    azure_vision_key                 = ""

    # Geonames (geocoding)
    geonames_user                    = ""

    # Google maps (for plotting geocoded results on a map in the UI
    google_maps_key                  = ""

    # Google Speech To Text
    google_speech_auth_json          = ""
    google_speech_bucket             = ""
    google_speech_project_id         = ""

    # Google Vision
    google_vision_features           = ""
    google_vision_key                = ""

    # Apptek Language ID
    languageid_apptek_host           = ""
    languageid_apptek_password       = ""
    languageid_apptek_segment_length = ""
    languageid_apptek_username       = ""

    # Microsoft Speech to Text
    microsoft_speech_api_key         = ""

    # Pic Purify
    pic_purify_key                   = ""
    pic_purify_tasks                 = ""

    # DM Safety
    safety_dm_host                   = ""
    safety_dm_pass                   = ""
    safety_dm_user                   = ""

    # Apptek Speech To Text
    speech_apptek_concurrency        = ""
    speech_apptek_host               = ""
    speech_apptek_password           = ""
    speech_apptek_username           = ""

    # Watson Speech To Text
    watson_speech_password           = ""
    watson_speech_username           = ""

    # Weather (forecast.io API key)
    weather_api_key                  = ""
}

output "GrayMetaPlatformEndpoint" {
    value = "${module.platform.GrayMetaPlatformEndpoint}"
}
```
