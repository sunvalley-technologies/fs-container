# FreeSwitch Containers

FreeSwitch container images for latest stable Debian release.

All images are tagged with Debian version and FreeSwitch version. E.g. for Debian 9.8 and FreeSwitch 1.8.5-6, the image 
is tagged as `sunvalley/freeswitch:9.8-1.8.5-6`.

## Configuration

By default, vanilla configuration is copied to `/etc/freeswitch` volume when the container is first started. You can 
either mount a different configuration to `/etc/freeswitch` or change the configuration manually after the container is 
started.

