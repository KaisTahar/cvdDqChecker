#######################################################################################################
#' @description Harmonization interface for data quality (DQ) assessment on cardiovascular disease (CVD) data.
#' This interface supports mapping locally used data items to the the basic data set of the German Centre for Cardiovascular Research (DZHK-BDS).
#' The DZHK-BDS as a common data model facilitates the harmonized collection and DQ assessments of CVD data across different studies. 
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################

#' @title harmonizeStudyData
#' @description Function to harmonized study data.
#' @export
#'
harmonizeStudyData<-function (studyData, mpath, sheetName, refCol, synCol) {
  mappingDf <- getMappingDataFrame(mpath, sheetName)
  standardizedItems<- getMappingItems(mappingDf, refCol)
  synonyms<-getMappingItems(mappingDf, synCol)
  harmonizedData <- getHarmonizedData(studyData,  standardizedItems, synonyms)
  harmonizedData
}

#' @title getHarmonizedData
#' @description  This function maps the semantics of original data items to the standardized data items.
#' @export
#'
getHarmonizedData<-function (studyData, standardizedItems, synonyms) {
  if (!is.empty(synonyms)){
      df <- data.frame(
      oldHeader = names(studyData), newHeader = names(studyData)
    )
    df <- lapply(df, as.character)
    oHeaders <- which(!is.na(df$oldHeader))
    for (i in oHeaders) {
      if (df$oldHeader[i] %in% synonyms){
        for (syn in synonyms) {
          if (syn== df$oldHeader[i]) {
              index = which(synonyms==syn)
              df$newHeader[i] <-standardizedItems[index]
          }
        }
      }
    }
    names(studyData) <- df$newHeader
    studyData
  } else studyData
}

#' @title getMappingItems
#' @description  This function provides the required mapping data.
#' @export
#'
getMappingItems<-function (mappingDf, cl) {
  itemVec <- mappingDf[[cl]]
  mappingItems <- itemVec[which(!(is.na(itemVec) & itemVec ==""))]
  mappingItems
}

#' @title getMappingDataFrame
#' @description Functions to extract mapping rules from spreadsheets.
#' @export
#'
getMappingDataFrame<-function (mPath, sheetName) {
  if (!(is.null(mPath) | (is.null(sheetName)| is.na(sheetName)))){
    mappingDf <- read.xlsx(xlsxFile=mPath, sheet=sheetName, skipEmptyRows=FALSE)
    return(mappingDf)
  } else stop("Please set the right path to mapping data by defining the variables mPath and sheetName")
}
