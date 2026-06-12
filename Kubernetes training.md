**Kubernetes training**  
\-- objectives, duration, audience, prerequisites and topics overview \--

**Training description**

The course provides essential knowledge and hands-on experience with containerization and container orchestration using Kubernetes. Participants start from the virtualization fundamentals (virtual machines and containers), learn to orchestrate and scale a containerized application with Kubernetes, and progress to the advanced topics of creating and managing Kubernetes clusters. Each topic combines a theoretical overview with practical, hands-on work on a real cluster.

**Training objectives**

The main training objectives are:

* Understand the virtualization concepts and the differences between virtual machines and containers  
* Learn to use Kubernetes to orchestrate, configure and scale a containerized application  
* Learn the advanced topics of creating, securing and administering Kubernetes clusters  
* Gain hands-on experience by applying each concept on a running cluster  
* Build the foundation to confidently deploy and operate applications on Kubernetes

## ---

**Training duration, days and sessions scheduling**

The **Core Curriculum** provides the essential Kubernetes skills through a **3-day format (6-7 hours daily)**, combining a theoretical part with a practical (hands-on) part for each topic. In the first two days we cover the introductory and medium topics; the third day covers the advanced topics.

The complementary **Advanced Modules** (an optional 4th day) extend the Core Curriculum with production-oriented topics - advanced deployment strategies, the Gateway API, TLS termination, cluster monitoring, API access control and Kubernetes extensibility.

**Note**: the specified duration is our *minimum* recommended duration, which allows us to work on a few examples together with the participants. For more thorough practice, greater hands-on experience and added use-case analyses, we recommend allocating at least 25-30% more time for the training.

Sessions scheduling:

* Each training day is composed of 6-7 hours; we will have a break at each \~50 minutes  
* Each session consists of a theoretical and a practical (hands-on) part  
* Progressive complexity, designed for maximum knowledge retention  
* Some sessions may take more or less than 50 minutes, depending on their complexity and on the questions and discussions

**Disclaimer**: if the discussions and the hands-on sessions prolong more than anticipated, some sessions will be postponed to the following day. Our intent is to cover the sessions *thoroughly*, not in a rushed mode.

---

	**Targeted audience**

* Software developers building or deploying containerized applications  
* DevOps, platform and SRE engineers operating application infrastructure  
* Technical leads and architects designing or running services on Kubernetes  
* Anyone deploying to, or responsible for maintaining, a Kubernetes cluster

---

	**Prerequisites**

The following is a list of the minimal prerequisites required to attend the course:

