### Step1: Build the Dockerfile and tag the image:

#### sudo docker build -t htop .
----------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step2: Now, start an htop container. Using --pid=host grants htop access to the host's process space so that htop can monitor processes running on the host:

#### sudo docker run -it -rm --pid=host htop

##### Note: To exit htop container, use the q key.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step3: Create an Nginx Docker container to be used for Gremlin Attacks:

#### Nginx is a popular web server that we will use as the target of our chaos experiments

##### Note: First we have to create directory HTML page that we will serve using Nginx.
##### mkdir -p ~/docker-nginx/html
##### cd ~/docker-nginx/html

★ Now create index.html page here: vim index.html ( refer repo for code )

#### Now for creating nginx docker container run below command:

##### docker run -l service=nginx --name nginx-container -p 80:80 -d -v ~/docker-nginx/html:/usr/share/nginx/html nginx

★ here host port or base os port is 80 and container port is also 80 because nginx work on port no 80
★ we are mounting host dir ~/docker-nginx/html as volume with document root of nginx /usr/share/nginx/html 
★ to view container run "docker ps"
------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step4: Installing Gremlin in a Docker container

★ With Gremlin, you can run Chaos Engineering experiments to test your systems against common failures, like high CPU, host shutdown, and dropped network traffic.

##### Note: We required Gremlin TeamId and secret key, so for this just go to https://www.gremlin.com/ and sign up or create your account.
##### 1) Click on user icon.
##### 2) Click on team settings.
##### 3) Click on configuration tab and copy your TeamId and secret key, that we need afterwards.
##### 4) In your Bash Shell set: export GREMLIN_TEAM_ID=YOUR_TEAM_ID ; export GREMLIN_TEAM_SECRET=YOUR_SECRET_KEY

★ To tell Gremlin to launch sidecars with the host's user namespace, create the following environment variable: export GREMLIN_BYPASS_USERNS_REMAP=1 

## Next, run the Gremlin Docker container.

docker run -d --net=host \
    --cap-add=NET_ADMIN --cap-add=SYS_BOOT --cap-add=SYS_TIME \
    --cap-add=KILL \
    --pid=host \
    -v $PWD/var/lib/gremlin:/var/lib/gremlin \
    -v $PWD/var/log/gremlin:/var/log/gremlin \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e GREMLIN_TEAM_ID="$GREMLIN_TEAM_ID" \
    -e GREMLIN_TEAM_SECRET="$GREMLIN_TEAM_SECRET" \
    -e GREMLIN_BYPASS_USERNS_REMAP="$GREMLIN_BYPASS_USERNS_REMAP" \
    --name gremlin-container \
    gremlin/gremlin daemon
    
★ for going inside the gremlin container run: docker exec -it gremlin-container /bin/sh

$ gremlin help attack-container: run this command to check available attack in gremlin. (show attacks like blackhole, cpu, disk, dns) 
$ exit
------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step 5 - How to create a CPU Attack from a Gremlin Container against the host using the Gremlin CLI

##### We will use the Gremlin CLI attack command to create a CPU attack. This attack will consume CPU using the default settings of 1 core for 60 seconds

docker run -d \
    --net=host \
    --pid=host \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_BOOT \
    --cap-add=SYS_TIME \
    --cap-add=KILL \
    -e GREMLIN_TEAM_ID="${GREMLIN_TEAM_ID}" \
    -e GREMLIN_TEAM_SECRET="${GREMLIN_TEAM_SECRET}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/log/gremlin:/var/log/gremlin \
    -v /var/lib/gremlin:/var/lib/gremlin \
    --name gremlin-cpu-attack \
    gremlin/gremlin attack cpu
    
 note: run your htop container to view attack on host. ( docker run -it --rm --pid=host htop )
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step 6 - How to create a CPU Attack from a Gremlin Container against the nginx container using the Gremlin CLI

##### We will use the Gremlin CLI attack-container command to create a CPU attack on nginx container. This attack will consume CPU using the default settings of 1 core for 60 seconds

docker run -d -it \
    --cap-add=NET_ADMIN \
    -e GREMLIN_TEAM_ID="${GREMLIN_TEAM_ID}" \
    -e GREMLIN_TEAM_SECRET="${GREMLIN_TEAM_SECRET}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gremlin/gremlin attack-container [nginx container id] cpu
 
 note: run your htop container to view attack on container. ( docker run -it --rm --pid=container:container_id htop )
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step 7 - How to create a Black Hole Attack from a Gremlin Container against the nginx container using the Gremlin CLI, which help us to crash the site or drop all ingress or egress for 60 seconds.

docker run -it \
    --cap-add=NET_ADMIN \
    -e GREMLIN_TEAM_ID="${GREMLIN_TEAM_ID}" \
    -e GREMLIN_TEAM_SECRET="${GREMLIN_TEAM_SECRET}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gremlin/gremlin attack-container [nginx container id] blackhole --ingress_port 80
 
note: run your htop container to view attack on container. ( docker run -it --rm --pid=container:container_id htop )
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Conclusion:

You've installed Gremlin in a Docker container and validated that Gremlin works by running the "Hello, World!" of Chaos Engineering experiments: the CPU resource attack. You have run a CPU resource attack from the Gremlin Docker container against the host. You have also run a CPU resource attack and blackhole attack from the Gremlin Docker container against an Nginx Docker container. You now possess tools that make it possible for you to explore additional Gremlin Attacks including attacks that impact State and Network.
