FROM debian:bullseye

RUN apt update && apt install -y \
	debos \
	xz-utils \
	dosfstools \
	libterm-readkey-perl \
	user-mode-linux \
	libslirp-helper \
	device-tree-compiler \
	libncurses5 \
	libncurses5-dev \
	build-essential \
	libssl-dev \
	mtools \
	bc \
	python \
	dosfstools \
	python2 \
	flex \
	bison \
	u-boot-tools \
	ruby-full \
	rsync \
	vim \
	ssh \
	ssh-import-id \
	git \
	tree \
	debian-keyring \
	gpgv \
	network-manager \
	host \
	curl \
	bmap-tools \
	wget

RUN gem install fpm

RUN wget https://dl.radxa.com/tools/linux/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.gz && \
    tar xzf gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.gz -C /usr/local/

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts

ENV USER=root \
    HOME=/root

ENV PATH="/usr/local/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin:${PATH}"
