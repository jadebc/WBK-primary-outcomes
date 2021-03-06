##############################################
# WASH Benefits Kenya
# Primary outcome analysis 

# Severe sstunting 
# n, N, prevalence, and 95% CI by arm at
# baseline and follow-up

# input: washb-kenya-midline-anthro-public.csv,
# washb-kenya-endline-anthro-public.csv
# output: sstunt_prev.RData

# by Jade Benjamin-Chung (jadebc@berkeley.edu)
##############################################
library(washb)

rm(list=ls())

# define directories
source.dir="~/documents/crg/wash-benefits/kenya/src/primary/analysis/"
data.dir="~/Dropbox/WASHB-Kenya-Data/1-primary-outcome-datasets/Public/"
res.dir="~/Dropbox/WBK-primary-analysis/results/jade/"

m=read.csv(paste0(data.dir,"washb-kenya-midline-anthro-public.csv"))
e=read.csv(paste0(data.dir,"washb-kenya-endline-anthro-public.csv"))

source(paste0(source.dir,"0-base-programs.R"))

m=preprocess.anthro(m, "sstunted")
e=preprocess.anthro(e, "sstunted")

#----------------------------------------------
# n and N by arm and follow-up time point
#----------------------------------------------
N.1=table(m$tr[!is.na(m$sstunted)])
n.1=table(m$sstunted,m$tr)[2,]

sstunt_t1_n_j=data.frame(cbind(N.1=N.1,n.1=n.1))

N.2=table(e$tr[!is.na(e$sstunted)])
n.2=table(e$sstunted,e$tr)[2,]

sstunt_t2_n_j=data.frame(cbind(N.2=N.2,n.2=n.2))

names(N.1)=NULL
names(N.2)=NULL

#----------------------------------------------
# prevalence by arm and time point
#----------------------------------------------
sstunt_t1_prev_j=t(sapply(levels(m$tr), function(x) washb_mean(
  Y=m$sstunted[m$tr==x],id=m$clusterid[m$tr==x],print=FALSE)))

sstunt_t2_prev_j=t(sapply(levels(e$tr), function(x) washb_mean(
  Y=e$sstunted[e$tr==x],id=e$clusterid[e$tr==x],print=FALSE)))

colnames(sstunt_t1_prev_j)=c("N","Prev","SD","Robust SE","lb","ub")
colnames(sstunt_t2_prev_j)=c("N","Prev","SD","Robust SE","lb","ub")

# drop columns that aren't needed
sstunt_t1_prev_j=sstunt_t1_prev_j[,c("Prev","lb","ub")]
sstunt_t2_prev_j=sstunt_t2_prev_j[,c("Prev","lb","ub")]

sstunt_t1_n_j
sstunt_t2_n_j

sstunt_t1_prev_j
sstunt_t2_prev_j

save(sstunt_t1_n_j, sstunt_t2_n_j, sstunt_t1_prev_j, sstunt_t2_prev_j, 
     file=paste0(res.dir,"sstunt_prev.RData"))

