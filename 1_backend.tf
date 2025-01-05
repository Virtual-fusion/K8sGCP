terraform { 
  cloud { 
    
    organization = "virtualfusion-project-1" 

    workspaces { 
      name = "K8s-deployment2" 
    } 
  } 
}