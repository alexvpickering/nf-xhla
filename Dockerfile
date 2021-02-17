FROM humanlongevity/hla:0.0.0

# xHLA requires hg38 without alt contigs
# to do so Homo_sapiens_assembly38.fasta.64.alt isn't downloaded 
RUN mkdir ~/hg38 && cd ~/hg38 \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa \
    && wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai

# bwa-mem2 is faster
RUN sudo apt-get update && sudo apt-get install curl -y
RUN curl -L https://github.com/bwa-mem2/bwa-mem2/releases/download/v2.0pre2/bwa-mem2-2.0pre2_x64-linux.tar.bz2 \
  | tar jxf - 


RUN mv bwa-mem2-2.0pre2_x64-linux/* /usr/bin \
  && rm -rf bwa-*

ENTRYPOINT []