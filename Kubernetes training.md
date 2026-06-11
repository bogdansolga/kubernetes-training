  
**Kubernetes training**  
\-- overview and sessions details \--

**Training objectives:**

- Learn an overview of the virtualization concepts (virtual machines and containers)  
- Learn the usage of Kubernetes to orchestrate and scale a containerized application  
- Learn the advanced topics of creating and managing Kubernetes clusters

---

**Running example — SkyHop**

The hands-on parts are built around **one cohesive app, SkyHop** (a Next.js frontend, a Spring Boot backend, and a Postgres database). Each topic builds one piece of it, so by the final day the cluster runs the app you then assemble — as teams — in the **capstone**. See `timeline.html` for the lab map across the days.

---

**Structure and presentations**

The training length is 3 days, 6-7 hours / day. In the first two days we learn the introductory and medium topics, in the 3rd and 4th day we will learn a few more advanced topics.

**Note**: the specified duration is our *minimum* recommended duration, which allows us to work on a few examples together with the participants. For more thorough practice, greater hands-on experience and added use-case analyses, we recommend to allocate at least 25-30% more time for the training.

	Each session will consist in a theoretical and practical (hands-on) part. We will have a break at each \~50 minutes. Depending on their complexity and on the questions and discussions, some sessions may take more or less than 50 minutes.

**Disclaimer**: if the discussions and the hands-on sessions will prolong more than anticipated, some sessions will be postponed on the following day. Our intent is to cover the sessions *thoroughly*, not in a rushed mode.

	The presented topics on each day are:

**Intro and medium**

* **Day 1**  
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

* **Day 2**  
  * **S05** \- Special type applications  
    * [**5.1**](https://docs.google.com/presentation/d/1wd22Kwl4hyb3P8ErfcdoE85jkQ_rwJKqrldSwBP9-NY/edit#slide=id.p) Statefull applications  
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
  * [**S09**](%20%20https://docs.google.com/presentation/d/1ZjWBfpSw1CTntv7DFz83WRmvG7qLGaTvJD61ydud6g8/edit#slide=id.p) \- Networking overview

**Advanced**

* **Day 3:**  
  * [**S10**](https://docs.google.com/presentation/d/1iFs8ZgbZbCDCer8wFjcfdPF8A8SdwneeKSAj-uZIkH0/edit#slide=id.p) \- Autoscaling applications, using the Horizontal and VerticalPodAutoscaler  
  * **S11** \- Kubernetes administration  
    * [**11.1**](https://docs.google.com/presentation/d/15Atue-javrMhyBr5UTKbhaGMbSZKshWYs5IXGyMdnIE/edit#slide=id.p) Resource and namespace quotas  
    * [**11.2**](https://docs.google.com/presentation/d/12ts5a28OT_T_cFzAHniBeHMEXZmbH3ejxWvnb0oEUY4/edit#slide=id.p) User management  
    * [**11.3**](https://docs.google.com/presentation/d/1p9O9nir6ZLXtltd5Hr3TJuTIgS_GKRude5d1wvIjMqI/edit#slide=id.p) Node maintenance  
    * [**11.4**](https://docs.google.com/presentation/d/1Fhgq069Ln-VgB6I1RmOCcKI7HPv2-BhghE_UqtZCRbI/edit#slide=id.p) High availability  
  * [**S12**](https://docs.google.com/presentation/d/1jzsE1blfZh0shBpgwIXpF4HgTzi-PczSgd9kUNZ6fGQ/edit#slide=id.p) \- Packaging and deploying applications using Helm  
  * Training wrap-up & retrospective  
    

**Extension topics:**

* Kubernetes API access control  
  * Authentication and authorization  
    * RBAC

  * Extending Kubernetes:  
    * Custom Resource Definitions (CRDs)  
    * Operators

  * Kubernetes distributions overview

