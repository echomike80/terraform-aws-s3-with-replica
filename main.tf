locals {
  s3_bucket_name            = format("s3-%s-%s", var.name, var.random_suffix)
  s3_bucket_name_replica    = var.create_replica_bucket ? format("s3-%s-%s-replica", var.name, var.random_suffix) : var.use_existing_replica_bucket
}

provider "aws" {
  region = var.region_origin
}

provider "aws" {
  region = var.region_replica
  alias = "replica"
}

resource "aws_iam_role" "s3replica" {
  name = format("rl-%s-%s-s3replica", var.name, var.random_suffix)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3replica" {
  name        = format("pol-%s-%s-s3replica", var.name, var.random_suffix)
  description = "A policy for S3 bucket replication"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "s3:GetReplicationConfiguration",
            "s3:ListBucket"
         ],
         "Resource":[
            "arn:aws:s3:::${local.s3_bucket_name}"
         ]
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging"
         ],
         "Resource":[
            "arn:aws:s3:::${local.s3_bucket_name}/*"
         ]
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags"
         ],
         "Resource":"arn:aws:s3:::${local.s3_bucket_name_replica}/*"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3replica-attach" {
  role       = aws_iam_role.s3replica.name
  policy_arn = aws_iam_policy.s3replica.arn
}

module "s3_bucket_replica" {
  count   = var.create_replica_bucket ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.7.0"

  providers = {
    aws = aws.replica
  }

  bucket = local.s3_bucket_name_replica
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = var.tags
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "2.7.0"

  bucket = local.s3_bucket_name
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "AES256"
      }
    }
  }

  replication_configuration = {
    role = aws_iam_role.s3replica.arn

    rules = [
      {
        id     = "everything-without-filters"
        status = "Enabled"

        destination = {
          bucket        = "arn:aws:s3:::${local.s3_bucket_name_replica}"
          storage_class = "STANDARD"
        }
      },
    ]
  }

  tags = var.tags
}