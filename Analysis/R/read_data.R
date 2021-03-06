suppressPackageStartupMessages({
    require('affy')
    require('CellMix')
})

geo_dl = list('GSE5350'='ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE5nnn/GSE5350/suppl/GSE5350_MAQC_AFX_123456_120CELs.zip',
              'GSE19830'='ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE19nnn/GSE19830/suppl/GSE19830_RAW.tar',
              'GSE33076'='ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE33nnn/GSE33076/suppl/GSE33076_RAW.tar',
              'GSE29832'='ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE29nnn/GSE29832/suppl/GSE29832_RAW.tar',
              'GSE11058'='ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE11nnn/GSE11058/suppl/GSE11058_RAW.tar'
              )

unpack = function(str){
    s = strsplit(str,"\\.")
    end = tolower(rev(s[[1]])[1])
    if(end=='tar'){
        return('tar xvf')
    } else if(end=='gz'){
        return('tar xvzf')
    } else if(end=='zip'){
        return('unzip')
    }
}

this_dir = getwd()

get_dset = function(geo_acc_num){
    geo_acc = paste("GSE",geo_acc_num,sep="")

    curr_dir = getwd()
    geo_data_dir = './data'
    this_data_dir = paste(geo_data_dir,"/",geo_acc,sep="")

    if(!dir.exists(this_data_dir)){
        dir.create(this_data_dir)
        setwd(this_data_dir)
        dl = geo_dl[[geo_acc]]
        system(paste('wget', dl))
        system(paste(unpack(dl)," * "))
        setwd(curr_dir)
    }

    affy_batch = ReadAffy(celfile.path=this_data_dir)
    cmData = ExpressionMix(geo_acc)

    conv = t(coef(cmData))
    colnames(conv) = tolower(colnames(conv))

    get_pure = function(cm_coef){
        ones = apply(cm_coef,1,function(x){which(x==1)[1]})
        pure = ones[!is.na(ones)]
        return(lapply(1:length(unique(pure)),function(x){which(pure==x)}))
    }

    pure_samples = get_pure(conv)
    names(pure_samples) = colnames(conv)
    
    return(list("affy_batch"=affy_batch,"pure_samples"=pure_samples,"conv"=conv,"cellmix"=cmData))
}


