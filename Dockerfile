# INSTALL 
FROM node:8.17.0

#INSTALL LIBAIO1 & UNZIP (NEEDED FOR STRONG-ORACLE)
RUN apt-get update \
 && apt-get install -y libaio1 \
 && apt-get install -y build-essential \
 && apt-get install -y unzip \
 && apt-get install -y curl

#ADD ORACLE INSTANT CLIENT
RUN mkdir -p opt/oracle
ADD ./oracle/ .

RUN unzip instantclient-basiclite-linux.x64-18.3.0.0.0dbru.zip -d /opt/oracle \
 && unzip instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip -d /opt/oracle  \
 && mv /opt/oracle/instantclient_18_3 /opt/oracle/instantclient \
 && rm -f /instantclient-basiclite-linux.x64-18.3.0.0.0dbru.zip \
 && rm -f /instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip

RUN apt-get purge -y unzip
 
ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"
ENV OCI_VERSION=12

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig
