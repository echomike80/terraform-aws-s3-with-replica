# AWS S3 Bucket with replica Terraform module

Terraform module which creates an S3 bucket with a replica on AWS.

## Terraform versions

Terraform 0.12 and newer. 

## Usage

```hcl
module "s3_media" {
  source            = "/path/to/module/terraform-aws-s3-with-replica"
  name              = var.name
  random_suffix     = var.s3_random_suffix

  create_replica_bucket = true
  region_origin         = var.region_origin
  region_replica        = var.region_replica

  tags = {
    Environment     = var.environment,
    Project         = var.project,
    Ressource_group = var.ressource_group
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.65 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.7.0 |
| <a name="module_s3_bucket_replica"></a> [s3\_bucket\_replica](#module\_s3\_bucket\_replica) | terraform-aws-modules/s3-bucket/aws | 2.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.s3replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3replica-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_replica_bucket"></a> [create\_replica\_bucket](#input\_create\_replica\_bucket) | Create S3 bucket for replication | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all resources | `string` | n/a | yes |
| <a name="input_random_suffix"></a> [random\_suffix](#input\_random\_suffix) | Name to be used on S3 buckets as suffix | `string` | n/a | yes |
| <a name="input_region_origin"></a> [region\_origin](#input\_region\_origin) | Name of region from origin S3 bucket | `string` | `"eu-central-1"` | no |
| <a name="input_region_replica"></a> [region\_replica](#input\_region\_replica) | Name of region from replica S3 bucket | `string` | `"eu-central-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_use_existing_replica_bucket"></a> [use\_existing\_replica\_bucket](#input\_use\_existing\_replica\_bucket) | Name of an existing S3 bucket for replication, if create\_replica\_bucket is false | `string` | `"s3-bucket-that-already-exists"` | no |

## Outputs

No outputs.

## Sources

https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/setting-repl-config-perm-overview.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-config-for-kms-objects.html
https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/blob/v2.7.0/examples/s3-replication/main.tf
https://stackoverflow.com/questions/47957225/sse-encryption-of-s3-using-terraform

## Authors

Module managed by [Marcel Emmert](https://github.com/echomike80).

## License

Apache 2 Licensed. See LICENSE for full details.
