# Original credit: https://github.com/jpetazzo/dockvpn

# Smallest base image
FROM alpine:3.17.5

LABEL maintainer="Kyle Manna <kyle@kylemanna.com>"

ADD repositories /etc/apk/repositories

# Testing: pamtester
RUN apk add --update --no-cache --allow-untrusted openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester libqrencode pam_sqlite3 sqlite tzdata && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/

ADD pam_sqlite3.conf /etc/pam_sqlite3.conf
