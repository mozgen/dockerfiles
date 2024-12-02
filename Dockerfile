# Tomcat 9 ve OpenJDK 8 tabanlı bir Dockerfile

# Eclipse Temurin tabanlı OpenJDK 8 görüntüsünü kullanıyoruz
FROM eclipse-temurin:8-jdk

# Proxy ayarları
ENV http_proxy http://proxytst.yasarsap.astron.grp:3128
ENV https_proxy http://proxytst.yasarsap.astron.grp:3128
ENV no_proxy 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.yasar.net,.yasar.grp

# Çevre değişkenleri
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Tomcat sürümü
ENV TOMCAT_VERSION 9.0.97

# Tomcat'in SHA-512 doğrulama değeri
ENV TOMCAT_SHA512 537dbbfc03b37312c2ec282c6906828298cb74e42aca6e3e6835d44bf6923fd8c5db77e98bf6ce9ef19e1922729de53b20546149176e07ac04087df786a62fd9

# Tomcat için çalışma dizinini oluştur
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Tomcat'i indirme ve kurma
RUN apt-get update && apt-get install -y curl \
    && curl -o tomcat.tar.gz "https://downloads.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz" \
    && echo "$TOMCAT_SHA512 tomcat.tar.gz" | sha512sum -c - \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm tomcat.tar.gz \
    && rm -rf webapps/*

# Web uygulaması için deploy klasörü oluştur
RUN mkdir -p $CATALINA_HOME/webapps

# Varsayılan olarak 8080 portunu aç
EXPOSE 8080

# Java ve Tomcat için varsayılan JVM ayarları
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Tomcat çalıştırma komutu
CMD ["catalina.sh", "run"]
