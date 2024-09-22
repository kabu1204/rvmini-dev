FROM ubuntu:20.04

ENV TZ=Asia/Hong_Kong

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-17-jdk curl git wget openssh-server python-is-python3 vim

# riscv toolchain
RUN apt-get install -y autoconf automake autotools-dev curl  \
    libmpfr-dev libgmp-dev libusb-1.0-0-dev \
    gawk build-essential flex texinfo gperf libtool \
    patchutils bc zlib1g-dev device-tree-compiler pkg-config \
    libexpat-dev libfl-dev libmpc-dev help2man \
    verilator bison

RUN apt-get install -y zsh \
    && git clone https://gitee.com/mirrors/ohmyzsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && sed -i "s/robbyrussell/bira/" ~/.zshrc \
    && usermod --shell /bin/zsh root \
    && echo "export LD_LIBRARY_PATH=/usr/local/lib64:\$LD_LIBRARY_PATH" >> ~/.zshrc

RUN mkdir /var/run/sshd

# scala
RUN curl -s -L https://github.com/sbt/sbt/releases/download/v1.9.7/sbt-1.9.7.tgz | tar xvz && mv sbt/bin/sbt /usr/local/bin/

SHELL ["/bin/zsh", "-c"]

WORKDIR /root

# ssh 
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
COPY docker-ssh-config/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
EXPOSE 22

CMD ["/bin/zsh"]
