# azure-devops-kubernetes-pipeline-cicd- Dev & Qa Environments
Final outPut Deployed into Dev and Qa Environments with Manual Approval 
![image](https://github.com/nanisravankumar/azure-devops-pipeline-cicd/assets/83820408/4b7a2df5-66ee-47ca-ade3-b609227e397a)

# Note: One Aks Cluster dev and qa Namespaces env divided
# Note: Here Environments divided by Azure App configuration Labels dev and qa

### Prerequisites
1. **Repositories**
   - **flipkart_frontend**: Contains Kubernetes manifest files and the main pipeline.yml file.
   - **pipeline_central_repo**: Contains centralized pipeline code, including YAML files for dev, QA, manual approval, and Azure App Configuration.

2. **Service Principal**
   - **Name**: Azuresubscription
   - **Role**: Azure App Configuration Data Owner
   - **Usage**: SP name value is passed in the main pipeline.yml file in the variables section.

3. **Kubernetes Service Connection**
   - **Name**: akstestclusterserviceconnection
   - **Configuration**:
     - Select Subscription (requires login)
     - Namespace: kube-system (accessible for all namespaces)

4. **AKS Cluster**
   - **Name**: akstestcluster

5. **Azure App Configuration**
   - **Name**: aksconfiguration

6. **Manual Approval**
   - Change email address

### Repository Structure
#### flipkart_frontend
- **Directory**:
  - `pipeline.yml`: Main pipeline file.
  - `deployment-template.yml`: Kubernetes manifest file.

#### pipeline_central_repo
- **Directory**:
  - `dev-deploy.yml`: Pipeline for Dev deployment.
  - `qa-deploy.yml`: Pipeline for QA deployment.
  - `manualvalidation.yml`: Pipeline for manual approval.
  - `appconfiguration.yml`: Azure App Configuration settings.
 
**Kubernetes Service Connection creation**
![image](https://github.com/nanisravankumar/azure-devops-pipeline-cicd/assets/83820408/0e57a027-6d75-4cf5-b161-22dddfbb4413)

**Azure App Configuration Values Creation**
![image](https://github.com/nanisravankumar/azure-devops-pipeline-cicd/assets/83820408/011b20dc-be75-4fb1-be49-271e633f6066)

### Below Values passed in Azure App Configuration
Label dev and qa
   - image: 'nginx:latest'
   - name: 'fn-dep'
   - port: 80
   - replicas: 3
   - app: 'nginx'
     
