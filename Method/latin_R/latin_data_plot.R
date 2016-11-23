sigmoid = function(x,t){return(t[1]+t[2]/(1+exp(-(t[3]+t[4]*x))))}
sigmoid_inv = function(x,t){return((-1/t[4])*(log((t[2]/(x-t[1]))-1)+t[3]))}

F = function(x,y){
    return(x-y)
}

fitd=function(group,gene,probe,ips){

    probe_groups = ips[unlist(lapply(genes[group],'[',gene))]
    probes = unlist(lapply(probe_groups,'[',probe))
    od = d[,probes]

    vlog2d = as.vector(t(log2(od)))
    if(!is.null(dim(od))){
        vlog2t = rep(log2(all_titration[,group]+.0001),dim(od)[2])
    } else {
        vlog2t = log2(all_titration[,group]+.0001)
    }
    vlog2t = vlog2t + runif(length(vlog2t),0,1/1000)

    fail = TRUE
    i=0
    max_try = 10
    t = c(6.3657341,  6.6679978, -3.0497695,  0.6106055)

    while(fail){
        i = i + 1
        if(i > max_try){
            fail=2
            break;
        }

        fail = tryCatch({
            if(i!=1){
                t = t + rnorm(length(t),0,1)
            }
            init = list(t1=t[1],t2=t[2],t3=t[3],t4=t[4])
            mod = nls(vlog2d~sigmoid(vlog2t,c(t1,t2,t3,t4)),
                      start=init,
                      control=list('warnOnly'=FALSE,'maxiter'=1000,'minFactor'=1E-12))
            fail = FALSE
        }, error = function(e){
            return(TRUE)
        })
    }

    if(fail<2){
        t1=coef(mod)[1];t2=coef(mod)[2];t3=coef(mod)[3];t4=coef(mod)[4]
        sigmoid = function(x){return(t1+t2/(1+exp(-(t3+t4*x))))}
        return(list(dat=cbind(vlog2t,vlog2d),fail=FALSE,theta=c(t1,t2,t3,t4)))
    }
    
    return(list(dat=cbind(vlog2t,vlog2d),fail=TRUE,theta=rep(0,4)))
}
