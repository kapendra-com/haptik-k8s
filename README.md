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

root@Opstree-Kapendra:/home/kapendra/haptikGIT/haptik-k8s# minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

```
1.3 Deploy a simple Tomcat Application 
1.4 Expose via Nginx Ingress controller.
1.5 Have at least 2 application pods running. 
1.6 Please have readiness and liveliness probes.
1.7 K8s files can be shared with

2. Put monitoring for the above setup on 3 important data points you think are relevant for
the above application on Kubernetes. (Choose any tool, eg. Prometheus)

3. Add filebeat daemon set to the current setup so that it can read application logs from the
pod.
Bonus
Once you have the Filebeat daemon running, push the application logs please also push
the logs to an ELK 7.x stack deployed on the same VM.

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)


# haptik-k8s
interview Assignment

#

# Setup Base


 # Setup Kubectl
```
sudo su -
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl
```

# Setup Docker

```
apt-get update && sudo apt-get install docker.io -y 
systemctl start docker 
systemctl status docker
apt install conntrack
```

# Start Minikube

```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
minikube start --vm-driver=none
```

```
minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

```


# setup Ingress
```
minikube addons enable ingress
```


# Setup application 


