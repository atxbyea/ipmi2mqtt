FROM alpine:3.13.0

RUN apk update && apk add \
    ipmitool \
    mosquitto-clients

RUN echo '* * * * * ipmitool -H $IPMIHOST -U $IPMIUSER -P $IPMIPASS -I $IPMIVARIABLE1 $IPMIVARIABLE2 | grep $IPMIGREP | cut -c $IPMICUT > $IPMIFILE' > /etc/crontabs/root
RUN echo '* * * * * ( sleep 10; mosquitto_pub -h $MOSQUITTOHOST -u $MOSQUITTOUSER -P $MOSQUITTOPASS -t $MOSQUITTOTOPIC -f $IPMIFILE )' >> /etc/crontabs/root

CMD ["/usr/sbin/crond", "-l", "2", "-f"]
