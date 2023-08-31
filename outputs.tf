output "backup_vault_arn" {
  value = aws_backup_vault.this.arn
}

output "backup_drp_vault_arn" {
  value = aws_backup_vault.drp_this.arn
}

output "backup_plan_arn" {
  value = aws_backup_plan.this.arn
}

output "backup_iam_role_arn" {
  value = aws_iam_role.this.arn
}

output "backup_iam_role_name" {
  value = aws_iam_role.this.name
}

output "backup_selection_id" {
  value = aws_backup_selection.this.id
}

