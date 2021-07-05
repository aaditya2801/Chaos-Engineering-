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

