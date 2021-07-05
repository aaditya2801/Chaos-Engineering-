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




