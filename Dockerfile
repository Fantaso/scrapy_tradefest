FROM ubuntu:bionic

MAINTAINER Carlos Rosas <fantaso.code@gmail.com>

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV LANG C.UTF-8
ENV LANGUAGE en_US.UTF-8

# ARG GECKODRIVER=v0.26.0


# OS: [dependencies]
RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    wget \
    # Firefox & Geckdriver Prerequisites
    unzip xvfb libxi6 libgconf-2-4 \
    firefox \
    # Erasing apt-get cache
    && rm -rf /var/lib/apt/lists/*

# OS: [Geckodriver]
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz  \
    && tar xzf geckodriver-v0.26.0-linux64.tar.gz  \
    && mv geckodriver /usr/bin/geckodriver  \
    && rm geckodriver-v0.26.0-linux64.tar.gz

#  OS: [User]
RUN useradd -m app
#USER app

###  APP: [dependencies]
COPY ./requirements.txt /home/app
RUN pip3 install --no-cache-dir -r /home/app/requirements.txt

###  APP: [repository]
COPY ./tradefest_scraper /home/app



#################################
###  Get ready, set & Python  ###
#################################
WORKDIR /home/app/tradefest_scraper/tradefest_scraper
CMD ["scrapy", "crawl", "tradefest"]
