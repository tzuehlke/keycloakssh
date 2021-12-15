# Info
This repository provides a Keycloak Dockerfile with SSH (on Port 2222) for deployment on Azure App Services with Containers. You can read the [blogpost](https://blog.zuehlke.cloud/2021/12/keycloak-with-ssh-on-azure-app-services/) with some more details and find the [image at Docker-Hub](https://hub.docker.com/r/tzuehlke/keycloakssh).

# Creating the first Admin User
If you start with a fresh database or using the in-memory storage, you do not have the MASTER realm. The realm will be created with the first user.
You can use the SSH shell of the App Service to connect to the container as root and run the following command:
```
/opt/jboss/keycloak/bin/add-user-keycloak.sh -u 'myadmin' -p 'P@ssw0rd'
/opt/jboss/keycloak/bin/jboss-cli.sh --connect command=:reload
```

# Configure Keycloak URL
If you deploy the container to an Azure App Service, it will be listen to http://localhost:8080. To change this URL during running of the container, connect with SSH and run the following commands:
``` 
/opt/jboss/keycloak/bin/jboss-cli.sh --connect
/subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=properties.frontendUrl,value="https://<YOUR-APP-SERVICE-NAME>.azurewebsites.net/auth/")
/subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=properties.forceBackendUrlToFrontendUrl,value="true")
:reload
```