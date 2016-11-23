library(crayon)

sze = function(unit='Mb',envir=globalenv()){
    os = function(x){object.size(get(x))}
    os_pretty = function(x){format(object.size(get(x)),units=unit)}
    ord = order(sapply(ls(envir),os),decreasing=TRUE)
    print(sapply(ls(envir),os_pretty)[ord])
    cat("Total: ",sum(sapply(ls(envir),os)) * 1E-9,"Gb \n")
}


VERBOSE = TRUE
TIME = Sys.time()
updt = function(msg=NULL,init=FALSE,done=FALSE){
    if(is.null(msg)) done=TRUE
    if(VERBOSE){
        if(!done){
            last_msg <<- msg
        } else {
            msg <- paste(last_msg,green("[DONE]"))
        }
        t2 = Sys.time()
        if(init){
            TIME<<-t2
            FIRST<<-t2
        }
        MSG = paste(msg," (",format(t2-FIRST,digits=1)," ellapsed)",sep="")
        TIME <<- t2
        cat(paste(blue(paste("[",t2,"] ",sep="")),MSG,sep=""),"\n")
        return(MSG)
    }
    return("")
}

