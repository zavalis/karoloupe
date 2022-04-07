#install.packages('fs',lib='./lib')

#on line 45-53 there's a circular call, calling a function from its own package
# To set a relative current working directory:

if (!require("rstudioapi")) install.packages("rstudioapi")
library("rstudioapi") 
setwd(dirname(getActiveDocumentContext()$path))

.libPaths('./lib')
#install.packages('rcrossref')
library(rcrossref, lib.loc='./lib')
library(rtransparent,lib.loc='./lib')
library(oddpub,lib.loc='./lib')
library(metareadr,lib.loc='./lib')
library(stringr, lib.loc='./lib')
library(plyr, lib.loc='./lib')
library(crminer)

#install.packages("beepr")
library(beepr, lib.loc='./lib')


#defining the rootpath, and filelist
rootpath <- getwd()

# KAROLINSKA SUBSET
pmcidfilenameki="./pmcoalist_ki.csv"
pmcidlistki<-read.delim(pmcidfilenameki, header = TRUE, sep=',')
pmcidlistki=pmcidlistki$PMCID

pmcnumberki<-list()
for (i in pmcidlistki){
  go=str_replace(i,'PMC','')
  pmcnumberki=c(pmcnumberki,go)
  }

#STANFORD SUBSET
pmcidfilenamestanford="./pmcoalist_stanford.csv"
pmcidliststanford<-read.delim(pmcidfilenamestanford, header = TRUE, sep=',')
pmcidliststanford=pmcidliststanford$PMCID

pmcnumberstanford<-list()
for (i in pmcidliststanford){
  go=str_replace(i,'PMC','')
  pmcnumberstanford=c(pmcnumberstanford,go)
}

pmcidfilenamelund="./pmcoalist_lund.csv"
pmcidlistlund<-read.delim(pmcidfilenamelund, header = TRUE, sep=',')
pmcidlistlund=pmcidlistlund$PMCID

pmcnumberlund<-list()
for (i in pmcidlistlund){
  go=str_replace(i,'PMC','')
  pmcnumberlund=c(pmcnumberlund,go)
}


# remember that for this to work you need to have only open access publications from pmc!
errorpmcid=list()
count=1
for (i in pmcnumberki){tryCatch({filename=paste0('./publications/',"PMC",i,".xml")
                              metareadr::mt_read_pmcoa(pmcid=i, file_name=filename)
                              count=count+1
                              if (count %% 100 == 0){print(paste0(count," have been downloaded"))}
                              if(count%%length(pmcnumber) == 0){beep()}},
                              error = function(e)
                              errorpmcid=c(i,errorpmcid))}


for (i in pmcnumberstanford){tryCatch({filename=paste0('./publications_stanford/',"PMC",i,".xml")
                          metareadr::mt_read_pmcoa(pmcid=i, file_name=filename)
                          count=count+1
                          if (count %% 100 == 0){print(paste0(count," have been downloaded"))}
                          if(count%%length(pmcnumber) == 0){beep()}},
                          error = function(e)
                          errorpmcid=c(i,errorpmcid))}

for (i in pmcnumberlund){tryCatch({filename=paste0('./publications_lund/',"PMC",i,".xml")
                            metareadr::mt_read_pmcoa(pmcid=i, file_name=filename)
                            count=count+1
                            if (count %% 100 == 0){print(paste0(count," have been downloaded"))}
                            if(count%%length(pmcnumberlund) == 0){beep()}},
                            error = function(e)
                            errorpmcid=c(i,errorpmcid))}


filepathki='./publications_ki/'
filepathstanford='./publications_stanford/'
filepathlund='./publications_lund/'


# Creates a list called filelist with all the xml in the folder this script is in.
filelistki <- list.files(filepathki, pattern='*.xml', all.files=FALSE, full.names=FALSE)
length(filelistki)

fileliststanford <- list.files(filepathstanford, pattern='*.xml', all.files=FALSE, full.names=FALSE)
length(fileliststanford)

filelistlund <- list.files(filepathlund, pattern='*.xml', all.files=FALSE, full.names=FALSE)
length(filelistlund)

# Not downloaded ones
downloadedki=str_remove(filelistki,'PMC')
downloadedki=str_remove(downloadedki,'.xml')
notdownloadedki=setdiff(pmcnumberki, downloadedki)

# Not downloaded ones
downloadedstanford=str_remove(fileliststanford,'PMC')
downloadedstanford=str_remove(downloadedstanford,'.xml')
notdownloadedstanford=setdiff(pmcnumberstanford, downloadedstanford)

# Not downloaded ones
downloadedlund=str_remove(filelistlund,'PMC')
downloadedlund=str_remove(downloadedlund,'.xml')
notdownloadedlund=setdiff(pmcnumberlund, downloadedlund)


count=1
# try notdownloaded from ki and stanford dataset
for (i in notdownloadedlund){tryCatch({filename=paste0('./publications_lund/',"PMC",i,".xml")
                          metareadr::mt_read_pmcoa(pmcid=i, file_name=filename)
                          count=count+1
                          if (count %% 100 == 0){print(paste0(count," have been downloaded"))}
                          if(count%%length(pmcnumberlund) == 0){beep()}},
                          error = function(e)
                          errorpmcid=c(i,errorpmcid))}


# use notdownloaded! to continue when you have the time!

article <- rt_data_code_pmc('./publications_ki/PMC5337619.xml')

