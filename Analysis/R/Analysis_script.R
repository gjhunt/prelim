source('update.R')
source('read_data.R')
library('deconv')
library('reshape2')
library('ggplot2')
library('xtable')

this_dir = getwd()

aplot = function(num,plot_type,sel=rep(TRUE,5)){
    mgs = function(affy_batch,marker_probes){
        ips = indexProbes(affy_batch,which='both')

        compars = array(0,c(length(ips),length(marker_probes)))
        rownames(compars) = names(ips)
        
        melted_ips = melt(ips)
        colnames(melted_ips)=c("probe","gene")
        melted_ips$probe = sapply(melted_ips$probe,toString)

        marker_gtables = lapply(marker_probes,function(x){table(melted_ips$gene[which(melted_ips$probe %in%  x)])})
        for(i in 1:length(marker_probes)){
            compars[names(marker_gtables[[i]]),i] = marker_gtables[[i]]
        }
        maxes = apply(compars[rowMeans(compars)>0,],1,which.max)
        marker_genes = lapply(1:length(marker_probes),function(i){names(maxes)[maxes==i]})
        names(marker_genes) = names(marker_probes)
        return(marker_genes)
    }

    n_choose = 1000

    saved_dir = paste(this_dir,"/data/",sep="")
    saved_dname = paste(num,"_",n_choose,sep="")
    saved_f = paste(saved_dir,saved_dname,sep="")

    if(!file.exists(saved_f)){

        updt("Generating data set.",init=TRUE)
        d = get_dset(num)
        tmp = lapply(d$pure_samples,function(x){sample(x,length(x)/2)})
        names(tmp)=names(d$pure_samples)
        d$pure_samples=tmp
        updt()

        updt("Generating marker probes.\n")
        mps = deconv(d$affy_batch,d$pure_samples,marker_info_only=TRUE)$marker_info
        marker_probes = lapply(mps,function(x){rownames(x[1:n_choose,])})
        marker_genes = mgs(d$affy_batch,marker_probes)
        updt()

        updt("Running my linear deconvolution algorithm.",init=TRUE)
        my_ests_lin= deconv(d$affy_batch,d$pure_samples,marker_probes=marker_probes,model='linear')$estimates
        updt()

        logv = FALSE

        updt("Running DSA.")
        res_dsa=ged(object=d$cellmix,x=MarkerList(marker_genes),method='dsa',log=logv)
        dsa_ests = t(coef(res_dsa))
        updt()

        updt("Running ssKL.")
        res_sskl=ged(object=d$cellmix,x=MarkerList(marker_genes),method='sskl',log=logv)
        sskl_ests = t(coef(res_sskl))
        updt()

        updt("Running ssF.")
        res_ssf=ged(object=d$cellmix,x=MarkerList(marker_genes),method='ssfrobenius',log=logv)
        ssf_ests = t(coef(res_ssf))
        updt()

        updt("Running lsfit.")
        res_lsfit = ged(object=d$cellmix,basis(d$cellmix)[unlist(marker_genes),],method='lsfit')
        lsfit_ests = t(coef(res_lsfit))
        updt()

        updt("Running qprog.\n")
        res_qprog = ged(object=d$cellmix,x=basis(d$cellmix)[unlist(marker_genes),],method='qprog')
        qprog_ests = t(coef(res_qprog))
        updt()

        res = list("my_ests_lin"=my_ests_lin,
                   "dsa"=dsa_ests,
                   "lsfit"=lsfit_ests,
                   "qprog"=qprog_ests,
                   "sskl"=sskl_ests,
                   "ssf"=ssf_ests,
                   "true"=d$conv,
                   "pure_samples"=d$pure_samples)
        
        saveRDS(res,saved_f)
    } else {
        res = readRDS(saved_f)
    }

    #sel = c(input$ours_linear,input$dsa,input$lsfit,input$qprog,input$sskl,input$ssf)
    sel=c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE)

    df = data.frame(type=melt(res$true)[,2],
                    true=melt(res$true)$value,
                    my_ests_lin=melt(res$my_ests_lin)$value,
                    dsa=melt(res$dsa)$value,
                    lsfit=melt(res$lsfit)$value,
                    qprog=melt(res$qprog)$value,
                    sskl=melt(res$sskl)$value,
                    ssf=melt(res$ssf)$value
                    )

    data_sel = 1:dim(df)[1]

    K = length(res$pure_samples)
    ps = unlist(res$pure_samples)
    ps_map = melt(data.frame(t(sapply(1:dim(res$true)[1],function(x){rep(x,K)}))))[,2]
    ps_rows = which(ps_map%in%ps)
    data_sel = data_sel[-ps_rows]

    df = df[data_sel,]

    results=list()
    results$df = df
    results$sel = sel

    ## diag plot
    if(plot_type=='diag'){
        algo_types = names(df)[-(1:2)]
        algo_names = c("Our Algorithm","DSA","LSFIT","QPROG","ssKL","ssFrobenius")
        algo_colors = 1:length(algo_names)

        algo_types = algo_types[sel]
        algo_names = algo_names[sel]
        algo_colors = algo_colors[sel]

        rep_true = rep(df$true,length(algo_types))

        plot_df=melt(df[,algo_types])
        plot_df$true = rep_true
        if(length(algo_types)==1){
            plot_df$variable=rep(algo_types[1],dim(plot_df)[1])
        }

        ggplot = qplot(data=df,x=true,y=my_ests_lin,col=I('black'),size=I(2.5),shape=I(1),alpha=I(0)) +
            ggtitle("Estimated proportions by true proportions") +
            labs(x="True Proportions",y="Estimated Proportions")
        ggplot = ggplot + geom_abline(slope=1,intercept=0,color='orange',size=I(1))
        ggplot = ggplot + theme(axis.text=element_text(size=10),
                                axis.title=element_text(size=10,face="bold"),
                                plot.title=element_text(size=10,face="bold"),
                                legend.title=element_text(size=10),
                                legend.position="bottom")        
        ggplot = ggplot +
            geom_point(aes(x=true,y=value,col=variable),data=plot_df,size=I(2.5),shape=I(1))
        ggplot = ggplot + labs(color="Algorithm")+
            scale_color_manual(labels = algo_names,values=algo_colors)
        ggplot = ggplot + xlim(0,1)
        ggplot = ggplot + ylim(0,1)
        return(ggplot)
    }
    
    # error plots
    if(plot_type=='err_boxplot'){
        abst = FALSE
        transform = function(x){
            if(abst){
                return(abs(x))
            } else {
                return(x)
            }
        }

        yl=ylim(-.6,.6)
        if(abst) yl=ylim(0,.6)

        df = results$df

        errdf = data.frame("Our Algorithm" = transform(df$my_ests_lin- df$true),check.names=FALSE)
        errdf["DSA"] = transform(df$dsa - df$true)
        errdf["Least Squares"] = transform(df$lsfit - df$true)
        errdf["Quad. Prog."] = transform(df$qprog - df$true)
        errdf["ssKL"] = transform(df$sskl - df$true)
        errdf["ssFrobenius"] = transform(df$ssf - df$true)

        p = ggplot(stack(errdf), aes(x = ind, y = values)) +
            geom_boxplot() + yl +
            ggtitle("Error of Estimated Proportions") +
            labs(x="Algorithm",y="Error of Estimated Proportions") +
            theme(axis.text=element_text(size=10),
                  axis.title=element_text(size=10,face="bold"),
                  plot.title=element_text(size=10,face="bold"),
                  legend.title=element_text(size=10),
                  legend.position="bottom")
        
        return(p)
    }

    # summary
    if(plot_type=='summ'){

        abst = TRUE
        transform = function(x){
            if(abst){
                return(abs(x))
            } else {
                return(x)
            }
        }

        
        df = results$df

        errdf = data.frame("Our Algorithm" = transform(df$my_ests_lin- df$true),check.names=FALSE)
        errdf["DSA"] = transform(df$dsa - df$true)
        errdf["Least Squares"] = transform(df$lsfit - df$true)
        errdf["Quad. Prog."] = transform(df$qprog - df$true)
        errdf["ssKL"] = transform(df$sskl - df$true)
        errdf["ssFrobenius"] = transform(df$ssf - df$true)

        qs = c(0,.25,.5,.75,1)
        tbl = round(apply(errdf,2,function(x){quantile(x,)}),3)
        colnames(tbl)[1] = "Our Algorithm"
        tbl = cbind(paste(round(qs*100),"%",sep=""),tbl)
        colnames(tbl)[1] = "Percentile"
        rownames(tbl) = NULL
        
        return(tbl)
    }
}
