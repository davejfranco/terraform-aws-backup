/*
    This modules is meant to be used to create a backup plan supported aws backup service.
*/
resource "aws_backup_vault" "this" {
  name = var.vault_name
}

resource "aws_backup_vault_lock_configuration" "this" {
  count             = var.lock_enabled ? 1 : 0
  backup_vault_name = var.vault_name
}

resource "aws_backup_vault" "drp_this" {
  provider = aws.drp
  name     = "${var.vault_name}-drp"
}

resource "aws_backup_vault_lock_configuration" "drp_this" {
  provider          = aws.drp
  count             = var.lock_enabled ? 1 : 0
  backup_vault_name = "${var.vault_name}-drp"
}

resource "aws_backup_plan" "this" {
  name = "${var.vault_name}-plan"

  rule {
    rule_name         = var.rule_name == null ? "default-rule" : "${var.vault_name}-rule"
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.schedule # every 24 hours by default

    lifecycle {
      cold_storage_after = var.plan_lifecycle.cold_storage_after
      delete_after       = var.plan_lifecycle.delete_after
    }
    copy_action {
      lifecycle {
        cold_storage_after = var.copy_lifecycle.cold_storage_after
        delete_after       = var.copy_lifecycle.delete_after
      }
      destination_vault_arn = aws_backup_vault.drp_this.arn
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
