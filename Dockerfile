FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential  wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
libgtest-dev googletest pkg-config
RUN git clone https://github.com/mcmtroffaes/inipp.git
WORKDIR /inipp
RUN mkdir /iniCorpus
RUN wget http://sample-file.bazadanni.com/download/applications/ini/sample.ini
RUN wget https://raw.githubusercontent.com/grafana/grafana/main/conf/sample.ini
RUN cp *.ini /iniCorpus
COPY fuzzers/fuzz.cpp .
RUN afl-g++ -I./inipp fuzz.cpp -o /fuzz

ENTRYPOINT ["afl-fuzz", "-i", "/iniCorpus", "-o", "/simpleiniOut"]
CMD ["/fuzz", "@@"]
