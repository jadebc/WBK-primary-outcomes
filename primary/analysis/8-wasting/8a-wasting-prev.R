##############################################
# WASH Benefits Kenya
# Primary outcome analysis 

# Wasting
# n, N, prevalence, and 95% CI by arm at
# baseline and follow-up

# input: washb-kenya-midline-anthro-public.csv,
# washb-kenya-endline-anthro-public.csv
# output: wast_prev.RData

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

m=preprocess.anthro(m, "wasted")
e=preprocess.anthro(e, "wasted")

#----------------------------------------------
# n and N by arm and follow-up time point
#----------------------------------------------
N.1=table(m$tr[!is.na(m$wasted)])
n.1=table(m$wasted,m$tr)[2,]

wast_t1_n_j=data.frame(cbind(N.1=N.1,n.1=n.1))

N.2=table(e$tr[!is.na(e$wasted)])
n.2=table(e$wasted,e$tr)[2,]

wast_t2_n_j=data.frame(cbind(N.2=N.2,n.2=n.2))

names(N.1)=NULL
names(N.2)=NULL

#----------------------------------------------
# prevalence by arm and time point
#----------------------------------------------
wast_t1_prev_j=t(sapply(levels(m$tr), function(x) washb_mean(
  Y=m$wasted[m$tr==x],id=m$clusterid[m$tr==x],print=FALSE)))

wast_t2_prev_j=t(sapply(levels(e$tr), function(x) washb_mean(
  Y=e$wasted[e$tr==x],id=e$clusterid[e$tr==x],print=FALSE)))

colnames(wast_t1_prev_j)=c("N","Prev","SD","Robust SE","lb","ub")
colnames(wast_t2_prev_j)=c("N","Prev","SD","Robust SE","lb","ub")

# drop columns that aren't needed
wast_t1_prev_j=wast_t1_prev_j[,c("Prev","lb","ub")]
wast_t2_prev_j=wast_t2_prev_j[,c("Prev","lb","ub")]

wast_t1_n_j
wast_t2_n_j

wast_t1_prev_j
wast_t2_prev_j

save(wast_t1_n_j, wast_t2_n_j, wast_t1_prev_j, wast_t2_prev_j, 
     file=paste0(res.dir,"wast_prev.RData"))

