# Task 1 
- 1.1 Share machine details 
```
kapendra@Opstree-Kapendra:~/haptik$ cat /proc/meminfo
MemTotal:       12156388 kB

kapendra@Opstree-Kapendra:~/haptik$ lscpu
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   39 bits physical, 48 bits virtual
CPU(s):                          4
```

- 1.2 Setup Kubernetes (minikube)
```
# Setup Kubectl

sudo su -
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl


# Setup Docker

apt-get update && sudo apt-get install docker.io -y 
systemctl start docker 
systemctl status docker
apt install conntrack

# Start Minikube

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
minikube start --vm-driver=none

kapendra@Opstree-Kapendra:~/haptik$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

```

- 1.3 Deploy a simple Tomcat Application 
```
# make host entry

kapendra@Opstree-Kapendra:~/haptik$ cat /etc/hosts
127.0.0.1	localhost haptik-test.com haptik-kibana.com

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
127.0.0.1	host.minikube.internal
192.168.1.8	control-plane.minikube.internal

# Run build script
./build.sh
```

- 1.4 Expose via Nginx Ingress controller.
```
#Enable ingress addon on minikube

minikube addons enable ingress

# used below manifest for ingress object (part of assessment file)
---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tomcat-app
  labels:
    app: tomcat-app
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: haptik-test.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: tomcat-app
                port:
                  number: 8080
```

- 1.5 Have at least 2 application pods running. 
```
# created deploymnet object (part of assessment file)

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: tomcat-app
  name: tomcat-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tomcat-app
  template:
    metadata:
      labels:
        app: tomcat-app
    spec:
      containers:
      - image: kapendralive/tomcat-app:latest
        name: tomcat-app
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 2
          failureThreshold: 1
          successThreshold: 1
        livenessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 20
          timeoutSeconds: 2
          failureThreshold: 1
          successThreshold: 1
        volumeMounts:
        - name: logs
          mountPath: /opt/tomcat/logs/
      volumes:
        - name: logs      
          hostPath:
            path: /var/log/tomcat-app
            type: ""

```

- 1.6 Please have readiness and liveliness probes.

```
# Added as port check 
...
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 2
          failureThreshold: 1
          successThreshold: 1
        livenessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 20
          timeoutSeconds: 2
          failureThreshold: 1
          successThreshold: 1
...
```

- 1.7 K8s files can be shared with

```
https://github.com/kapendra-com/haptik-k8s/blob/dev/assessment.yaml
```

# Task 2
- 2.1 monitoring for the above setup

``` 
# EFK stack

kubectl apply -f efk/

namespace/kube-logging created
statefulset.apps/es-cluster created
persistentvolume/es-pv-01 created
persistentvolume/es-pv-02 created
persistentvolume/es-pv-03 created
service/elasticsearch created
serviceaccount/fluentd created
clusterrole.rbac.authorization.k8s.io/fluentd created
clusterrolebinding.rbac.authorization.k8s.io/fluentd created
configmap/fluentdconf created
daemonset.apps/fluentd created
deployment.apps/kibana created
service/kibana created
ingress.networking.k8s.io/kibana created

```    

- 2.2 Put logging at important data points

```
...
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
      - name: fluentconfig
        configMap:
          name: fluentdconf
...
```

# Task 3

- 3.1 Add filebeat daemon
```
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-logging
  labels:
    app: fluentd
    kubernetes.io/cluster-service: "true"
spec:
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      app: fluentd
      kubernetes.io/cluster-service: "true"
  template:
    metadata:
      labels:
        app: fluentd
        kubernetes.io/cluster-service: "true"
    spec:
      serviceAccount: fluentd
      containers:
      - name: fluentd
        image: fluent/fluentd-kubernetes-daemonset:v1.10.4-debian-elasticsearch7-1.0
        env:
          - name:  FLUENT_ELASTICSEARCH_HOST
            value: "elasticsearch.kube-logging.svc.cluster.local"
          - name:  FLUENT_ELASTICSEARCH_PORT
            value: "9200"
          - name: FLUENT_ELASTICSEARCH_SCHEME
            value: "http"
        resources:
          limits:
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
        - name: fluentconfig
          mountPath: /fluentd/etc/fluent.conf
          subPath: fluent.conf
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
      - name: fluentconfig
        configMap:
          name: fluentdconf
```

- 3.2 set to the current setup so that it can read application logs from the pod.

```
        volumeMounts:
        - name: logs
          mountPath: /opt/tomcat/logs/
      volumes:
        - name: logs      
          hostPath:
            path: /var/log/tomcat-app
            type: ""
```


# Bonus
Once you have the Filebeat daemon running, push the application logs please also push
the logs to an ELK 7.x stack deployed on the same VM.


![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)



```




