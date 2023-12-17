variable "db_password" {
  description = "The password for the RDS instance"
  default = "password"  # you can remove the default value if you don't want to have a default 
  sensitive = true
}