
FROM ubuntu
RUN apt-get update

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install curl gzip tar unzip zip libgomp1 wget software-properties-common python-software-properties mongodb-clients

#Install Oracle Java 8
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer

# Download PredictionIO
RUN wget -O - https://d8k1yxp8elc6b.cloudfront.net/PredictionIO-0.9.2.tar.gz | tar zx
RUN mv PredictionIO* PredictionIO
ENV PIO_HOME /PredictionIO
ENV PATH $PATH:$PIO_HOME/bin

# Installing Dependencies
RUN mkdir PredictionIO/vendors

# Spark Setup
RUN wget -O - http://d3kbcqa49mib13.cloudfront.net/spark-1.3.0-bin-hadoop2.4.tgz | tar zx
RUN mv spark* PredictionIO/vendors/spark
RUN sed -i 's|SPARK_HOME=$PIO_HOME/vendors/spark-1.3.0-bin-hadoop2.4|SPARK_HOME=/PredictionIO/vendors/spark|' /PredictionIO/conf/pio-env.sh

# Elasticsearch Setup
RUN wget -O - https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.tar.gz | tar zx
RUN mv elasticsearch* PredictionIO/vendors/elasticsearch
RUN sed -i 's|PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME=$PIO_HOME/vendors/elasticsearch-1.4.4|PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME=$PIO_HOME/vendors/elasticsearch|' /PredictionIO/conf/pio-env.sh

# HBase Setup 
RUN wget -O - http://archive.apache.org/dist/hbase/hbase-1.0.0/hbase-1.0.0-bin.tar.gz | tar zx
RUN mv hbase* PredictionIO/vendors/hbase
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> PredictionIO/vendors/hbase/conf/hbase-env.sh
RUN sed -i 's|HBASE_CONF_DIR=$PIO_HOME/vendors/hbase-1.0.0/conf|HBASE_CONF_DIR=$PIO_HOME/vendors/hbase/conf|' /PredictionIO/conf/pio-env.sh
RUN sed -i 's|PIO_STORAGE_SOURCES_HBASE_HOME=$PIO_HOME/vendors/hbase-1.0.0|PIO_STORAGE_SOURCES_HBASE_HOME=$PIO_HOME/vendors/hbase|' /PredictionIO/conf/pio-env.sh


#expose web and api endpoints
EXPOSE 9000 8000


# #WORKDIR /

# #brute hack to inject credentials to server
# ADD create_user.sh ./create_user.sh
# RUN chmod +x create_user.sh
# RUN ./create_user.sh
# RUN apt-get remove -y mongodb-clients


# ADD waiter.sh /waiter.sh
# RUN chmod +x ./waiter.sh
