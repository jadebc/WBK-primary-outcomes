##############################################
# WASH Benefits Kenya
# Primary outcome analysis 

# Length-for-age 
# N, mean, SD by arm

# input: washb-kenya-midline-anthro-public.csv,
# washb-kenya-endline-anthro-public.csv
# output: laz_mean.RData

# by Jade Benjamin-Chung (jadebc@berkeley.edu)
##############################################

rm(list=ls())

# define directories
source.dir="~/documents/crg/wash-benefits/kenya/src/primary/analysis/"
data.dir="~/Dropbox/WASHB-Kenya-Data/1-primary-outcome-datasets/Public/"
res.dir="~/Dropbox/WBK-primary-analysis/results/jade/"

m=read.csv(paste0(data.dir,"washb-kenya-midline-anthro-public.csv"))
e=read.csv(paste0(data.dir,"washb-kenya-endline-anthro-public.csv"))

source(paste0(source.dir,"0-base-programs.R"))

m=preprocess.anthro(m, "haz")
e=preprocess.anthro(e, "haz")

#----------------------------------------------
# N by arm
#----------------------------------------------
N.1=table(m$tr[!is.na(m$haz)])
N.2=table(e$tr[!is.na(e$haz)])

#----------------------------------------------
# mean haz by arm
#----------------------------------------------
mn.haz.1=as.numeric(t(aggregate(m$haz,list(m$tr),mean,na.rm=TRUE))[2,])
mn.haz.2=as.numeric(t(aggregate(e$haz,list(e$tr),mean,na.rm=TRUE))[2,])


#----------------------------------------------
# sd of haz by arm
#----------------------------------------------
sd.haz.1=as.numeric(t(aggregate(m$haz,list(m$tr),sd,na.rm=TRUE))[2,])
sd.haz.2=as.numeric(t(aggregate(e$haz,list(e$tr),sd,na.rm=TRUE))[2,])

laz_t1_n_j=as.data.frame(matrix(cbind(N.1,mn.haz.1,sd.haz.1),8,3))
rownames(laz_t1_n_j)=levels(m$tr)
colnames(laz_t1_n_j)=c("N","mean","sd")

laz_t2_n_j=as.data.frame(matrix(cbind(N.2,mn.haz.2,sd.haz.2),8,3))
rownames(laz_t2_n_j)=levels(e$tr)
colnames(laz_t2_n_j)=c("N","mean","sd")

laz_t1_n_j

laz_t2_n_j

save(laz_t1_n_j,laz_t2_n_j,
     file=paste0(res.dir,"laz_mean.RData"))




