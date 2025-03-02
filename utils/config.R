#######################################################################################################
#' @description Setting local configuration
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################
library(config)
conf <- config::get(file = paste(getwd(), "/config.yaml", sep = ""))

# v1) check for study name and abbreviation
if (exists("studyName", where = conf) && nchar(conf$studyName) >= 2) {
  studyName <- conf$studyName
}else stop("No study name available, please set the studyName variable (v1) in the config file")

# v2) check for organization_name
if (exists("organizationName", where = conf) && nchar(conf$organizationName) >= 2) {
  organizationName <- conf$organizationName
}else stop("No organization name available, please set the organizationName variable (v2) in the config file")

# v3) check for data path configuration
if (exists("dataPath", where = conf) && nchar(conf$dataPath) >= 2) {
  dataPath= conf$dataPath
}else stop("No data path found, please set the dataPath variable (v3) in the config file")

# v4) check for missing codes
if (exists("missingCode", where = conf) && !is.null(conf$missingCode)) {
  missingCode<- conf$missingCode
} else {
  stop("No missing codes found, Please set the list of missing codes (v4) in the config file")
}

# v5) check for rule path configuration
if (exists("rulePath", where = conf) && nchar(conf$rulePath) >= 2) {
  rulePath= conf$rulePath
}else stop("No rule path found, please set the rulePath variable (v5) in the config file")

# v6) check the path to the semantic annotations
if (exists("semanticPath", where = conf) && nchar(conf$semanticPath) >= 2) {
  semanticPath= conf$semanticPath
}else stop("No path to the semantic annotations found, please set the semanticPath variable (v6) in the config file")

# v7) check for export path configuration
if (exists("exportPath", where = conf) && nchar(conf$exportPath) >= 2) {
  exportPath= conf$exportPath
}else stop("No export path found, please set the exportPath variable (v7) in the config file")
