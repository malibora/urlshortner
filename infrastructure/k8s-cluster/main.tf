module "kube" {
  source     = "github.com/terraform-yc-modules/terraform-yc-kubernetes"
  network_id = "enp7tva0919aur9e6not"

  master_locations   = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9budt6on26su6bubprj"
    },
    {
      zone      = "ru-central1-b" 
      subnet_id = "e2lb6dv9aabm8djao09f"
    },
    {
      zone      = "ru-central1-c" 
      subnet_id = "b0cnf9hn1d4bv3o8vkne"
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "ng-01"  = {
      description   = "Kubernetes nodes group 01"
      fixed_scale = {
        size = 3
      }
      node_locations   = [
        {
            zone      = "ru-central1-a"
            subnet_id = "e9budt6on26su6bubprj"
        },        
        {
            zone      = "ru-central1-b"
            subnet_id = "e2lb6dv9aabm8djao09f"
        }
      ]
      node_labels   = {
        role        = "worker-01"
        environment = "dev"
      }
      max_expansion   = 1
      max_unavailable = 1
    }
  }
}