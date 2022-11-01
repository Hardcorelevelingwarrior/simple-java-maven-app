podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: maven
        image: maven:3.8.1-jdk-8
        command:
        - sleep
        args:
        - 99d
      - name: kaniko
        image: gcr.io/kaniko-project/executor:debug
        command:
        - sleep
        args:
        - 9999999
        volumeMounts:
        - name: kaniko-secret
          mountPath: /kaniko/.docker
      restartPolicy: Never
      volumes:
      - name: kaniko-secret
        secret:
            secretName: dockercred
            items:
            - key: .dockerconfigjson
              path: config.json
''') {
  node(POD_LABEL) {
    stage('Get the project') {
      git url: 'https://github.com/Hardcorelevelingwarrior/simple-java-maven-app.git', branch: 'master'
      container('maven') {
        stage('Build and test the project') {
          sh '''
          mvn -B -DskipTests clean package
          mvn test
          ''' }
        stage('Publish test result'){
          junit 'target/surefire-reports/*.xml'}
            stage('Dependency check and publish result'){
            sh 'mvn dependency-check:check'
            dependencyCheckPublisher pattern: ''}
        stage('SAST test and publish result'){
            sh 'mvn pmd:pmd pmd:cpd spotbugs:spotbugs'
            recordIssues enabledForFailure: true, tool: spotBugs()
            recordIssues enabledForFailure: true, tool: cpd(pattern: '**/target/cpd.xml')
            recordIssues enabledForFailure: true, tool: pmdParser(pattern: '**/target/pmd.xml')
          }

        }  
        
        }
      
     

    stage('Build & Test the Docker Image') {
      container('kaniko') {
        stage('Deploy to DockerHub') {
          sh '''
            /kaniko/executor --context `pwd` --destination conmeobeou1253/mavendemo:latest
          '''
        }
             stage('Anchore analyse') {  
    steps {  
     writeFile file: 'anchore_images', text: 'https://hub.docker.com/repository/docker/conmeobeou1253/mavendemo'  
     anchore name: 'anchore_images'  
    }  
   }  

      }
    }

  }
}
