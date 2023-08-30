/*
    This modules is meant to be used to create a backup plan supported aws backup service.
*/
resource "aws_backup_vault" "this" {
  name = var.vault_name
}

resource "aws_backup_vault" "drp_this" {
  count    = var.enable_drp_replication ? 1 : 0
  provider = aws.drp
  name     = "${var.vault_name}-drp"
}

resource "aws_backup_plan" "this" {
  name = "${var.vault_name}-backup-plan"

  rule {
    rule_name         = "${var.vault_name}-plan-rule"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 3 * * ? *)" # every 24 hours

    copy_action {
      lifecycle {
        cold_storage_after = 0
        delete_after       = 30
      }
      destination_vault_arn = aws_backup_vault.drp_this.0.arn
    }

    lifecycle {
      delete_after = 30
    }
  }

}

data "aws_iam_policy_document" "backup_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "backup.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

data "aws_iam_policy" "this" {
  name = "AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role" "this" {
  name               = "${var.vault_name}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = data.aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

resource "aws_backup_selection" "this" {
  name         = "${var.vault_name}-backup-selection"
  iam_role_arn = aws_iam_role.this.arn
  plan_id      = aws_backup_plan.this.id

  resources = var.target_resources_arn #Backup will be taken from the read replica

}
