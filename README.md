### Step1: Build the Dockerfile and tag the image:

#### sudo docker build -t htop .
----------------------------------------------------------------------------------------------------------------------------------------------------------------
### Step2: Now, start an htop container. Using --pid=host grants htop access to the host's process space so that htop can monitor processes running on the host:

#### sudo docker run -it -rm --pid=host htop

##### Note: To exit htop container, use the q key.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