* Basic command-line comfort, on any operating system  
* Basic container fundamentals (images and containers, ideally with Docker)  
* Basic programming skills, in any programming language  
* Development environment:  
  * [Git](https://git-scm.com/) installed  
  * A local Kubernetes cluster - one of [kind](https://kind.sigs.k8s.io/), [minikube](https://minikube.sigs.k8s.io/) or [Docker Desktop](https://www.docker.com/products/docker-desktop/)  
  * The [`kubectl`](https://kubernetes.io/docs/tasks/tools/) command-line tool  
    * We can help set this up during the course, if needed

---

**Presented topics**

### **Day 1: Edge concepts and Kubernetes objects**

* [Training overview](https://docs.google.com/presentation/d/1a3h4ZShVqAQ1LF1mHHoW0PgRFAV_2yKkF-1jJyNJ-jY/edit#slide=id.p)  
* [Software deployments, cloud computing & containerization overview](https://docs.google.com/presentation/d/1pLTTsxrxXtD8vWZSOEWPZ90XM9WuKi6EKNoVReDZePo/edit#slide=id.p)  
* [**S01**](https://docs.google.com/presentation/d/1TAzn2UaS_Okx91lEV4wbIWi9cJu1nWQiR9dJr5wvdl4/edit#slide=id.p) \- Containers orchestration overview \- Docker Swarm & Kubernetes  
* [**S02**](https://docs.google.com/presentation/d/1ElQel3R4eBmUxbCuh8KeWXlCti2CQWft7DnyrJ-oadc/edit#slide=id.p) \- Kubernetes introduction and overview  
  * Kubernetes architecture  
  * Installing Kubernetes on Linux, Windows and MacOS  
* **S03** \- Kubernetes objects  
  * [**3.1**](https://docs.google.com/presentation/d/1PT2AtgFjhNMuoy9T6PUbG7_07qI9lK14E96vVWKMQMM/edit#slide=id.g7226ee39a5_0_126) Cluster, Nodes and the Control Plane  
  * [**3.2**](https://docs.google.com/presentation/d/1yWlF9xClhPMWsrG5WvOkRB0De1Fsl2ybWB88n9Zfx0s/edit#slide=id.g7226ee39a5_0_126) Objects, API and Namespaces  
  * [**3.3**](https://docs.google.com/presentation/d/1FItjIdRtVvczsgn00TAahBltUT_DoouctZFmSt8Q1nw/edit#slide=id.g2d29b452eac_0_0) Pods, [**3.3.1**](https://docs.google.com/presentation/d/1k_wu0vjlMiuNfb38tlQ02MNibhoHr-Z-3lT24nGtGAk/edit#slide=id.g7226ee39a5_0_126) Pods scheduling  
  * [**3.4**](https://docs.google.com/presentation/d/1zm0VVSwk7z7qrd3dYSgVUu7hdlWhfJIrh_pipnrwnsQ/edit#slide=id.g7226ee39a5_0_126) Deployments  
  * [**3.5**](https://docs.google.com/presentation/d/1QB0F-qjYyW85c1_wqkQdiJwLbipvdcoMQAK4fYpAjzE/edit#slide=id.p) Services and Labels  
  * [**3.6**](https://docs.google.com/presentation/d/1jFRS9Wu8rEai0PQLjz-uJCn5j1JWcj8EHd5bftOiKUA/edit#slide=id.p) Ingress and NetworkPolicy  
* [**S04**](https://docs.google.com/presentation/d/1s7UfSNYdYqcFm3NVrBjXQcNr_sTcJdTQOv65XPPKRb4/edit#slide=id.p) \- Imperative and declarative objects management  
  * [**4.1**](https://docs.google.com/presentation/d/1m_TmhUflTWWAXvxAQDX16Q98CvejYpRYltIO_MTPafA/edit#slide=id.p) Imperative  
  * [**4.2**](https://docs.google.com/presentation/d/122_GJHRSVQp5SYCRM7UaBxitVBIltTCxQvHDyTWzhLw/edit#slide=id.p) Declarative

### **Day 2: State, configuration, jobs and networking**

* **S05** \- Special type applications  
  * [**5.1**](https://docs.google.com/presentation/d/1wd22Kwl4hyb3P8ErfcdoE85jkQ_rwJKqrldSwBP9-NY/edit#slide=id.p) Stateful applications  
  * [**5.2**](https://docs.google.com/presentation/d/16MJ0V58CHZDWwLAkTox9ywYd6aVvuUbrEnXqGyX22zU/edit#slide=id.p) The DaemonSet resource  
* [**S06**](https://docs.google.com/presentation/d/1b4MXyHdjD621c1YzglO_FBpoZb471BCJLEu5XPexc5Y/edit#slide=id.p) \- Persistence in Kubernetes  
  * `PersistentVolume`  
  * `PersistentVolumeClaim`  
  * `StorageClass`  
* **S07** \- Configuration resources:  
  * [**7.1**](https://docs.google.com/presentation/d/1nxx29KyMBVRrPX60mEAohdsWPSKRE0W2IZLKbm84qRE/edit#slide=id.p) \- ConfigMaps & the Downward API  
  * [**7.2**](https://docs.google.com/presentation/d/1miF7gdVMjvIGiq10WwjdM1SXCcv-U3nrnU09TgH4eR8/edit#slide=id.p) \- Secrets  
* **S08** \- Job scheduling objects:  
  * [**8.1**](https://docs.google.com/presentation/d/1MXJmsnT6NuMiFOjh7qa-_ogX7KFnUlhXhU7CukclyIM/edit#slide=id.p) \- The Job object  
  * [**8.2**](https://docs.google.com/presentation/d/1r2ByyhGBrK68pr7rMldktuRYLtlMCWd28FCoaRgP43o/edit#slide=id.p) \- The CronJob object  
* [**S09**](https://docs.google.com/presentation/d/1ZjWBfpSw1CTntv7DFz83WRmvG7qLGaTvJD61ydud6g8/edit#slide=id.p) \- Networking overview

### **Day 3: Scaling, administration and packaging**

* [**S10**](https://docs.google.com/presentation/d/1iFs8ZgbZbCDCer8wFjcfdPF8A8SdwneeKSAj-uZIkH0/edit#slide=id.p) \- Autoscaling applications, using the Horizontal and VerticalPodAutoscaler  
* **S11** \- Kubernetes administration  
  * [**11.1**](https://docs.google.com/presentation/d/15Atue-javrMhyBr5UTKbhaGMbSZKshWYs5IXGyMdnIE/edit#slide=id.p) Resource and namespace quotas  
  * [**11.2**](https://docs.google.com/presentation/d/12ts5a28OT_T_cFzAHniBeHMEXZmbH3ejxWvnb0oEUY4/edit#slide=id.p) User management  
  * [**11.3**](https://docs.google.com/presentation/d/1p9O9nir6ZLXtltd5Hr3TJuTIgS_GKRude5d1wvIjMqI/edit#slide=id.p) Node maintenance  
  * [**11.4**](https://docs.google.com/presentation/d/1Fhgq069Ln-VgB6I1RmOCcKI7HPv2-BhghE_UqtZCRbI/edit#slide=id.p) High availability  
* [**S12**](https://docs.google.com/presentation/d/1jzsE1blfZh0shBpgwIXpF4HgTzi-PczSgd9kUNZ6fGQ/edit#slide=id.p) \- Packaging and deploying applications using Helm  
* Training wrap-up & retrospective

### **Advanced Modules (optional 4th day)**

The Advanced Modules extend the Core Curriculum with production-oriented topics. They can be delivered as a fourth day or as a separate, follow-up session.

* **Deployment strategies** *(deck in progress)* \- rolling, recreate, blue/green, canary, A/B and shadow; which are native vs. require a controller or a service mesh  
* **Gateway API** *(deck in progress)* \- the role-oriented successor to Ingress (GatewayClass / Gateway / HTTPRoute)  
* **TLS termination** *(deck in progress)* \- where TLS terminates at the edge; Ingress `spec.tls` and the Gateway HTTPS listener  
* **Cluster monitoring** *(deck in progress)* \- Prometheus, Grafana and kube-state-metrics  
* **Kubernetes API access control**  
  * Authentication and authorization  
    * RBAC  
* **Extending Kubernetes**  
  * Custom Resource Definitions (CRDs)  
  * Operators  
* **Kubernetes distributions overview**

---

	**Additional notes**

**Course resources & hands-on support**

* Every topic is taught as a theoretical overview followed by hands-on practice on a real cluster  
* Reference manifests and per-topic hands-on labs, kept in sync with the presented content  
* Progressive hands-on work, building toward a complete, deployable application  
* Up-to-date Kubernetes APIs and versions throughout the materials

**Extended value & post-training support**

* Implementation roadmap tailored to the organization's specific deployment and operations needs  
* Reference manifests and lab material to continue practicing after the course  
* The Advanced Modules are designed for a seamless continuation of the Core Curriculum  
* Post-training technical consultation and/or implementation guidance, as needed
