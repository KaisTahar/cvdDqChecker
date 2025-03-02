#######################################################################################################
#' @description Setting local configuration
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################
library(config)
conf <- config::get(file = paste(getwd(), "/config.yaml", sep = ""))

# v1) check for study name and abbreviation
if (exists("study_name", where = conf) && nchar(conf$study_name) >= 2) {
  study_name <- conf$study_name
}else stop("No study name available, please set the study_name in the config file")
if (exists("study_abbr", where = conf) && nchar(conf$study_abbr) >= 2) {
  study_abbr <- conf$study_abbr
}else stop("No study abbreviation available, please set the study_abbr in the config file")

# v2) check for organization_name
if (exists("organization_name", where = conf) && nchar(conf$organization_name) >= 2) {
  organization_name <- conf$organization_name
}else stop("No organization_name available, please set your organization_name in the config file")

# v3) check for data path configuration
if (exists("data_path", where = conf) && nchar(conf$data_path) >= 2) {
  data_path= conf$data_path
}else stop("No data path found, please set the data path in the config file")

# v4) check for missing codes
if (exists("missing_code", where = conf) && !is.null(conf$missing_code)) {
  missing_code<- conf$missing_code
} else {
  stop("No missing codes found, Please set the list of missing codes in the config file")
}

# v5) check for rule path configuration
if (exists("rule_path", where = conf) && nchar(conf$rule_path) >= 2) {
  rule_path= conf$rule_path
}else stop("No rule path found, please set the rule path in the config file")

# v6) check the path to the semantic annotations
if (exists("semantic_path", where = conf) && nchar(conf$semantic_path) >= 2) {
  semantic_path= conf$semantic_path
}else stop("No path to the semantic annotations found, please set the semantic_path in the config file")

# v7) check for export path configuration
if (exists("export_path", where = conf) && nchar(conf$export_path) >= 2) {
  export_path= conf$export_path
}else stop("No export path found, please set the export path in the config file")
