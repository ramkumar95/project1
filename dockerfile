FROM tomcat:9.0.80-jre11-temurin-jammy
WORKDIR webapps/
RUN apt update && apt install -y unzip
COPY 'jtrac-2.3.1.zip?viasf=1' .
COPY mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

RUN unzip jtrac-2.3.1.zip?viasf=1 && \
    cp jtrac-2.3.1/webapps/ROOT.war . && \
    rm -rf jtrac* __MACOSX && \
    unzip ROOT.war -d ROOT/ && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV database_driver=
ENV database_url=
ENV database_username=
ENV database_password=
ENV hibernate_dialect=
ENV hibernate_show_sql=

 
WORKDIR /usr/local/tomcat/webapps/ROOT/

RUN echo "jtrac.home=/usr/local/tomcat/webapps/ROOT/" >> /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jtrac-init.properties && \
    touch jtrac.properties && \
    echo database.driver='${database_driver}' > jtrac.properties && \
    echo database.url='${database_url}' >> jtrac.properties && \
    echo database.username='${database_username}' >> jtrac.properties && \
    echo database.password='${database_password}' >> jtrac.properties && \
    echo hibernate.dialect='${hibernate_dialect}' >>  jtrac.properties && \
    echo hibernate.show_sql='${hibernate_show_sql}' >> jtrac.properties
EXPOSE 8080