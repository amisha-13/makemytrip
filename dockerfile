#`use official tomcat 9 with Java 21 pre installed
FROM tomcat:9.0.82-jdk21-temurin

#Set maintainer label
LABEL maintainer = "amishajoshi2713@gmail.com"

#Remove default root app
RUN rm -rf /usr/local

#Create a user for running the container
RUN useradd -m makemytrip

#Copy your WAR file into the webapps directory
COPY ./target/makemytrip*.war /usr/local/tomcat/webapps

#Expose the default tomcat port
EXPOSE 8080

#Set the user to makemytrip-ms for security
USER makemytrip

#Default command to run tomcat
CMD ["catalina.sh","run"]