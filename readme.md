Sonerqube for m1 silicon:

docker pull mwizner/sonarqube:8.9.5-community

docker images
REPOSITORY           TAG               IMAGE ID       
mwizner/sonarqube    8.9.5-community   f5e2e7d2d122 

docker create --name sonarqubeapp -p 9000:9000 f5e2e7d2d122
docker start sonarqubeapp
http://localhost:9000



Kubernetes:

kubectl apply -f filename.yml
kubectl get nodes

kubectl get deployments -n phonebook
kubectl  describe deployments --namespace=phonebook
http://<node-ip>:8080

minikube tunnel      -> start tunnel frontend service
minikube service <servicename>

kubectl get pods --namespace=phonebook

--delete -- kubectl delete namespace phonebook
