# AWS Backup Plan Terraform Module

This Terraform module creates an AWS Backup Vault in our main region and in our DRP region for replication alongside a backup plan with configurable lifecycle policies and schedule.

## Usage

To use this module, include the following code in your Terraform configuration:

```terraform
module "aws_backup_plan" {
  source = "github.com/your-username/aws-backup-plan"

  vault_name = "my-backup-vault"
  rule_name  = "my-backup-rule"
  schedule   = "cron(0 12 * * ? *)"

  plan_lifecycle = {
    cold_storage_after = 30
    delete_after       = 365
  }

  copy_lifecycle = {
    cold_storage_after = 30
    delete_after       = 365
  }

  target_resources_arn = [
    "arn:aws:rds:us-west-2:123456789012:db:mydb",
    "arn:aws:dynamodb:us-west-2:123456789012:table/mytable",
  ]
}
```

## Inputs

| Name                  | Description                                                                                     | Type           | Default | Required |
|-----------------------|-------------------------------------------------------------------------------------------------|----------------|---------|----------|
| `region`              | Region to create the main vault resources .                                                     | `string`        | "eu-west-1" | No   |
| `drp_region`          | DRP Region to create the replacated vault resources .                                           | `string`       | "eu-central-1" | No|
| `vault_name`          | The name of the AWS Backup vault to associate with the backup plan.                             | `string`       | n/a     | Yes      |
| `lock_enabled`        | Whether or not to enable backup vault lock.                                                     | `bool`          | true    | Yes      |
| `rule_name`           | The name of the backup rule.                                                                    | `string`       | `null`  | No       |
| `schedule`            | The backup schedule in cron format.                                                             | `string`       | `"cron(0 0 * * ? *)"` | No       |
| `plan_lifecycle`      | The lifecycle policies for the backup plan.                                                     | `object`  | `{}`    | No       |
| `copy_lifecycle`      | The lifecycle policies for the copy action.                                                     | `object`  | `{}`    | No       |
| `target_resources_arn`| The resources to be backed up by the backup plan.                                                | `list(string)` | `[]`    | Yes       |

## Outputs

| Name                  | Description                                                                                     |
|-----------------------|-------------------------------------------------------------------------------------------------|
| `backup_vault_arn` | The ARN of the AWS Backup vault.                                                                   |
| `backup_drp_vault_arn`  | The ARN of the AWS Backup drp vault.                                                          |
| `aws_backup_vault_lock_configuration` | Vault lock configuration.                                                       |
| `backup_plan_arn`| The ARN of the AWS Backup plan.                                                                      |
| `backup_iam_role_arn` | The AWS Backup iam role ARN.                                                                    |
| `backup_iam_role_name` | The AWS Backup iam role name.                                                                  |
| `backup_selection_id` | The ID of the AWS Backup Selection associated with the backup plan and the iam role.            |