FROM eclipse-temurin:8-jdk

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV http_proxy http://proxytst.yasarsap.astron.grp:3128
ENV https_proxy http://proxytst.yasarsap.astron.grp:3128
ENV no_proxy 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.yasar.net,.yasar.grp

# Tomcat kurulumu
RUN mkdir -p "$CATALINA_HOME" \
    && apt-get update && apt-get install -y curl \
    && curl -o tomcat.tar.gz "https://downloads.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz" \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm tomcat.tar.gz \
    && if [ ! -f "$CATALINA_HOME/bin/catalina.sh" ]; then echo "Error: catalina.sh not found"; exit 1; fi

# Gerekli izinlerin ayarlanması
RUN chmod -R 777 "$CATALINA_HOME/conf" \
    && chmod -R 777 "$CATALINA_HOME/logs" \
    && chmod -R 777 "$CATALINA_HOME/temp" \
    && chmod -R 777 "$CATALINA_HOME/webapps" \
    && chmod -R 777 "$CATALINA_HOME/work" \
    && chmod +x "$CATALINA_HOME/bin/catalina.sh"

# Çalışma dizini ayarı
WORKDIR $CATALINA_HOME

# Port ayarı
EXPOSE 8080

# Tomcat çalıştırma komutu
CMD ["catalina.sh", "run"]
