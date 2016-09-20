FROM registry.access.redhat.com/rhel6
MAINTAINER Vinny Valdez <vvaldez@redhat.com>
RUN yum -y install openssh-server &&\
  sed -i 's/^#Port 22/Port 2222/g' /etc/ssh/sshd_config &&\
  service sshd start &&\
  echo 'atomic' |passwd root --stdin &&\
  yum clean all
LABEL RUN 'docker run -it \
  --name ${NAME} -e NAME=${NAME} -e IMAGE=${IMAGE} \
  -d \
  --privileged \
  --net=host \
  --pid=host \
  --ipc=host \
  -v /srv:/srv \
  -v /dev:/dev \
  -v /run:/run \
  ${IMAGE} '/usr/sbin/sshd -D'
LABEL STOP 'docker kill -s TERM ${NAME}'
