prediction-io-docker
====================

##Decription
The prediction-io-docker is a [Docker](http://www.docker.io) image that is configured to run the [Prediction.io](http://prediction.io/) software for machine learning analysis of data.

##Installation
###Step 1 Install the latest version of docker from website:
```ShellSession
# Change user to root
sudo -s
# Add Docker to Apt Sources
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

#Update and install docker
apt-get update && apt-get install lxc-docker
```

###Step 2 Download or Clone the prediction-io.docker repository in server
```ShellSession
git clone https://github.com/kyledef/prediction-io-docker.git
```

###Step 3 Install and Run Mongodb
```ShellSession
git clone https://github.com/rikaardhosein/mongodb-docker.git
cd mongodb-docker
./build.sh
./run.sh
```
###Step 4 Change the Mongo IP Port

###Step 5 Build the docklet
```ShellSession
cd prediction-io.docker
./build.sh
```

###Step 6 Run the build
```ShellSession
./run.sh
```

##Troubleshooting
* Ensure you can connect to the Mongodb externally
* If running the docker fails, then you may need to increase the amount of RAM on the machine. Should be at least 2gb.

