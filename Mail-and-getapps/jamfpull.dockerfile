from ubuntu

RUN mkdir -p /mall-and-jamfpull



RUN apt update -y
RUN apt install mailx -y
RUN apt install xmlstarlet -y


COPY jamfpull.sh /mail-and-jamfpull

RUN chmod +x /mall-and-jamfpull/jamfpull.sh


RUN /mall-and-jamfpull/jamfpull.sh


expose 443
expose 25