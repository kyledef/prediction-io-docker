
FROM ubuntu
RUN apt-get update

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install curl gzip tar unzip zip libgomp1 wget software-properties-common python-software-properties

#CHANGE THESE!!!
ENV MONGO_IP 127.0.0.1
ENV MONGO_PORT 27017


#WORKDIR ~/

RUN wget http://download.prediction.io/PredictionIO-0.7.3.zip
RUN wget http://archive.apache.org/dist/hadoop/common/hadoop-1.2.1/hadoop-1.2.1-bin.tar.gz
RUN apt-get install -y mongodb-clients

#Install Oracle Java 7
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer



RUN unzip PredictionIO-0.7.3.zip
RUN mv PredictionIO-0.7.3 PredictionIO

#WORKDIR PredictionIO

RUN sed -i -r -e"s/^(.*?db.type\s*=)\s*(.*)/\1mongodb/" PredictionIO/conf/predictionio.conf
RUN sed -i -r -e"s/^(.*?db.host\s*=)\s*(.*)/\1\"$MONGO_IP\"/" PredictionIO/conf/predictionio.conf
RUN sed -i -r -e"s/^(.*?db.port\s*=)\s*(.*)/\1$MONGO_PORT/" PredictionIO/conf/predictionio.conf


#WORKDIR /

#install hadoop
RUN tar -xzf hadoop-1.2.1-bin.tar.gz
RUN mv hadoop-1.2.1 hadoop
RUN cp /PredictionIO/conf/hadoop/* /hadoop/conf/
RUN echo "io.prediction.commons.settings.hadoop.home=/hadoop" >> /PredictionIO/conf/predictionio.conf
#RUN /hadoop/bin/hadoop namenode -format


#WORKDIR PredictionIO

RUN PredictionIO/bin/setup.sh

#expose web and api endpoints
EXPOSE 9000 8000


#WORKDIR /

#brute hack to inject credentials to server
ADD create_user.sh ./create_user.sh
RUN chmod +x create_user.sh
RUN ./create_user.sh
RUN apt-get remove -y mongodb-clients


ADD waiter.sh /waiter.sh
RUN chmod +x ./waiter.sh
