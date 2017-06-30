# **Cars**

## **Description**

The Cars application provides full control over any cars inventory.

## **Run Locally**

1. Open a terminal
```ssh
$ make dotnet-develop
```

2. Navigate to [http://127.0.0.1:8000](http://127.0.0.1:8000)

## **Run with Docker**

1. Open a terminal
```ssh
$ make docker-build tag=v1.0
$ make docker-run tag=v1.0
```

2. Navigate to [http://127.0.0.1:8000](http://127.0.0.1:8000)

## **Docker Orchestration**

Deploy a simple application to a single host. Then, configure Docker Swarm Mode, and deploy the same simple application across multiple hosts. Also, scale the application and move the workload across different hosts easily.

### Prerequisites

* Requires three Linux nodes with:
    * Docker 17.03 (or higher) installed
    * Connectivity throught `ssh`
    * [ASP.NET Core](https://www.microsoft.com/net/core#linuxubuntu)
    * Git command line tools
    * Makefile command line tools


### Prepare the Application to be Deployed

1. Login through `ssh` to the `nodea` that will be the manager node.
```ssh
$ ssh root@nodea
```

2. Download the repository into the home directory
```ssh
$ git clone https://github.com/jealvarez/cars-docker-swarm.git
```

3. Build docker images
```ssh
$ cd cars
$ make docker-build tag=v1.0
$ make docker-build tag=v1.1
```

4. Create a manager node
```ssh
$ docker swarm init
```

5. JoinwWorker nodes to the swarm manager
    * On swarm manager node
    ```ssh
    $ docker swarm join-token manager

    docker swarm join \
    --token SWMTKN-1-27jjs9jw3h1fyw8n660r2uji1rvpxl3xi9dblymjwghbxk8a80-2kekzkgzc618ifj9s0fx62pfj \
    172.16.30.185:2377
    ```

    * Copy the instruction displayed after have executed the command above on each node that you want to add.

    * Verify that nodes were added successfully
    ```ssh
    $ docker node ls
    ```

6. Deploy applications across multiple hosts
    * Deploy the application components as docker services
    ```ssh
    $ docker service create -p 8000:8000 --name cars cars:1.0
    ```

    * Verify that service was created sucessfully
    ```ssh
    $ docker service ls
    ```
7. Scale the application
    * Creating replicas 
    ```ssh
    $ docker service update --replicas 3 cars
    ```

    or

    ```ssh
    $ docker service scale cars=3
    ```

    * Verify that replicas was created sucessfully
    ```ssh
    $ docker service ps cars
    ```

    or

    ```ssh
    $ docker service ls
    ```

8. Applying updates
```ssh
$ docker service update --image cars:1.1 cars
```

9. Remove a service
```ssh
$ docker service rm cars
```

10. Leave node from swarm, the following command apply for both node manager and worker nodes.
    * Remove node
    ```ssh
    $ docker swarm leave -f
    ```

    * Verify that nodes were removed successfully on node manager
    ```ssh
    $ docker node ls
    ```