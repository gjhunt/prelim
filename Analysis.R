## ----plot1,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=5,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(19830,'diag',sel)

## ----plot2,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=5,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(19830,'err_boxplot',sel)

## ----table1,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,results='asis'----
library('xtable')
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
t = aplot(19830,'summ',sel)
print(xtable(t),include.rownames=FALSE)

## ----plot3,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=5,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(11058,'diag',sel)

## ----plot4,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=5,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(11058,'err_boxplot',sel)

## ----table2,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,results='asis'----
library('xtable')
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
t = aplot(11058,'summ',sel)
print(xtable(t),include.rownames=FALSE)

