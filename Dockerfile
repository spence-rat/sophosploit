FROM ubuntu:focal

#Environment variable to make apache2 install noninteractive
ENV DEBIAN_FRONTEND=noninteractive

#Install all packages required
RUN apt-get update && \
    apt-get --force-yes -y install \
    autoconf \
    apache2 \
    subversion\
    wget \
    nfs-common \
    rsh-client \
    whois \
    snmp \
    curl \
    vim \
    git \ 
    python3-pip \
    build-essential \
    zlib1g \
    zlib1g-dev \
    libpq-dev \
    libpq5 \
    libpcap-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxml2-dev \
    libxslt1-dev \
    libssl-dev \
    tzdata \ 
    net-tools \
    ruby \
    ruby-dev \
    postgresql \
    pgadmin3 \
    sqlite3 && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/*
    

#Configure git
RUN git config --global user.name "spence-rat" \
    && git config --global user.email "spence.rat@outlook.com"
RUN git clone https://github.com/spence-rat/msf5.git /metasploit-framework
RUN git clone https://github.com/spence-rat/social-engineer-toolkit.git/ /opt/set

#Place the answerfile for seautomate
COPY autosploit.py /opt/set/autosploit.py
RUN chmod +x /opt/set/autosploit.py

#Install requirements for seautomate from set directory
WORKDIR /opt/set
RUN pip install -r requirements.txt

#Install setoolkit
RUN python3 setup.py install

#Change set.config file to work in current context
RUN sed -i '95 c\\APACHE_SERVER=ON' /etc/setoolkit/set.config
RUN sed -i '103 c\\WEB_PORT=80' /etc/setoolkit/set.config
RUN sed -i '33 c \\METASPLOIT_PATH=/metasploit-framework' /etc/setoolkit/set.config


#Create web server directory & file for setoolkit/apache
RUN mkdir -p /var/www/html/
RUN touch /var/www/html/index.html

#Adjust apache2 configurations
WORKDIR /etc
RUN rm -rf apache2
RUN git clone https://github.com/spence-rat/apache2.git

#Adjust apache2 modules
WORKDIR /usr/lib/apache2
RUN rm -rf modules
RUN git clone https://github.com/spence-rat/apache2modules.git

#Install metasploit framework version 5
WORKDIR /msf5/metasploit-framework-5.0.101
RUN gem install bundler:1.17.3
RUN bundle install
RUN chmod +x msfconsole

COPY encrypt.rb /metasploit-framework/scripts/meterpreter/encrypt.rb
