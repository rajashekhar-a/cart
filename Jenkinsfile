// @Library('roboshop') _
//
// nodejs(
//     COMPONENT                 : 'cart',
//     LABEL                     : 'WORKSTATION'
// )

// docker(
//     COMPONENT                 : 'cart',
//     LABEL                     : 'WORKSTATION'
// )

pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    CLUSTER_NAME = 'my-cluster'
    ECR_REPO = '863518461004.dkr.ecr.us-east-1.amazonaws.com/cart'
    IMAGE_TAG = "latest"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git branch: 'main',  credentialsId: 'github-token',  url: 'https://github.com/rajashekhar-a/cart.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh"docker build -t cart:${IMAGE_TAG} ."
          sh"docker tag cart:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}"
        }
      }
    }

    stage('Login to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds-id']]) {
          sh '''
            aws ecr get-login-password --region $AWS_REGION \
              | docker login --username AWS --password-stdin $ECR_REPO
          '''
        }
      }
    }

    stage('Push to ECR') {
      steps {
        script {
          sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
        }
      }
    }

    stage('Update Kubeconfig') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds-id']]) {
          sh '''
            aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
          ##sed -i "s|<IMAGE>|$ECR_REPO:$IMAGE_TAG|g" kubernetes/deployment.yaml
          kubectl apply -f kubernetes/
        '''
      }
    }
  }

  post {
    success {
      echo "Deployed successfully to EKS!"
    }
    failure {
      echo "Pipeline failed. Check logs!"
    }
  }
}

