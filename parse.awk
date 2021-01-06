#Warning : there is a problem in this script. It interchanges the common names and the ensembl ID of the genes.  

BEGIN {
    FS=OFS="\t"
    gene = "gene"
    gene_name = "gene_symbol"
}
{
    n = split($0,f," ")
    delete n2v
    for (i=1; i<=n; i+=1) {
        nchp  = split(f[i],chp,":")
        name  = chp[1]
        value = chp[2]
        n2v[name] = value
    }
    new = ""
    for (i=1; i<=n; i+=1) {
        nchp  = split(f[i],chp,":")
        if(chp[1] == gene){
                id = chp[2]
        }
        if(chp[1] == gene_name){
                symb = chp[2]
        }
    }
    if(n>1){
        if(symb == ""){
        $0 = ">" id
        }else{
        $0 = ">" id "|" symb
        }
    }
    print
}