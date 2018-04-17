Prerequisit:
- Example assumes you have already running Docker registry as specified in groovy script of custom jenkins master docker image.
- Example assumes you have already running image-security tool lke aquasecurity is alreay deployed. This is also specified in groovy script of custom jenkins master docker image.
- If you need to use different name/dns for docker registry or aquasecurity scanner you can either manually modify in Jenkisn settings once its up and running. Or you can build your on jenkins-master image after modifying the aqua-cicd.groovy accordingly. This example can be further enahnced to pass this informaiton with env variables.


1.0. Use diamanti docker image or build your own. A pipeline defined for following flow is in ../../images/jenkns-master/groovy/aqua-cicd.groovy
```
code commit -> docker build -> aqua scan -> push to artifactory docker registry
```
Information about building image is at: [../../images/jenkns-master/]


2.0. create a jenkins namespace
```
kubectl create -f jenkins-ns.yaml
```

3.0. "enter jenkins namespace"
```
dctl namespace set jenkins
```

4.0. Setup RBAC.
     - Create jenkins service account so jenkins-master can create/delete slaves.
     - Create role
     - Create role binding.
```
kubectl create -f jenkins-sa.yaml
```

5.0. Create a static persistent volume. Alternatively you can create dynamically using persistent volume claim, but staticly created volume are easier to manage when recovering after crash/reset/rebuild.
```
dctl volume create jenkins-vol -s 100Gi -p high -f xfs
```

5.1. When creating the static persistent volume it will automatically create the PV for you. But in case we are recoveing from the crash/reset/rebuild, we will need to manually create the PV. So lets alsways try creating the PV, if it already exissits it will fail which is OK in this case.
```
kubectl create -f jenkins-master-pv.yaml
```

5.2. Claim the just created jenkins storage.
```
kubectl create -f jenkins-master-pvc.yaml
```

6.0. Deploye jenkins master instace and it service using the storage created in previous step.
```
kubectl create -f jenkins-master-deployment.yaml

7.0. Find the IP of Jenkins pod by running
```
kubectl get pods -n jenkins
``

7.1. Start jenkins console, default id password is admin/deiamant

7.2. You will find aqua-cicd project already create in the consol. Click on run now to run the pipeline and see the result.

7.3. Kubernetes plugin in jenkins is already preconfigured, which you migh need to modify based on your cluster (../../images/jenkns-master/groovy/kubernetes.groovy). This will take care of setting up kubernetes so that jenkins automatically launches the jenkins slave containers for running the jobs and delete those slave cotnainers once its finished.


8.0. TODO and issues:
1) aqua-cli image need dockerhub secrete and so jenkins slave will need a service account with imagepullsecrete set to that dockerhub secrete . jenkins/kubernetes plugin not taking the image secretes and service accounts.For not have  bypoassed error by manually downloading the image for aqua-cli in all machines.
2) How do we make sure that slave created for one job is not used by other jobs?
3) Too many slaves being created for each jobs, how to keep them from false timeout which causing it to create new slaves? Its nto a big concern as ultimately they will be delteted.
4) Currenlty running docker-in-docker, is this best approach in given scenario?
