## ----abstract-child, child='Abstract/Abstract.Rnw'-----------------------



## ----intro-child, child='Intro/Intro.Rnw'--------------------------------



## ----science-child, child='ScientificBackground/Science.Rnw'-------------



## ----lit-child, child='Literature/Lit.Rnw'-------------------------------



## ----lit-child, child='Method/Method.Rnw'--------------------------------

## ----chap4-fig1,eval=TRUE,cache=TRUE,echo=FALSE,warning=FALSE,fig.height=5,fig.width=5----
source('./latin_R/chap4-fig1.R')

## ----chap4-fig2,eval=TRUE,cache=TRUE,echo=FALSE,warning=FALSE,fig.height=5,fig.width=5----
source('./latin_R/chap4-fig2.R')

## ----chap4-fig3,eval=TRUE,cache=TRUE,echo=FALSE,warning=FALSE,fig.height=5,fig.width=5----
source('./latin_R/chap4-fig3.R')


## ----lit-child, child='Analysis/Analysis.Rnw'----------------------------

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


## ----lit-child, child='Conclusion/Conclusion.Rnw'------------------------



