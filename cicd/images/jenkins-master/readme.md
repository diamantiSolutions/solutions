
1.0. How to have a plugin autoinstalled 
    - add plugin name to plugins.txt

2.0. How to add cusomize pipeline.
     - example groovy scripts are at groovy/ folder. Kubernetes.grooy takes care of setting up kuberentes plugin. aqua-cicd.froovy is an example of using the kubernetes in pieline.
     - add neww groovy pieline as needed.

3.0 How to build docker iamge
    - docker build -t <your registre>/jenkins-master:<your-tag> . 

