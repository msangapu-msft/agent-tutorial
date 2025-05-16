@description('Name of the App Service app')
param appName string = 'my-sre-app'

@description('Name of the App Service Plan')
param appServicePlanName string = '${appName}-plan'

@description('Location for the resources')
param location string = resourceGroup().location

@description('Name of the deployment slot')
param slotName string = 'broken'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PHP|8.4'
      appCommandLine: '/home/site/wwwroot/startup.sh'
    }
  }
}

resource deploymentSlot 'Microsoft.Web/sites/slots@2022-09-01' = {
  name: '${appName}/${slotName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PHP|8.4'
      appCommandLine: '/home/site/wwwroot/startup.sh'
    }
  }
}

resource logSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: '${appName}/web'
  properties: {
    applicationLogging: {
      fileSystem: {
        level: 'Information'
        retentionInDays: 3
      }
    }
  }
}
