import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

def jobName = "cicd"
project = Jenkins.instance.createProject(WorkflowJob, jobName)
def script = '''


/**
 * This pipeline will run a Docker image build
 */

podTemplate(cloud: 'kcloud', label: 'image-scan', name: 'jenkins-slave', slaveConnectTimeout: 180,
  containers: [
            containerTemplate(name: 'docker-dind', image: 'docker:stable-dind', ttyEnabled: true, privileged: true),
            containerTemplate(name: 'docker', image: 'docker:1.12.6', ttyEnabled: true, command: 'cat',
                envVars: [ containerEnvVar(key: 'DOCKER_HOST', value: 'tcp://localhost:2375') ]
            ),
            containerTemplate(name: 'aquasec', image: 'aquasec/scanner-cli:2.6', ttyEnabled: true,
          args: '--daemon --user api --password Diamanti1! --host http://aqua-web.aquasec.svc.solutions.eng.diamanti.com:8080'    ,
                envVars: [ containerEnvVar(key: 'DOCKER_HOST', value: 'tcp://localhost:2375') ]) 
          
          ],
  annotations: [podAnnotation(key: "diamanti.com/endpoint0", value: '{"network":"default","perfTier":"high"}' )],
  volumes: [emptyDirVolume(mountPath: "/var/lib/docker", memory: true),
            emptyDirVolume(mountPath: "/var/run", memory: true),
            hostPathVolume(hostPath: '/etc/docker/certs.d/', mountPath: '/etc/docker/certs.d/')]
  ) {
     node('image-scan') {
      stage('Build Docker image') {
        git 'https://github.com/diamantiSolutions/solutions.git'
        container('docker') {
          sh "docker build -t  myimage:latest ./microservice/images/cinemas-app/"
        }
      }
      stage('Scan Docker image'){
        container('docker') {
          def buildResult = 'success'
          echo 'Running Aqua Scan'
          try{
             sh 'docker login -u millesd -p Diamanti1!'
             sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v '+env.WORKSPACE+':/reports aquasec/scanner-cli:2.6 --local -image myimage:latest --host http://aqua-web.aquasec.svc.solutions.eng.diamanti.com:8080 --user api --password Diamanti1! --htmlfile /reports/aqua-scan.html'
          }catch(e){
             buildResult = 'failure'
             currentBuild.result = buildResult
             error("Build failed due to high vulnerability on image")
          } finally {
             publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: './', reportFiles: 'aqua-scan.html', reportName: 'Aqua Scan Results'])
          }
        }
      }
       stage('Push Docker image'){
            container('docker') {
	      #push to doecker registry
              sh "docker tag  myimage:latest registry.registry-docker.svc.solutions.eng.diamanti.com/myimage:latest"
              sh "docker push registry.registry-docker.svc.solutions.eng.diamanti.com/myimage:latest"

	      #push to artifactory
	      # docker login proxy.registry-artifactory.svc.solutions.eng.diamanti.com/docker
	      #docker push  proxy.registry-artifactory.svc.solutions.eng.diamanti.com/docker/busybox:latest
              #sh "sleep 200"
                 }
       }
     }
    }

'''
def definition = new CpsFlowDefinition(script,false)
project.definition = definition
project.save()