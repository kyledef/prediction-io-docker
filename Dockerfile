
FROM ubuntu
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y install curl gzip tar unzip zip libgomp1 wget software-properties-common python-software-properties

#CHANGE THESE!!!
ENV MONGO_IP 107.170.170.116
ENV MONGO_PORT 27017

#Install Oracle Java 7
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer

RUN wget http://download.prediction.io/PredictionIO-0.7.1.zip
RUN unzip PredictionIO-0.7.1.zip
WORKDIR PredictionIO-0.7.1

RUN sed -i -r -e"s/^(.*?db.type\s*=)\s*(.*)/\1mongodb/" ./conf/predictionio.conf
RUN sed -i -r -e"s/^(.*?db.host\s*=)\s*(.*)/\1\"$MONGO_IP\"/" ./conf/predictionio.conf
RUN sed -i -r -e"s/^(.*?db.port\s*=)\s*(.*)/\1$MONGO_PORT/" ./conf/predictionio.conf

RUN ./bin/setup.sh

#expose docker port
EXPOSE 9000


ADD waiter.sh /waiter.sh

WORKDIR /
RUN chmod +x ./waiter.sh
