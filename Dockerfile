FROM debian:9.8

RUN groupadd -r freeswitch --gid=999 && useradd -r -g freeswitch --uid=999 freeswitch

RUN apt-get update && apt-get install -y gnupg2 wget gosu
RUN wget -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add -

RUN echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" >> /etc/apt/sources.list.d/freeswitch.list

RUN apt-get update && apt-get install -y freeswitch \
                                         freeswitch-init \
                                         freeswitch-timezones \
                                         freeswitch-music \
                                         freeswitch-mod-opus \
                                         freeswitch-mod-silk \
                                         freeswitch-conf-curl \
                                         freeswitch-conf-insideout \
                                         freeswitch-conf-sbc \
                                         freeswitch-conf-softphone \
                                         freeswitch-conf-vanilla \
                                         freeswitch-lang-en \
                                         freeswitch-sounds-en \
                                         freeswitch-mod-say-en \
                                         freeswitch-mod-abstraction \
                                         freeswitch-mod-avmd \
                                         freeswitch-mod-blacklist \
                                         freeswitch-mod-commands \
                                         freeswitch-mod-conference \
                                         freeswitch-mod-curl \
                                         freeswitch-mod-distributor \
                                         freeswitch-mod-dptools \
                                         freeswitch-mod-esl \
                                         freeswitch-mod-expr \
                                         freeswitch-mod-fifo \
                                         freeswitch-mod-hash \
                                         freeswitch-mod-httapi \
                                         freeswitch-mod-http-cache \
                                         freeswitch-mod-nibblebill \
                                         freeswitch-mod-png \
                                         freeswitch-mod-redis \
                                         freeswitch-mod-sms \
                                         freeswitch-mod-sonar \
                                         freeswitch-mod-spy \
                                         freeswitch-mod-translate \
                                         freeswitch-mod-valet-parking \
                                         freeswitch-mod-video-filter \
                                         freeswitch-mod-voicemail \
                                         freeswitch-mod-voicemail-ivr \
                                         freeswitch-mod-dialplan-directory \
                                         freeswitch-mod-dialplan-xml \
                                         freeswitch-mod-loopback \
                                         freeswitch-mod-portaudio \
                                         freeswitch-mod-rtc \
                                         freeswitch-mod-rtmp \
                                         freeswitch-mod-sofia \
                                         freeswitch-mod-cdr-csv \
                                         freeswitch-mod-cdr-sqlite \
                                         freeswitch-mod-event-socket \
                                         freeswitch-mod-json-cdr \
                                         freeswitch-mod-local-stream \
                                         freeswitch-mod-native-file \
                                         freeswitch-mod-portaudio-stream \
                                         freeswitch-mod-shell-stream \
                                         freeswitch-mod-sndfile \
                                         freeswitch-mod-tone-stream \
                                         freeswitch-mod-lua \
                                         freeswitch-mod-console \
                                         freeswitch-mod-logfile \
                                         freeswitch-mod-syslog \
                                         freeswitch-mod-posix-timer \
                                         freeswitch-mod-timerfd \
                                         freeswitch-mod-xml-cdr \
                                         freeswitch-mod-xml-rpc && apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get autoremove

COPY docker-entrypoint.sh /
# Add anything else here

## Ports
# Open the container up to the world.
### 8021 fs_cli, 5060 5061 5080 5081 sip and sips, 64535-65535 rtp
EXPOSE 8021/tcp
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5061/tcp 5061/udp 5081/tcp 5081/udp
EXPOSE 7443/tcp
EXPOSE 5070/udp 5070/tcp
EXPOSE 64535-65535/udp
EXPOSE 16384-32768/udp


# Volumes
## Freeswitch Configuration
VOLUME ["/etc/freeswitch"]
## Tmp so we can get core dumps out
VOLUME ["/tmp"]

# Limits Configuration
COPY    build/freeswitch.limits.conf /etc/security/limits.d/

# Healthcheck to make sure the service is running
SHELL       ["/bin/bash"]
HEALTHCHECK --interval=15s --timeout=5s \
    CMD  fs_cli -x status | grep -q ^UP || exit 1


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]