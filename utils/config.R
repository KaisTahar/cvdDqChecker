#######################################################################################################
#' @description Setting local configuration parameters
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################
library(config)
conf <- config::get(file = paste(getwd(), "/config.yaml", sep = ""))

# p1) Check the configuration of study name and abbreviation
if (exists("studyName", where = conf) && nchar(conf$studyName) >= 2) {
  studyName <- conf$studyName
}else stop("No study name available, please set the studyName variable (v1) in the config file")

# p2) Check the configuration of organization_name
if (exists("organizationName", where = conf) && nchar(conf$organizationName) >= 2) {
  organizationName <- conf$organizationName
}else stop("No organization name available, please set the organizationName variable (v2) in the config file")

# p3) Check the data path configuration
if (exists("dataPath", where = conf) && nchar(conf$dataPath) >= 2) {
  dataPath= conf$dataPath
}else stop("No data path found, please set the dataPath variable (v3) in the config file")

# p4) check the configuration of missing codes
if (exists("missingCode", where = conf) && !is.null(conf$missingCode)) {
  missingCode<- conf$missingCode
} else {
  stop("No missing codes found, Please set the list of missing codes (v4) in the config file")
}

# p5) check the path to DQ rules
if (exists("rulePath", where = conf) && nchar(conf$rulePath) >= 2) {
  rulePath= conf$rulePath
}else stop("No rule path found, please set the rulePath variable (v5) in the config file")

# p6) check the path to the semantic annotations
if (exists("semanticPath", where = conf) && nchar(conf$semanticPath) >= 2) {
  semanticPath= conf$semanticPath
}else stop("No path to the semantic annotations found, please set the semanticPath variable (v6) in the config file")

# p7) check the export path configuration
if (exists("exportPath", where = conf) && nchar(conf$exportPath) >= 2) {
  exportPath= conf$exportPath
}else stop("No export path found, please set the exportPath variable (v7) in the config file")
