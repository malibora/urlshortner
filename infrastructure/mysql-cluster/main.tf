# main.tf

module "db" {
  source = "github.com/terraform-yc-modules/terraform-yc-mysql"

  network_id               = "enp7tva0919aur9e6not"
  name                     = "sample-app"
  description              = "Single-node MySQL cluster for test purposes"
  security_groups_ids_list = [yandex_vpc_security_group.mysql_sg[0].id]

  maintenance_window = {
    type = "WEEKLY"
    day  = "SUN"
    hour = "02"
  }

  access_policy = {
    web_sql = true
  }

  performance_diagnostics = {
    enabled = true
  }

  hosts_definition = [
    {
      zone             = "ru-central1-a"
      assign_public_ip = true
      subnet_id        = "e9budt6on26su6bubprj"
    }
  ]

  mysql_config = {
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
    transaction_isolation         = "READ_COMMITTED"
    character_set_server          = "utf8"
    collation_server              = "utf8_unicode_ci"
  }

  databases = [{ "name" : "simpleapp" }]

  users = [
    {
      name        = "simpleapp-owner"
      permissions = [{ "database_name" : "simpleapp" }]
    },
    {
      name               = "simpleapp-proc"
      global_permissions = ["PROCESS"]
    }
  ]
}

resource "yandex_vpc_security_group" "mysql_sg" {
  count       = 1
  name        = "sg-mysql"
  description = "mysql security group"
  network_id  = "enp7tva0919aur9e6not"

  ingress {
    protocol       = "TCP"
    description    = "incoming-mysql"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3306
  }

  egress {
    protocol       = "ANY"
    description    = "outgoing-all"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}