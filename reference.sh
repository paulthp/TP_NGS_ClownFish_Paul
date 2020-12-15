# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data

mkdir -p data_reference

#telecharger donner de ref
wget -O data_reference/spartitus_coding.fa.gz http://ftp.ensembl.org/pub/release-102/fasta/stegastes_partitus/cds/Stegastes_partitus.Stegastes_partitus-1.0.2.cds.all.fa.gz

#launch script with      nohup ./reference.sh >& nohup.reference &