#'Summary Data
#'@description Summary Data
#'@usage load_aggregated_data(file, type, ...)
#'@param file the file in read.csv or read.xlsx2.
#'@param type a string of file name ended either with .xlsx or .csv.
#'@param ... Additional arguments for xlsx::read.xlsx2 or read.csv.
#'@details
#'
#'@return a list of three data frames: "expression"(sample in row), "feature"(compoud in row) and "phenotype"(sample in row).
#'@author Sili Fan \email{fansili2013@gmail.com}
#'@seealso \code{\link{load_expression_data}}, \code{\link{load_expression_data}}, \code{\link{load_expression_data}}
#'@examples
#'load_aggregated_data(input$inputID,startRow=2)
#'@export

stat_summary_data = function(DATA){
  eData = DATA$expression
  fData = DATA$feature
  pData = DATA$phenotype


  # if data does not have repeated subjectID, then we don't need to show repeated_measure_factor
  if(sum(duplicated(DATA$phenotype$subjectID))==0){
    no_repeated = TRUE
  }else{
    no_repeated = FALSE
  }

  type_of_each_colum_pData = sapply(pData, function(x){class(x)})

  pData_columns_num = lapply(pData, function(x){length(unique(x))})
  fData_columns_num = lapply(fData, function(x){length(unique(x))})

  pComponents = sapply(pData, unique)
  fComponents = sapply(fData, unique)


  why_not_able = vector()
  for(i in 1:ncol(pData)){
    why_not_able[i] = paste(ifelse(type_of_each_colum_pData[i]=="numeric","numeric",""),ifelse(pData_columns_num[i]>(nrow(eData)/3),"too_many_levels",""))
    if(pData_columns_num[i]==1){
      why_not_able[i] = "only_one_level"
    }
  }

  why_not_able[which(colnames(pData)%in%"subjectID")] = "too_many_levels"


  guess_factor = stat_guess_factor(DATA)
  guess_independent_factor = guess_factor[2]
  guess_repeated_factor = guess_factor[1]

  result = list(pComponents = pComponents,fComponents =fComponents,number_of_sample=nrow(pData),number_of_feature = nrow(fData),column_names_of_pData = colnames(pData),column_names_of_fData = colnames(fData),
                ncol_of_p = ncol(pData), ncol_of_f = ncol(fData),no_repeated = no_repeated,
                type_of_each_colum_pData = type_of_each_colum_pData, pData_columns_num = pData_columns_num,fData_columns_num=fData_columns_num,
                why_not_able = why_not_able, guess_independent_factor = guess_independent_factor, guess_repeated_factor = guess_repeated_factor)
  return(result)
}
