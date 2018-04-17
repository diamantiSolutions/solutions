# External Jenkins Master connection to Diamanti
You can use a Diamanti cluster as your Jenkins CI/CD pipeline executor, by deploying slave nodes in the cluster.

In order to accomplish this you will need a few things to already be in place:
1. Jenkins instance which will act as the Master
2. FQDN/IP of the master
3. Ensure that Jenkins is setup to have a fixed JNLP port under Global Security
4. A project in which we want Jenkins workloads to be executed in
5. [Kubernetes Jenkins Plugin](https://wiki.jenkins.io/display/JENKINS/Kubernetes+Plugin)

## Setting up Requirements
1. `kubectl create ns jenkins` you can use whatever name you find most appropriate, just replace the `-n jenkins` with the name you choose
2. `kubectl -n jenkins create sa jenkins` create the Service Account with which we will authenticate to the cluster from the Master
3. `kubectl -n jenkins get sa/jenkins --template='{{range .secrets}}{{ .name }} {{end}}' | xargs -n 1 kubectl -n jenkins get secret --template='{{ if .data.token }}{{ .data.token }}{{end}}' | head -n 1 | base64 -d` run this in order to grab and decrypt the Service Account token to use for authentication. NOTE: you need base64 installed on whatever system you run this. If you do not have it installed you can remove that part and use something like https://www.base64decode.org/ to decode the Token

## Setting up the Jenkins master
1. Visit https://your_jenkins_master/configureSecurity/ (Manage Jenkins/Configure Global Security)
2. Find the section: _TCP port for JNLP agents_ and make sure it is set to **Fixed**, take note of the port number you use as the fixed port and save your configuration
3. Make sure the Kubernetes plugin is installed, and if not install it, by visiting the plugins section of your master https://your_jenkins_master/pluginManager/
  * If you do not have it installed, click on the Available tab and search for Kubernetes
  * At a minimum you will need the Kubernetes plugin, if you would like you can also install the Kubernetes::Pipeline::Kubernetes Steps and Kubernetes::Pipeline::DevOps Steps as well, but they are not required for this to work
3. Next go to to the global configuration section https://your_jenkins_master/configure (Manage Jenkins/Configure System)
  * Find the Cloud section, usually all the way at the bottom of the page
  * Add a new Cloud
  * You can name it whatever you would like, however, by default the Pipeline steps accept _kubernetes_, so if you would like to not specify a cloud name every time you execute a pipeline step, naming it _kubernetes_ will give you the option.
  * Set the Kubernetes URL to your Diamanti cluster VIP:6443 e.g.: https://1.2.3.4:6443
  * Plug in the name of the namespace you created earlier, for this example we use _jenkins_
  * Set the Jenkins URL to https://your_jenkins_master:JNLP_PORT this is the **Fixed** port we set earlier in this section for JNLP
  * Next click on the ADD button next to Credentials
  * Change Kind to Secret Text
  * Paste the token we decrypted in step 3 of the Requirements section
  * Give it a name, e.g.: _production_, _development_,_staging_
  * Click Add
  * Make sure the new Secret you created is selected from the dropdown
  * Click the **Test Connection** button on the right
4. If everything worked, click the Save button

## Testing the new connection
You are now ready to exectue workloads in your Diamanti cluster!
Setting up pipelines and kubernetes pod templates are beyond the scope of this document, however, you can make sure everything is working by deploying a new Pipeline project

1. Create a New Item
2. Choose Pipeline Project
3. Use the following Pipeline code as your example:
```
podTemplate(label: 'mypod', name: 'jenkins-slave', slaveConnectTimeout: 180,
  containers: [
        containerTemplate(name: 'nginx-cafe-example', image: 'nginxdemos/hello:plain-text'),
]) {
    node('mypod') {
        stage('Integration Test') {
            try {
                container('nginx-cafe-example') {
                    sh 'nc -z localhost:80 && echo "connected to nginx"'
                    def logs = containerLog(name: 'nginx-cafe-example', returnLog: true, tailingLines: 5, sinceSeconds: 20, limitBytes: 50000)
                    echo logs
                }
            } catch (Exception e) {
                containerLog 'nginx-cafe-example'
                throw e
            }
        }
    }
}
```
This pulls down a simple Hello World nginx image and connects to it, echoes out the container log (which should contain an Acess entry for our localhost test) and exists
