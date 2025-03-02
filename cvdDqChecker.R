#######################################################################################################
#' @description Data quality analysis and reporting on cardiovascular disease (CVD) data.
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################
rm(list = ls())
setwd("./")
# install required packages
source("./utils/installPackages.R")
#import dqLib and required packages
library (dqLib)
library (openxlsx)
library (anytime)
library (ggplot2)
library (config)
# to suppress warnings
options(warn=-1) 
# execution time
startTime <- base::Sys.time()
# configuration variables
source("./utils/config.R")
# data harmonization
source("./utils/harmonizationInterface.R")

cat("####################################***CvdDqChecker***########################################### \n \n")
# check missing packages
pack <- unique(as.data.frame( (installed.packages())[,c(1,3)]))
dep <- c("openxlsx", "dplyr",  "anytime", "ggplot2")
depPkg <-subset(pack, pack$Package %in% dep)
diff <-setdiff(dep, depPkg$Package)
if (!is.empty(diff)) paste ("The following packages are missing:", toString (diff)) else{ 
  cat ("The following dependencies are installed:\n")
  print(depPkg, quote = TRUE, row.names = FALSE)
}
cat ("\n ####################################### Data Import ########################################## \n")

#------------------------------------------------------------------------------------------------------
# Setting metadata and report design
#------------------------------------------------------------------------------------------------------
# defining metadata
# numerical data items
numMeta <- data.frame(
  basicItem=c ("basis_groesse", "basis_gewicht", "basis_frequenz", "basis_systol",  "basis_diastol","basis_haemo",  "basis_kreatinin","basis_choles")
)
# temporal data items
tempMeta <- data.frame(
  basicItem=c ("basis_datum", "basis_gebdatum" ,  "basis_exrauch", "basis_datsum_blut",  "basis_menojahr", "basis_regeldat")
)
# categorical data items
catMeta<- data.frame(
  basicItem=c (
    "basis_hautfarbe", "basis_geschlecht", "basis_ethnie", "basis_meno", "basis_raucher" ,
    "basis_khk", "basis_myokard","basis_family","basis_vorhof",  "basis_revas", 
    "basis_bypass", "basis_herzklap","basis_herzklap_op", "basis_insuffizienz", "basis_kardmyopath","basis_schrittmacher", "basis_dialyse",
    "basis_schlagtia", "basis_diabetes", "basis_hypertonie", "basis_dyslipi", "basis_pavk","basis_copd", "basis_malignom","basis_depression",
    "basis_choles_einheit",  "basis_krea_einheit",  "basis_haemo_einhe", "basis_ahf", "basis_alkoholkrank"
  )
)
# define meta data for the DQ rules
ruleMeta <-list(
  mappRule="mappingRule",
  cvdItem="dzhkBasicDataSet",
  mappValue ="synonym",
  misgRule="missingRule",
  rangeRule="rangeRule",
  rangeRule="mappingRule",
  mathRule="mathRule",
  logicRule="logicalRule",
  ruleID ="ruleID",
  item1 ="item1",
  item2 ="item2",
  item3 ="item3",
  valueItem1 ="value(item1)",
  valueItem2 ="value(item2)",
  valueItem3 ="value(item3)",
  maxItem1 ="max(item1)",
  minItem1 ="min(item1)",
  mathOpr ="mathOperator",
  unit ="unit",
  minRslt="min(result)",
  maxRslt="max(result)"
)
# Report Design
sheetList <-list("DQ Metrics", "Outliers", "Contradictions", "Missings")
meta1<- c( "mnppsd", "centername", "formname","basis_datum", "basis_groesse", "basis_gewicht", "basis_frequenz", "basis_systol","basis_diastol","basis_choles","basis_haemo", "basis_kreatinin")
meta2<- c("mnppsd", "centername", "formname","basis_datum")
design <- list ("Outliers"=meta1, "Contradictions"=meta2, "Missings"=meta2)

