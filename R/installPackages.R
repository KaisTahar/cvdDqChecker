# install R package
if(!require('devtools')) install.packages('devtools')
library(devtools)
install_github("https://github.com/KaisTahar/dqLib/tree/v1.32.0")
if(!require('openxlsx')) install.packages('openxlsx')
if(!require('anytime')) install.packages('anytime')
if(!require('ggplot2')) install.packages('ggplot2')
