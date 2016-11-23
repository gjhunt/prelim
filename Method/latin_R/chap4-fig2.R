source('./latin_R/latin_data_read.R',chdir=TRUE,local=TRUE)
source('./latin_R/latin_data_plot.R',chdir=TRUE,local=TRUE)
library('ggplot2')

group = 1
gene = 1
probe = 11

fit = fitd(group,gene,probe,pips)
data = data.frame(fit$dat)

p = ggplot(data,aes(x=vlog2t,y=vlog2d))+geom_point()
p = p + labs(title=expression("log2(Intensity) v. log2(Concentration)"))
p = p + labs(x="log2(Concentration)",y="Log2(Intensity)")
p = p + xlim(-15,15) + ylim(5,15)
sig=function(x){sapply(x,function(b){sigmoid(b,fit$theta)})}
p = p + stat_function(fun=sig,color='red')
plot(p)
