docker build -t tomcat-app  .
docker tag tomcat-app kapendralive/tomcat-app:latest
docker push kapendralive/tomcat-app:latest
kubectl delete deploy tomcat-app
kubectl apply -f assessment.yaml 

