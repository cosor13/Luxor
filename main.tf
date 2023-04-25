data"google_billing_account""acct"{                                       
  display_name =var.account_setup["billing_account_name"]
  open         =true
}
resource"random_password""password"{
  length  =16
  number  =false
  special =false
  lower   =true
  upper   =false
}

resource"google_project""testproject"{                                             
  name            =var.account_setup["project_name"]
  project_id      =random_password.password.result
  billing_account =data.google_billing_account.acct.id
}

resource"null_resource""set-project"{                                                 
  depends_on =[
    google_project.testproject
  ]
  triggers ={
    always_run ="${timestamp()}"
  }

  provisioner"local-exec"{
    command ="gcloud config set project ${google_project.testproject.project_id}"
  }
}

resource"null_resource""enable-apis"{                                              
  depends_on =[
    google_project.testproject,
    null_resource.set-project
  ]
  triggers ={
    always_run ="${timestamp()}"
  }

  provisioner"local-exec"{
    command =<<-EOT
        gcloud services enable compute.googleapis.com
        gcloud services enable dns.googleapis.com
        gcloud services enable storage-api.googleapis.com
        gcloud services enable container.googleapis.com
    EOT
  }
}

resource"google_storage_bucket""backend-bucket"{                      
  depends_on =[
    null_resource.enable-apis,
    google_project.testproject
  ]
  name          ="${var.account_setup["bucket_name"]}-${random_password.password.result}"
  location      ="US"
  force_destroy =true
  storage_class ="COLDLINE"
  project       =google_project.testproject.project_id
}
resource"null_resource""unset-project"{
  provisioner"local-exec"{
    when    =destroy
    command ="gcloud config unset project"
  }
}
variable"account_setup"{                                                                   
  type =map(any)
  default ={
    billing_account_name ="My Billing Account"
    project_name         ="testprojectx"
    bucket_name          ="backend"
  }
}
