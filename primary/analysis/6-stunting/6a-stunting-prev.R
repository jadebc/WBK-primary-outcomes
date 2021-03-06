##############################################
# WASH Benefits Kenya
# Primary outcome analysis 

# Stunting 
# n, N, prevalence, and 95% CI by arm at
# baseline and follow-up

# input: washb-kenya-midline-anthro-public.csv,
# washb-kenya-endline-anthro-public.csv
# output: stunt_prev.RData

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

m=preprocess.anthro(m, "stunted")
e=preprocess.anthro(e, "stunted")

#----------------------------------------------
# n and N by arm and follow-up time point
#----------------------------------------------
N.1=table(m$tr[!is.na(m$stunted)])
n.1=table(m$stunted,m$tr)[2,]

stunt_t1_n_j=data.frame(cbind(N.1=N.1,n.1=n.1))

N.2=table(e$tr[!is.na(e$stunted)])
n.2=table(e$stunted,e$tr)[2,]

stunt_t2_n_j=data.frame(cbind(N.2=N.2,n.2=n.2))

names(N.1)=NULL
names(N.2)=NULL

#----------------------------------------------
# prevalence by arm and time point
#----------------------------------------------
stunt_t1_prev_j=t(sapply(levels(m$tr), function(x) washb_mean(
  Y=m$stunted[m$tr==x],id=m$clusterid[m$tr==x],print=FALSE)))

stunt_t2_prev_j=t(sapply(levels(e$tr), function(x) washb_mean(
  Y=e$stunted[e$tr==x],id=e$clusterid[e$tr==x],print=FALSE)))

colnames(stunt_t1_prev_j)=c("N","Prev","SD","Robust SE","lb","ub")
colnames(stunt_t2_prev_j)=c("N","Prev","SD","Robust SE","lb","ub")

# drop columns that aren't needed
stunt_t1_prev_j=stunt_t1_prev_j[,c("Prev","lb","ub")]
stunt_t2_prev_j=stunt_t2_prev_j[,c("Prev","lb","ub")]

stunt_t1_n_j
stunt_t2_n_j

stunt_t1_prev_j
stunt_t2_prev_j

save(stunt_t1_n_j, stunt_t2_n_j, stunt_t1_prev_j, stunt_t2_prev_j, 
     file=paste0(res.dir,"stunt_prev.RData"))

