library('affy')

data_top_dir = './latin_data/'
affy_batch = ReadAffy(celfile.path=data_top_dir)

## probe-level data
pips = indexProbes(affy_batch,"pm")
mips = indexProbes(affy_batch,"mm")
d = t(intensity(affy_batch))

# order according to experiment number
ord = order(sapply(rownames(d),function(x){as.integer(substr(strsplit(x,"_")[[1]][8],5,10))}))
d = d[ord,]

# determine gene spike-in titrations
anno = read.csv('anno.csv',stringsAsFactors=FALSE)
genes = sapply(anno[1,2:15],function(x){strsplit(x,"\n",fixed=TRUE)})
titration = as.matrix(anno[2:15,2:15])
titration = apply(titration,c(1,2),as.numeric)

# rows are spiked-in genes, columns are experiment
all_titration = array(0,c(dim(titration)[1]*3,dim(titration)[2]))
for(i in 1:dim(all_titration)[1]){
    all_titration[i,] = titration[ceiling(i/3),]
}
all_titration_order = apply(all_titration,2,order)

# gene-level data
dg = data.frame(rma(affy_batch,verbose=FALSE,
                    normalize=TRUE,background=FALSE))
dg = dg[ord,]