count<-1
#REMEMBER CONTINUE RUNNING THIS WITH ALL SAVED BUT JUST FROM THE POINT YOU LEFT IT AT YESTERDAY
for (i in filelistki){
  count=count+1
  i=paste0('./publications_ki/',i)
  article <- rt_all_pmc(i, remove_ns = T)
  #article <- rt_data_code_pmc(i)
  if (!exists("articles.data")) {
    articles.data <- article
  }
  
  else {
    articles.data <- rbind.fill(articles.data, article)
    #articles.data <- bind_rows(articles.data, article)
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}

  if (count %% length(fileliststanford) == 0){beep()}
  }; 
# funs() was deprecated in dplyr 0.8.0. please use a list of either functions or lambdas


write.csv(articles.data,"./output/resttransparency_ki.csv", row.names = FALSE); beep()
#write.csv(articles.data,"./output/codesharing_stanford.csv", row.names = FALSE); beep()


for (i in fileliststanford){
  count=count+1
  i=paste0('./publications_stanford/',i)
  #article <- rt_all_pmc(i, remove_ns = T)
  article <- rt_data_code_pmc(i, remove_ns = T)
  if (!exists("articles.data")) {
    articles.data <- article
  }
  
  else {
    articles.data <- rbind.fill(articles.data, article)
    #articles.data <- bind_rows(articles.data, article)
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(filelist) == 0){beep()}
}; 
# funs() was deprecated in dplyr 0.8.0. please use a list of either functions or lambdas


write.csv(articles.data,"./output/resttransparency.csv", row.names = FALSE); beep()
#write.csv(articles.data,"./output/codesharing.csv", row.names = FALSE); beep()










count=1
for (i in fileliststanford){
  count=count+1
  i=paste0('./publications_stanford/',i)
  article <- rt_all_pmc(i, remove_ns = T)
  #article <- rt_data_code_pmc(i, remove_ns = T)
  if (!exists("articles.rest.stanford")) {
    articles.rest.stanford <- article
  }
  
  else {
    articles.rest.stanford <- rbind.fill(articles.data, article)
    #articles.data <- bind_rows(articles.data, article)
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(fileliststanford) == 0){beep()}
}; write.csv(articles.rest.stanford,"./output/resttransparency_stanford.csv", row.names = FALSE); beep()
# funs() was deprecated in dplyr 0.8.0. please use a list of either functions or lambdas








# stanford
count=1
for (i in fileliststanford){
  count=count+1
  i=paste0('./publications_stanford/',i)
  
  article <- rt_data_code_pmc(i, remove_ns = T)
  if (!exists("articles.data.code.stanford")) {
    articles.data.code.stanford <- article
  }
  
  else {
    articles.data.code.stanford <- rbind.fill(articles.data.code.stanford, article)

  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(fileliststanford) == 0){beep()}
}; write.csv(articles.data.code.stanford,"./output/codesharing_stanford.csv", row.names = FALSE); beep()



count=1
for (i in fileliststanford){
  count=count+1
  i=paste0('./publications_stanford/',i)
  article <- rt_all_pmc(i, remove_ns = T)
  if (!exists("articles.data.rest.stanford")) {
    articles.data.rest.stanford <- article
  }
  
  else {
    articles.data.rest.stanford<- rbind.fill(articles.data.rest.stanford, article)
    #articles.data <- bind_rows(articles.data, article)
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(fileliststanford) == 0){beep()}
}; write.csv(articles.data.rest.stanford,"./output/resttransparency_stanford.csv", row.names = FALSE); beep()


# ki
count=1
for (i in filelistki){
  count=count+1
  i=paste0('./publications_ki/',i)
  
  article <- rt_data_code_pmc(i, remove_ns = T)
  if (!exists("articles.data.code.ki")) {
    articles.data.code.ki <- article
  }
  
  else {
    articles.data.code.ki <- rbind.fill(articles.data.code.ki, article)
    
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(filelistki) == 0){beep()}
}; write.csv(articles.data.code.ki,"./output/codesharing_ki.csv", row.names = FALSE); beep()



count=1
for (i in filelistki){
  count=count+1
  i=paste0('./publications_ki/',i)
  
  article <- rt_all_pmc(i, remove_ns = T)
  
  if (!exists("articles.data.rest.ki")) {
    articles.data.rest.ki <- article
  }
  
  else {
    articles.data.rest.ki <- rbind.fill(articles.data.rest.ki, article)
    #articles.data <- bind_rows(articles.data, article)
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(filelistki) == 0){beep()}
}; write.csv(articles.data.rest.ki,"./output/resttransparency_ki.csv", row.names = FALSE); beep()




# lund

count=1
for (i in filelistlund){
  count=count+1
  i=paste0('./publications_lund/',i)
  
  article <- rt_data_code_pmc(i, remove_ns = T)
  if (!exists("articles.data.code.lund")) {
    articles.data.code.lund <- article
  }
  
  else {
    articles.data.code.lund <- rbind.fill(articles.data.code.lund, article)
    
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(filelistlund) == 0){beep()}
}; write.csv(articles.data.code.lund,"./output/codesharing_lund.csv", row.names = FALSE); beep()



count=1
for (i in filelistlund){
  count=count+1
  i=paste0('./publications_lund/',i)
  article <- rt_all_pmc(i, remove_ns = T)
  if (!exists("articles.data.rest.lund")) {
    articles.data.rest.lund <- article
  }
  
  else {
    articles.data.rest.lund <- rbind.fill(articles.data.rest.lund, article)
    #articles.data <- bind_rows(articles.data, article)
  }
  if (count %% 100 == 0){print(paste0(count," have been processed"))}
  
  if (count %% length(filelistlund) == 0){beep()}
}; write.csv(articles.data.rest.lund,"./output/resttransparency_lund.csv", row.names = FALSE); beep()