#------------------------------------------------------------------------------------------------------
# Setting required DQ metrics and semantic mappings
#------------------------------------------------------------------------------------------------------
############## Selection of DQ metrics ##################
# select DQ indicators for completeness dimension from the publication DOI:10.1055/a-2006-1018.
compInd= c(
  "dqi_co_icr", 
  "dqi_co_vcr"
)
# select DQ indicators for plausibility dimension
plausInd= c( 
  "dqi_pl_rpr", 
  "dqi_pl_spr"
)
############ Selection of DQ parameters #################
# select parameters for DQ report from the publication DOI:10.1055/a-2006-1018.
param= c(
  "aPatient",
  "im",
  "vm",
  "im_misg",
  "vm_misg",
  #"s_inc",
  "vo",
  "vs_od",
  "vc", 
  "vs_cd",
  "pat_dq_iss"
)
dqMetrics <- c(compInd, plausInd, param)
# semantic mapping of labels and symbolic names (also called code variables)
semData <- read.table(semanticPath, sep=",",  dec=",", na.strings=c("","NA"), encoding = "UTF-8",header=TRUE)
#------------------------------------------------------------------------------------------------------
# Import study data
#------------------------------------------------------------------------------------------------------
studyData <-read.table(dataPath, sep=",", dec=",", header=T, na.strings=c("","NA"), encoding = "UTF-8")
studyData<-harmonizeStudyData(studyData, rulePath, ruleMeta$mappRule, ruleMeta$cvdItem, ruleMeta$mappValue)
studyData$basis_gebdatum <- getDateFormat(studyData$basis_gebdatum)

#------------------------------------------------------------------------------------------------------
# DQ Report and visualization
#------------------------------------------------------------------------------------------------------
metrics <- dqChecker(studyData, "CVD", numMeta, catMeta, tempMeta, "basicItem", NULL, missingCode, rulePath, ruleMeta)
dqRep <- cbind(metrics$parameters, metrics$indicators)
dqRep <- cbind (getPatRecordMetrics("mnppsd"), dqRep)
dqRep<-getUserSelectedMetrics(dqMetrics, dqRep)
df <- data.frame(st_name= studyName, org_id=organizationName, rep_date=as.Date(Sys.Date()))
dqRep <- cbind(df, dqRep)
expPath<- paste (exportPath, "/dqReports.xlsx", sep="")
endTime <- base::Sys.time()
timeTaken <-  round (as.numeric (endTime - startTime, units = "mins"), 2)
dqRep$exe_time <-timeTaken
report<-addSemantics(dqRep, semData, semData$Abbreviation)
getLongReport(report, sheetList, design, expPath)
top <- paste ("\n \n ####################################***CvdDqChecker***###########################################")
msg <- paste ("\n Data quality assessments for Organization:", dqRep$org_id,
              "\n Report Date:", dqRep$rep_date,
              "\n Patient Number:", dqRep$aPatient,
              "\n Item Completeness rate:", dqRep$dqi_co_icr,
              "\n Value completeness rate:", dqRep$dqi_co_vcr,
              "\n Range Plausibility Rate:", dqRep$dqi_pl_rpr,
              "\n Semantic Plausibility Rate:", dqRep$dqi_pl_spr,
              "\n Missing Mandatory Data Items:", dqRep$im_misg,
              "\n Missing Mandatory Data Values:", dqRep$vm_misg,
              "\n Outliers:", dqRep$vo,
              "\n Contradictory Data Values:", dqRep$vc
)
msg <- paste(msg, 
             "\n \n ########################################## Export ################################################")
msg <- paste (msg, "\n \n For more infos about data quality indicators see the generated report \n >>> in the file path:", expPath)
bottom <- paste (
  "\n ####################################***CvdDqChecker***###########################################\n")
cat(paste (top, msg, bottom, sep="\n"))

# visualization of detected outliers and contradictions
voPath = paste(exportPath, "/outliers", sep="")
visualizeOutliers("basicItem", "vo" , "Total", voPath)
voPath = paste(exportPath, "/contradictions", sep="")
visualizeContradictions("rID", "vc" ,"Total", voPath)