#######################################################################################################
#' @description explainable and Traceable assessments of cardiovascular disease (CVD) data.
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################
rm(list = ls())
setwd("./")
# Install required packages
source("./utils/installPackages.R")
# Import dqLib and required packages
library (dqLib)
library (openxlsx)
library (anytime)
library (ggplot2)
library (config)
# To suppress warnings
options(warn=-1) 
# Execution time
startTime <- base::Sys.time()
# Configuration variables
source("./utils/config.R")
# Data harmonization
source("./utils/harmonizationInterface.R")

cat("####################################***CvdDqChecker***########################################### \n \n")
# Check missing packages
pack <- unique(as.data.frame( (installed.packages())[,c(1,3)]))
dep <- c("dqLib", "openxlsx", "dplyr",  "anytime", "ggplot2", "config")
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

# Metadata for the DQ rules
ruleMeta_df <- read.xlsx(xlsxFile = domainMetadata, sheet = "Rule_metadata", skipEmptyRows = FALSE)
ruleMeta <- split(ruleMeta_df$Rule_metadata, ruleMeta_df$Abbreviation)

# Setting the report design and required DQ metrics
repData <- read.xlsx(xlsxFile = domainMetadata, sheet = "Report_metadata", skipEmptyRows = FALSE)
dqMetrics <-repData$Selected_DQ_metric[!is.na(repData$Selected_DQ_metric)]
sheetList <- repData$Spreadsheet_label[!is.na(repData$Spreadsheet_label)]
outlierReportMeta <- repData$Outliers_report_metadata[!is.na(repData$Outliers_report_metadata)]
missingReportMeta <- repData$Missings_report_metadata[!is.na(repData$Missings_report_metadata)] 
contraReportMeta <- repData$Contradictions_report_metadata[!is.na(repData$Contradictions_report_metadata)]
design <- list (outlierReportMeta, contraReportMeta, missingReportMeta)
semData <-subset(repData, select=c(Label,Abbreviation))
#------------------------------------------------------------------------------------------------------
# Setting required metadata
#------------------------------------------------------------------------------------------------------
metadata <- read.xlsx(xlsxFile = domainMetadata, sheet = "Metadata", skipEmptyRows = FALSE)
# Numerical data items
numMeta <- data.frame(basicItem=metadata$Numerical_data_item[!is.na(metadata$Numerical_data_item)])
# Temporal data items
tempMeta <-data.frame(basicItem=metadata$Temporal_data_item[!is.na(metadata$Temporal_data_item)])
# Categorical data items
catMeta<- data.frame(basicItem=metadata$Categorical_data_item[!is.na(metadata$Categorical_data_item)])

#------------------------------------------------------------------------------------------------------
# Import study data
#------------------------------------------------------------------------------------------------------
studyData <-read.table(dataPath, sep=",", dec=",", header=T, na.strings=c("","NA"), encoding = "UTF-8")
studyData<-harmonizeStudyData(studyData, domainMetadata, "Semantic_harmonization", "DZHK_basic_data_item", "Synonym")
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
# Visualization of detected outliers and contradictions
voPath = paste(exportPath, "/outliers", sep="")
visualizeOutliers("basicItem", "vo" , "total", voPath, a=TRUE, b=12, c=11, d=4)
voPath = paste(exportPath, "/contradictions", sep="")
visualizeContradictions("rID", "vc" ,"total", voPath, a=TRUE, b=12, c=11, d=4)
