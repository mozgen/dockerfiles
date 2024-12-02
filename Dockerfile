# Tomcat 9 ve OpenJDK 8 tabanlı Dockerfile
FROM eclipse-temurin:8-jdk

# Proxy ayarları
ENV http_proxy http://proxytst.yasarsap.astron.grp:3128
ENV https_proxy http://proxytst.yasarsap.astron.grp:3128
ENV no_proxy 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.yasar.net,.yasar.grp

# Tomcat ortam değişkenleri
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_VERSION 9.0.97
ENV TOMCAT_SHA512 537dbbfc03b37312c2ec282c6906828298cb74e42aca6e3e6835d44bf6923fd8c5db77e98bf6ce9ef19e1922729de53b20546149176e07ac04087df786a62fd9

# Tomcat'i indir ve kur
RUN mkdir -p "$CATALINA_HOME" \
    && apt-get update && apt-get install -y curl \
    && curl -o tomcat.tar.gz "https://downloads.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz" \
    && echo "$TOMCAT_SHA512 tomcat.tar.gz" | sha512sum -c - \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm tomcat.tar.gz \
    && rm -rf $CATALINA_HOME/webapps/*

# Gerekli izinleri ayarla
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat \
    && chown -R tomcat:tomcat $CATALINA_HOME \
    && chmod -R 755 $CATALINA_HOME/conf \
    && chmod -R 755 $CATALINA_HOME/logs \
    && chmod -R 755 $CATALINA_HOME/temp \
    && chmod -R 755 $CATALINA_HOME/webapps \
    && chmod -R 755 $CATALINA_HOME/work

# Tomcat'i düşük yetkili kullanıcıyla çalıştır
USER tomcat

# Varsayılan Tomcat portu
EXPOSE 8080

# Tomcat başlatma komutu
CMD ["catalina.sh", "run"]
