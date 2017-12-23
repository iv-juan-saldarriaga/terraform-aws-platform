variable "region" {
    type        = "string"
    description = "The region to deploy into"
}

variable "platform_instance_id" {
    type        = "string"
    description = "A human-readable string for this instance of the GrayMeta Platform"
}

variable "ecs_subnet_id" {
    type        = "string"
    description = "The subnet ID to use to deploy the ECS cluster into"
}

variable "services_subnet_id_1" {
    type = "string"
    description = "The first subnet ID to use to deploy the services cluster into. Needs to be in a different AZ than services_subnet_id_2"
}

variable "services_subnet_id_2" {
    type = "string"
    description = "The second subnet ID to use to deploy the services cluster into. Needs to be in a different AZ than services_subnet_id_1"
}

variable "rds_subnet_id_1" {
    type = "string"
    description = "The first subnet ID to use to deploy the RDS database into. Needs to be in a different AZ than rds_subnet_id_2"
}

variable "rds_subnet_id_2" {
    type = "string"
    description = "The second subnet ID to use to deploy the RDS database into. Needs to be in a different AZ than rds_subnet_id_1"
}

variable "public_subnet_id_1" {
    type = "string"
    description = "The first public subnet ID to use. Needs to be in a different AZ than public_subnet_id_2"
}

variable "public_subnet_id_2" {
    type = "string"
    description = "The second public subnet ID to use. Needs to be in a different AZ than public_subnet_id_1"
}

variable "elasticsearch_subnet_id_1" {
    type = "string"
    description = "The first elasticsearch subnet ID to use. Needs to be in a different AZ than elasticsearch_subnet_id_2"
}

variable "elasticsearch_subnet_id_2" {
    type = "string"
    description = "The second elasticsearch subnet ID to use. Needs to be in a different AZ than elasticsearch_subnet_id_1"
}

variable "ecs_max_cluster_size" {
    type        = "string"
    description = "The maxiumum number of nodes in the ECS cluster"
}

variable "ecs_min_cluster_size" {
    type        = "string"
    description = "The minimum number of nodes in the ECS cluster"
    default     = "1"
}

variable "services_max_cluster_size" {
    type        = "string"
    description = "The maxiumum number of nodes in the Services cluster"
}

variable "services_min_cluster_size" {
    type        = "string"
    description = "The minimum number of nodes in the Services cluster"
    default     = "2"
}

variable "ecs_instance_type" {
    type        = "string"
    description = "The Instance Type to use for ECS nodes"
    default     = "c4.large"
}

variable "services_instance_type" {
    type        = "string"
    description = "The Instance Type to use for Services nodes"
    default     = "m4.large"
}

variable "key_name" {
    type        = "string"
    description = "The name of the EC2 keypair to deploy to instances"
}

variable "platform_access_cidrs" {
    type        = "string"
    description = "A comma delimited list of CIDRs from which to allow access to the site."
}

variable "ecs_nat_ip" {
    type        = "string"
    description = "The public IP all traffic from the ECS cluster is NAT'ed through to allow access to the APIs"
}

variable "ssl_certificate_arn" {
    type        = "string"
    description = "The ARN of the SSL certificate to use to secure the endpoints. Must be a valid CA issued certificate (no self-signed certs)"
}

variable "db_password" {
    type        = "string"
    description = "password for postgresql database"
}

variable "db_username" {
    type        = "string"
    description = "username for postgresql database"
}

variable "db_instance_size" {
    type        = "string"
    description = "The size of the instance to use for the RDS database instance"
    default     = "db.t2.small"
}

variable "file_storage_s3_bucket_arn" {
    type        = "string"
    description = "The ARN of the s3 bucket to store thumbnails, video previews, and metadata files"
}

variable "client_secret_fe" {
    type        = "string"
    description = "32 character string used to generate tokens"
}

variable "client_secret_internal" {
    type        = "string"
    description = "32 character string used to generate tokens used internally by the system."
}

variable "dns_name" {
    type        = "string"
    description = "The DNS hostname that will be used to access the plaform (ex. graymeta.example.com)"
}

variable "encryption_key" {
    type        = "string"
    description = "32 Character string used to encrypt data prior to storage in the database"
}

variable "facebox_key" {
    type        = "string"
    description = "A facebox PRO license key. See http://machinebox.io"
}

variable "geonames_user" {
    type        = "string"
    description = "A GeoNames username for geolocation. See http://www.geonames.org/"
}

variable "google_maps_key" {
    type        = "string"
    description = "A Google maps key"
}

variable "jwt_key" {
    type        = "string"
    description = "A 32 character string used to encrypt JWT web tokens"
}

variable "watson_speech_password" {
    type        = "string"
    description = "Watson speech-to-text password"
}

variable "watson_speech_username" {
    type        = "string"
    description = "Watson speech-to-text username"
}

variable "weather_api_key" {
    type        = "string"
    description = "A API key. See forecast.io"
}

variable "google_speech_auth_json" {
    type        = "string"
    description = "base64 encoded json google speech configuration"
}

variable "google_speech_bucket" {
    type        = "string"
    description = "google storage bucket for uploading files for speech to text"
}

variable "google_speech_project_id" {
    type        = "string"
    description = "google speech project ID"
}

variable "azure_face_api_key" {
    type        = "string"
    description = "Azure faces API key. https://azure.microsoft.com/en-us/services/cognitive-services/face/"
}

variable "azure_emotion_key" {
    type        = "string"
    description = "Azure emotion API key. https://azure.microsoft.com/en-us/services/cognitive-services/emotion/"
}

variable "google_vision_key" {
    type        = "string"
    description = "Google vision API key"
}

variable "google_vision_features" {
    type        = "string"
    description = "A comma-delimited list of features to use for google vision (ex. FACE_DETECTION,IMAGE_PROPERTIES,LABEL_DETECTION,LANDMARK_DETECTION,LOGO_DETECTION,SAFE_SEARCH_DETECTION,TEXT_DETECTION)"
}

variable "pic_purify_key" {
    type        = "string"
    description = "PicPurify API key. See https://www.picpurify.com/"
}

variable "pic_purify_tasks" {
    type        = "string"
    description = "Comma delimited list of PicPurify tasks to run. (ex. porn_detection)"
}

variable "azure_vision_key" {
    type        = "string"
    description = "Azure vision API key. See https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/"
}

variable "languageid_apptek_host" {
    type        = "string"
    description = "Apptek Language ID server URL. Contact GrayMeta."
}

variable "languageid_apptek_password" {
    type        = "string"
    description = "Apptek Language ID password. Contact GrayMeta."
}

variable "languageid_apptek_segment_length" {
    type        = "string"
    description = "Apptek Language ID segment length expressed as a Golang duration string. A duration string is a possibly signed sequence of decimal numbers, each with optional fraction and a unit suffix, such as `300ms`, `-1.5h` or `2h45m`. Valid time units are `ns`, `us` (or `µs`), `ms`, `s`, `m`, `h`."
}

variable "languageid_apptek_username" {
    type        = "string"
    description = "Apptek Language ID username. Contact GrayMeta."
}

variable "microsoft_speech_api_key" {
    type        = "string"
    description = "Azure speech to text api key. https://docs.microsoft.com/en-us/azure/cognitive-services/speech/home"
}

variable "safety_dm_host" {
    type        = "string"
    description = "DimensionalMechanics safety model host URL. Contact GrayMeta."
}

variable "safety_dm_pass" {
    type        = "string"
    description = "DimensionalMechanics safety model password. Contact GrayMeta."
}

variable "safety_dm_user" {
    type        = "string"
    description = "DimensionalMechanics safety model username. Contact GrayMeta."
}

variable "speech_apptek_concurrency" {
    type        = "string"
    default     = "5"
    description = "Number of segments to run in parallel through Apptek speech to text."
}

variable "speech_apptek_host" {
    type        = "string"
    description = "Apptek speech to text hostname. Contact GrayMeta."
}

variable "speech_apptek_password" {
    type        = "string"
    description = "Apptek speech to text password. Contact GrayMeta."
}

variable "speech_apptek_username" {
    type        = "string"
    description = "Apptek speech to text username. Contact GrayMeta."
}

variable elasticache_instance_type_services {
    type        = "string"
    description = "Instance type for Services cluster Redis cache"
    default     = "cache.m4.large"
}

variable elasticache_instance_type_facebox {
    type        = "string"
    description = "Instance type for Facebox Redis cache"
    default     = "cache.m4.large"
}

variable ssh_cidr_blocks {
    type        = "string"
    description = "Comma delimited list of cidr blocks from which to allow access via SSH"
}

variable "notifications_from_addr" {
    type        = "string"
    description = "The email address to use as the From address on email notifications. This must be an SES verified email address"
}

# per-region ECS AMI can be found at  http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
# Limiting factor for region support is EFS: http://docs.aws.amazon.com/general/latest/gr/rande.html#elasticfilesystem-region
variable ecs_amis {
    type        = "map"
    description = "map of region to ami for ecs nodes"
    default = {
        "us-east-1"      = "ami-ec33cc96"
        "us-east-2"      = "ami-34032e51"
        "us-west-2"      = "ami-29f80351"
        "ap-southeast-2" = "ami-4f08e82d"
        "eu-west-1"      = "ami-13f7226a"
    }
}

variable services_amis {
    type        = "map"
    description = "map of region to ami for services nodes"
    default = {
        "us-east-1"      = "ami-822d53f8"
        "us-east-2"      = "ami-86f8d0e3"
        "us-west-2"      = "ami-8d8f2df5"
        "ap-southeast-2" = "ami-d9da2bbb"
        "eu-west-1"      = "ami-dbe96aa2"
    }
}
