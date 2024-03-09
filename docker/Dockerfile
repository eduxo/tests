# Use ubuntu latest build as the Docker image base
FROM ubuntu:latest

# Update the Docker image
RUN apt-get update && apt-get install -y

# Install openssh server
RUN apt-get install openssh-server sudo -y

# Adding user to the sudo group, creating /home directory for that user and setting shell to be /bin/bash
RUN groupadd sysadmin
RUN useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin

# Setting password for user
RUN echo 'sysadmin:Netlab!23' | chpasswd

# Improt files to the Docker image
ADD files/ /home/sysadmin

# Starting ssh server
RUN service ssh start


# --------------------------------SETTINGS FOR EXAMS---------------------------------------



# --------------------------------SETTINGS FOR EXAMS---------------------------------------


# Exposing port 22 to the network
EXPOSE 22

# CMD function says what should happen after starting the container, RUN says what should happen in the compilation process of said container
CMD ["/usr/sbin/sshd","-D"]
