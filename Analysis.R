## ----table1,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,results='asis'----
library('xtable')
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
t = aplot(19830,'summ',sel)
print(xtable(t,caption="Quantiles of the absolute error of mixing proportions.",
             label="tab:rat1"
             ),include.rownames=FALSE)

## ----plot2,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=4,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(19830,'err_boxplot',sel)

## ----plot1,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=5,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(19830,'diag',sel)

## ----table2,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,results='asis'----
library('xtable')
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
t = aplot(11058,'summ',sel)
print(xtable(t,label="tab:blood",caption="Quantiles of the absolute error of mixing proportions."),include.rownames=FALSE)

## ----plot4,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=4,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(11058,'err_boxplot',sel)

## ----plot3,cache=FALSE,warning=FALSE,echo=FALSE,error=FALSE,message=FALSE,fig.height=5,fig.width=7----
source('./R/Analysis_script.R',chdir=TRUE)
sel = sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)
aplot(11058,'diag',sel)

