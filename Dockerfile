# Dockerfile for local execution
FROM rocker/r-ver:4.2.2
LABEL Maintainer="kais.tahar@med.uni-goettingen.de" 
LABEL Description="cvdDqChecker: Quality checker for cardiovascular disease data"
WORKDIR /usr/local/src/myScripts

# install packages
#RUN apt-get update -qq && apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
RUN R -e "install.packages('openxlsx')"
RUN R -e "install.packages('stringi')"
RUN R -e "install.packages('anytime')"
RUN R -e "install.packages('ggplot2')"

# copy files
COPY . .

# run R script
CMD Rscript cvdDqChecker.R

