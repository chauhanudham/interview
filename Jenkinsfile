node{
    stage('Scm Checkout'){
        git 'https://github.com/chauhanudham/interview.git'
    }
    stage('Build Docker Image'){
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
        sh "sudo docker build -t udham/website:${commit_id}_${BUILD_NUMBER} ."
    }
    stage('Tag Docker Image'){
      sh "git rev-parse HEAD > .git/commit-id"
      def commit_id = readFile('.git/commit-id').trim()
      println commit_id
      sh "sudo docker tag udham/website:${commit_id}_${BUILD_NUMBER}   udham/website:latest_${BUILD_NUMBER}"
    }
    stage('Login Docker Hub'){
      sh "sudo docker login -u udham -p XXXX"
    }
    stage('Push Docker Image'){
      sh "git rev-parse HEAD > .git/commit-id"
      def commit_id = readFile('.git/commit-id').trim()
      println commit_id
      sh "sudo docker push udham/website:latest_${BUILD_NUMBER}"
    }    
    stage('kubectl get nodes '){

      sh "export KUBECONFIG=/var/lib/jenkins/.kube/config ; kubectl get nodes"
    }    
    stage('kube deployment yaml images change '){

      sh 'sed -i -e "s#<image_name>#udham/website:latest_$BUILD_NUMBER#g" deployment-website.yaml'
    }    
		
    stage('kubectl delete and create deployment  with service ip'){

      try { 
            sh "kubectl  delete deployment website-v1-deployment" 
             } 
        catch (ex) 
            { 
            echo 'No Deployment found' 
            } 
      sh "kubectl create -f deployment-website.yaml"
	  sh "kubectl apply -f service-website.yaml"
    }  		
	
    stage('Delete s Docker Image on local'){
      sh "git rev-parse HEAD > .git/commit-id"
      def commit_id = readFile('.git/commit-id').trim()
      println commit_id
      sh "sudo docker rmi -f udham/website:latest_${BUILD_NUMBER}"
	  sh "sudo docker rmi -f udham/website:${commit_id}_${BUILD_NUMBER}"
    }   
}
