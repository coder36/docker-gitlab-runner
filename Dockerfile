from    ubuntu:16.04
run 	rm /bin/sh && ln -s /bin/bash /bin/sh

# make sure the package repository is up to date
run		echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
run     apt-get update
run		apt-get install -y unzip wget curl git

run		gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
run		curl -sSL https://get.rvm.io | bash -s stable


RUN 	/bin/bash -l -c rvm requirements
ENV 	PATH $PATH:/usr/local/rvm/bin
run		source /usr/local/rvm/scripts/rvm
run		rvm install 1.9.3
run		rvm install 2.2.3
run		rvm install 2.3
RUN 	echo "source /usr/local/rvm/scripts/rvm" >> /root/.bash_profile
RUN 	echo "rvm --default use 2.2.3" >> /root/.bash_profile

run			/bin/bash -l -c	rvm --default use 2.2.3

run		wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
run 	tail -2 /root/.bashrc >> /root/.bash_profile
run		/bin/bash -l -c	"nvm install 6.5.0"


run		wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
run		wget http://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip
run		unzip chromedriver_linux64.zip
run		chmod +x chromedriver
run		mv -f chromedriver /usr/local/share/chromedriver
run		ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
run		ln -s /usr/local/share/chromedriver /usr/bin/chromedriver


# Install vnc, xvfb in order to create a 'fake' display and firefox
run		apt-get install -y --allow-unauthenticated google-chrome-stable
run     apt-get install -y x11vnc xvfb

run     mkdir ~/.vnc
# Setup a password
run     x11vnc -storepasswd 1234 ~/.vnc/passwd


ENV DISPLAY :99

# Install Xvfb init script
ADD xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run

# Allow root to execute Google Chrome by replacing launch script
ADD google-chrome-launcher /usr/bin/google-chrome
RUN chmod a+x /usr/bin/google-chrome

run 	apt-get install -y python python-pip
run 	apt-get install -y lsb-release apt-transport-https

run     export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
run     echo "deb https://packages.cloud.google.com/apt cloud-sdk-xenial main" > /etc/apt/sources.list.d/google-cloud-sdk.list
run     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
run     apt-get update
run     apt-get install -y google-cloud-sdk google-cloud-sdk-app-engine-python

run     pip install virtualenv
run     virtualenv venv
run     ln -s /venv /root/venv
run     echo "done"
ENTRYPOINT /bin/bash -l
