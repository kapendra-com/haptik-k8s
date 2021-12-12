1. Setup Kubernetes &amp; Deploy a simple Tomcat Application via Nginx Ingress controller.
Have at least 2 application pods running. Please have readiness and liveliness probes.
(Kubernetes can be minikube for now on a Linux machine, K8s files can be shared with
us. It can also be done on a cloud VM and details can be shared)

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

# Machine Details

```
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-1020-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Dec 11 15:58:47 UTC 2021

  System load:  0.27               Processes:                136
  Usage of /:   11.4% of 29.02GB   Users logged in:          0
  Memory usage: 21%                IPv4 address for docker0: 172.17.0.1
  Swap usage:   0%                 IPv4 address for ens5:    172.31.81.155


42 updates can be applied immediately.
26 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sat Dec 11 15:48:00 2021 from 122.161.67.25
```

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


