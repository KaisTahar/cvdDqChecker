#######################################################################################################
#' @description Harmonization interface for quality assessment on cardiovascular disease (CVD) data.
#' This interface supports mapping locally used data items to the the basic data set of the German Centre for Cardiovascular Research (DZHK-BDS).
#' The DZHK-BDS as a common data model facilitates the harmonized collection of patient data across different studies. 
#' @author Kais Tahar, University Medical Center Göttingen
#######################################################################################################

harmonizeData<-function (studyData, mpath, sheetName, refCol, synCol) {
  mappingDf <- getMappingDataFrame(mpath, sheetName)
  standardizedItems<- getMappingItems(mappingDf, refCol)
  synonyms<-getMappingItems(mappingDf, synCol)
  harmonizedData <- getHarmonizedData(studyData,  standardizedItems, synonyms)
  harmonizedData
}
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
  
getMappingItems<-function (mappingDf, cl) {
  itemVec <- mappingDf[[cl]]
  mappingItems <- itemVec[which(!(is.na(itemVec) & itemVec ==""))]
  mappingItems
}

getMappingDataFrame<-function (mPath, sheetName) {
  if (!(is.null(mPath) | (is.null(sheetName)| is.na(sheetName)))){
    mappingDf <- read.xlsx(xlsxFile=mPath, sheet=sheetName, skipEmptyRows=FALSE)
    return(mappingDf)
  } else stop("Please set the right path to mapping data by defining the variables mpath and sheetName")
}
