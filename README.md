# bank_transfer
a simple golang application using golang, postgresql, docker, kubernetes

# install kubectrl :https://kubernetes.io/vi/docs/tasks/tools/install-kubectl/ . for windows : scoop install kubectl
# https://repost.aws/knowledge-center/amazon-eks-cluster-access
# kubectl cluster-info
# aws eks update-kubeconfig --name transfer-bank --region ap-southeast-1 //video 31 guide

# kubectl config use-context arn:aws:eks:ap-southeast-1:502320843173:cluster/transfer-bank
# aws sts get-caller-identity

# go security credential in avatar section , then create accesskey
# kubectl get pods
# kubectl apply -f aws-auth.yaml
# kubectl get service
# install k9s https://k9scli.io/

# cd eks > kubectl apply -f deployment.yaml
# cd eks > kubectl apply -f service.yaml
# nslookup [ip]
# pwddb wFnvZVrFcpzGO0B5fuwo

# docker pull [image] 