FROM ubuntu:16.04

RUN useradd -d /home/dpcore -ms /bin/bash -g root -G sudo dpcore -p 1234qwer
RUN echo 'dpcore:1234qwer' | chpasswd
#RUN echo 'dpcore' | passwd --stdin dpcore
USER dpcore
RUN mkdir -p /home/dpcore/data-api-svc/core-module-cloudsearch-1.0-SNAPSHOT/script


USER root
# STEP 1. Install ansible
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
