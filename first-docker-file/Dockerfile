FROM httpd

#make the directory to put html file

RUN mkdir -p /var/www/

#RUN apt update && intstall nano & systemctl

RUN apt update -y
RUN apt install -y nano
RUN apt install -y systemctl

#add html files, change permns of diretory, and replace httpd.conf 

COPY example-webpage /var/www
RUN chmod -R 755 /var/www
COPY httpd-vhosts.conf /usr/local/apache2/conf/extra


#restart apache
CMD [ "killall", "httpd" ]
CMD [ "httpd-foreground ]


#expose the ports needed
expose 443
expose 80
expose 8080

###################################
#Keep docker alive if httpd closes#
###################################


#CMD [ "tail", "-f", "/dev/null" ]


