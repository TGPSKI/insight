resource "null_resource" "db_setup" {

  provisioner "local-exec" {

    command = "psql -h localhost -p 5432 -U \"${data.terraform_remote_state.stage1.outputs.db_user}\" -d ${data.terraform_remote_state.stage1.outputs.db} -f \"DB-INIT.SQL\""

    environment = {
      PGPASSWORD = "${data.terraform_remote_state.stage1.outputs.db_pass}"
    }
  }
}
