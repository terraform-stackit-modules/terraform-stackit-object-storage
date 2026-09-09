#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "object_storage" {
  source = "../.."

  project_id = var.project_id
  name       = "example-bucket-tf-stackit"

  credentials_groups = {
    app = {
      name = "example-app-credentials"
      credentials = [
        {
          name                 = "primary"
          expiration_timestamp = "2027-01-02T03:04:05Z"
        },
      ]
    }
  }
}
