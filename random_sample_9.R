# setup library and MSM package
library(msm)
library(xlsx)


# load and setup ELECT
#source("S:/.../ELECT file location/ELECT_version1_0_quickfix.r")
source("C:/Users/xiaohao/Documents/Rwork/ELECT_version1_0.r")
## Working directory
#setwd("S:/.../working directory")
setwd("C:/Users/xiaohao/Documents/Rwork")
getwd()


d1=read.csv('C:/Users/xiaohao/Documents/Rwork/TestData_12_08_05.CSV', header=TRUE)
d1$age<-d1$age-45 # transform ages

d1<-d1[order(d1$patid,d1$age),] # to order by patient id and age


# generate Q matrix structure
Q<-rbind(c(0,0.1,0,0,0.1),c(0,0,0.1,0,0.1),c(0,0,0,0.1,0.1),c(0,0,0,0,0.1),c(0,0,0,0,0))

starttime<-Sys.time() # start recording runtime

##################################################################################
# Code for models
rangeofcovariates<-c('age+imd07q+gender','age','imd07q','gender')


statetab<-statetable.msm(state,patid,data=d1) # generate statetable matrix to check that the transitions are correct and numbers of each type of transitions are sufficient 



name_of_excel<-list("1208_test_random_output_05.xlsx")
name_of_plot<-list("1208_test_random_output_05")
mse_o_e<-matrix(NA,ncol=5,nrow=2)
ER_o_e<-matrix(NA,ncol=5,nrow=2)


for (i in 1:2){
  
  
  for(k in 2:2){
    
    # setup Excel worksheet
    xlsx0<-name_of_excel[1]
    
    
    NAME<-as.name(rangeofcovariates[i])
    
    covariate<-as.formula(paste("~",paste(NAME, collapse="+")))
    
    
    cat("the", i, "th forumla of covariates is ","\n")
    print(covariate)
    cat("the k value is",k,"\n")
    
    
    
    
    
    m2<-msm(state~age,subject=patid,data=d1,gen.inits=TRUE,qmatrix=Q,center=FALSE,
            
            death=TRUE,obstype=k,hessian = FALSE,covariates=covariate,control=list(fnscale=10^4,maxit=10000,reltol=1e-10,trace=1,REPORT=1))
    
    # output model params
    qnames<-c("q12","q15","q23","q25","q34","q35","q45")
    #qnames<-c("12","23","34","45")
    #p<-round(m2$estimates,4)
    #se<-round(sqrt(diag(m2$covmat)),4)
    #param<-data.frame(qnames,p,se)
    
    
    p_1<-pmatrix.msm(m2,t=1)
    p_10<-pmatrix.msm(m2,t=10)
    p_20<-pmatrix.msm(m2,t=20)
    
    p_1<-matrix(as.numeric(p_1),ncol=5,nrow=5)
    
    
    p_10<-matrix(as.numeric(p_10),ncol=5,nrow=5)
    p_20<-matrix(as.numeric(p_20),ncol=5,nrow=5)
    write.xlsx(p_1,file=paste(xlsx0),sheetName="transition matrix_year_1",append=TRUE)
    write.xlsx(p_20,file=paste(xlsx0),sheetName="transition matrix_year_20",append=TRUE)
    
    
    
    par(mfrow=c(1,1))
    
    plot(m2,legend.pos = c(30,1),xlab="time",ylab = "survival of probability")
    title(main =name_of_plot[i])
    options(digits=3)
    prevalence<-prevalence.msm(m2,times=seq(1,42,1))
    write.xlsx(prevalence[1],file=paste(xlsx0),sheetName="observed number of state_obtype=2",append=TRUE)
    write.xlsx(prevalence[2],file=paste(xlsx0),sheetName="expected number of state_obtype=2",append=TRUE)
    write.xlsx(prevalence[3],file=paste(xlsx0),sheetName="observed percentage number of state_obtype=2",append=TRUE)
    write.xlsx(prevalence[4],file=paste(xlsx0),sheetName="expected percentage number of state_obtype=2",append=TRUE)
    
    plot.prevalence.msm(m2,mintime = 0,maxtime=42)
    
    
    # calculate the mse/ estimated error between observed and expected number of state and percentage at ages
    number_of_observed<-data.frame(prevalence[1]$Observed)
    number_of_expected<-data.frame(prevalence[2]$Expected)
    percentage_of_observed<-data.frame(prevalence[3]$`Observed percentages`)
    percentage_of_expected<-data.frame(prevalence[4]$`Expected percentages`)
    
    
    
    
    mse_o_e[i,1]<-mean((number_of_expected$State.1-number_of_observed$State.1)^2)
    mse_o_e[i,2]<-mean((number_of_expected$State.2-number_of_observed$State.2)^2)
    mse_o_e[i,3]<-mean((number_of_expected$State.3-number_of_observed$State.3)^2)
    mse_o_e[i,4]<-mean((number_of_expected$State.4-number_of_observed$State.4)^2)
    mse_o_e[i,5]<-mean((number_of_expected$State.5-number_of_observed$State.5)^2)
    ER_o_e[i,1]<-mean(abs(percentage_of_expected$State.1-percentage_of_observed$State.1))
    ER_o_e[i,2]<-mean(abs(percentage_of_expected$State.2-percentage_of_observed$State.2))
    ER_o_e[i,3]<-mean(abs(percentage_of_expected$State.3-percentage_of_observed$State.3))
    ER_o_e[i,4]<-mean(abs(percentage_of_expected$State.4-percentage_of_observed$State.4))
    ER_o_e[i,5]<-mean(abs(percentage_of_expected$State.5-percentage_of_observed$State.5))
    
    
    
    
  }
}



endtime<-Sys.time() # stop recording runtime