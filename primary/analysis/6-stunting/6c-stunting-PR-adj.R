##############################################
# WASH Benefits Kenya
# Primary outcome analysis 

# stunted adjusted analysis
# calculate adjusted differences
# between treatment arms for H1 and H3

# input: washb-kenya-midline-anthro-public.csv,
# washb-kenya-endline-anthro-public.csv
# output: stunt_pr_adj.RData, stunt_rd_adj.RData

# by Jade Benjamin-Chung (jadebc@berkeley.edu)
##############################################
library(devtools)
library(washb)

rm(list=ls())

# define directories
source.dir="~/documents/crg/wash-benefits/kenya/src/primary/analysis/"
data.dir="~/Dropbox/WASHB-Kenya-Data/1-primary-outcome-datasets/Public/"
res.dir="~/Dropbox/WBK-primary-analysis/results/jade/"

m=read.csv(paste0(data.dir,"washb-kenya-midline-anthro-public.csv"))
e=read.csv(paste0(data.dir,"washb-kenya-endline-anthro-public.csv"))

source(paste0(source.dir,"0-base-programs.R"))

m=preprocess.anthro(m, y="stunted")
e=preprocess.anthro(e, y="stunted")

m=preprocess.adj(m,y="stunted",time=1)
e=preprocess.adj(e,y="stunted",time=2)

W=c("month","HHS","aged","sex","mother_age","motherht","mother_edu",
    "u18","Ncomp","water_time","floor","roof","cow",
    "goat","chicken","dog","elec","radio","tv","mobilephone",
    "clock","bicycle","motorcycle","stove","staffid")

mW=m[,c("stunted","block","tr","clusterid",W)]
mW$block=as.factor(mW$block)

eW=e[,c("stunted","block","tr","clusterid",W)]
eW$block=as.factor(eW$block)

######################################################
# H1: Adjusted prevalence ratios; each arm vs. control
######################################################

#---------------------------------------------
# Midline
#---------------------------------------------
trlist=c("Passive Control","Water","Sanitation","Handwashing",
         "WSH","Nutrition","Nutrition + WSH")

SL.library=c("SL.mean","SL.glm","SL.bayesglm","SL.gam","SL.glmnet")

est.h1.t1=apply(matrix(trlist), 1,function(x) washb_tmle(Y=mW$stunted,tr=mW$tr,
    pair=mW$block, id=mW$block,W=mW[,W],
    family="binomial",contrast=c("Control",x),Q.SL.library=SL.library,
    g.SL.library=SL.library, pval=0.2, seed=67890, print=TRUE))
  
stunt_t1_h1_pr_adj_j=format.tmle(est.h1.t1,family="binomial")$rr
stunt_t1_h1_rd_adj_j=format.tmle(est.h1.t1,family="binomial")$rd

rownames(stunt_t1_h1_pr_adj_j)=c("Passive Control vs. C", "Water vs. C",
                             "Sanitation vs. C", "Handwashing vs. C", "WSH vs. C",
                             "Nutrition vs. C", "Nutrition + WSH vs. C")
rownames(stunt_t1_h1_rd_adj_j)=c("Passive Control vs. C", "Water vs. C",
                             "Sanitation vs. C", "Handwashing vs. C", "WSH vs. C",
                             "Nutrition vs. C", "Nutrition + WSH vs. C")

#---------------------------------------------
# Endline
#---------------------------------------------
est.h1.t2=apply(matrix(trlist), 1,function(x) washb_tmle(Y=eW$stunted,tr=eW$tr,
    pair=eW$block, id=eW$block,W=eW[,W],
    family="binomial",contrast=c("Control",x),Q.SL.library=SL.library,
    g.SL.library=SL.library, pval=0.2, seed=67890, print=TRUE))
  
stunt_t2_h1_pr_adj_j=format.tmle(est.h1.t2,family="binomial")$rr
stunt_t2_h1_rd_adj_j=format.tmle(est.h1.t2,family="binomial")$rd

rownames(stunt_t2_h1_pr_adj_j)=c("Passive Control vs. C", "Water vs. C",
                             "Sanitation vs. C", "Handwashing vs. C", "WSH vs. C",
                             "Nutrition vs. C", "Nutrition + WSH vs. C")
rownames(stunt_t2_h1_rd_adj_j)=c("Passive Control vs. C", "Water vs. C",
                             "Sanitation vs. C", "Handwashing vs. C", "WSH vs. C",
                             "Nutrition vs. C", "Nutrition + WSH vs. C")

######################################################
# H3: Adjusted prevalence ratios / differences;
# WSHN vs. N and WSHN vs. WSH 
######################################################
# Midline
trlist=c("Nutrition","WSH")

est.h3.t1=apply(matrix(trlist), 1,function(x) washb_tmle(Y=mW$stunted,tr=mW$tr,
    pair=mW$block, id=mW$block,W=mW[,W],
    family="binomial",contrast=c(x,"Nutrition + WSH"),Q.SL.library=SL.library,
    g.SL.library=SL.library, pval=0.2, seed=67890, print=TRUE))
  
stunt_t1_h3_pr_adj_j=format.tmle(est.h3.t1,family="binomial")$rr
stunt_t1_h3_rd_adj_j=format.tmle(est.h3.t1,family="binomial")$rd

rownames(stunt_t1_h3_pr_adj_j)=c("Nutrition + WSH vs. Nutrition",
                              "Nutrition + WSH vs. WSH")
rownames(stunt_t1_h3_rd_adj_j)=c("Nutrition + WSH vs. Nutrition",
                              "Nutrition + WSH vs. WSH")
# Endline
est.h3.t2=apply(matrix(trlist), 1,function(x) washb_tmle(Y=eW$stunted,tr=eW$tr,
    pair=eW$block, id=eW$block,W=eW[,W],
    family="binomial",contrast=c(x,"Nutrition + WSH"),Q.SL.library=SL.library,
    g.SL.library=SL.library, pval=0.2, seed=67890, print=TRUE))
  
stunt_t2_h3_pr_adj_j=format.tmle(est.h3.t2,family="binomial")$rr
stunt_t2_h3_rd_adj_j=format.tmle(est.h3.t2,family="binomial")$rd

rownames(stunt_t2_h3_pr_adj_j)=c("Nutrition + WSH vs. Nutrition",
                              "Nutrition + WSH vs. WSH")
rownames(stunt_t2_h3_rd_adj_j)=c("Nutrition + WSH vs. Nutrition",
                              "Nutrition + WSH vs. WSH")

######################################################
# Save results
######################################################
save(stunt_t1_h1_pr_adj_j,stunt_t1_h3_pr_adj_j,
     stunt_t2_h1_pr_adj_j,stunt_t2_h3_pr_adj_j,
  stunt_t1_h1_rd_adj_j,stunt_t1_h3_rd_adj_j,
  stunt_t2_h1_rd_adj_j,stunt_t2_h3_rd_adj_j,
  file=paste0(res.dir,"stunted-PR-adj.RData"))


