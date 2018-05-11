###################################################
# Project: HS Panel
# Author: Harry Smith
# Synopsis: The purpose of this script is to generate
# File lists BY brain region of the HS gtfs from
# stringtie for use in the stringtie merge step
####################################################


## set up workspace
rm(list=ls())
options(stringsAsFactors = FALSE)

dirs <- "/Volumes/smiharry/Saba_Lab/RNA-Seq/HS/stringtie/fileLists/"

## Read in lists
batch1 <- read.table(file = paste(dirs, "file.list.2106-04-05.txt", sep = ""), header = FALSE, sep = "\t")
batch2 <- read.table(file = paste(dirs, "file.list.2106-10-10.txt", sep = ""), header = FALSE, sep = "\t")
batch345 <- read.table(file = paste(dirs, "filelist.batch_3_4_5.txt", sep = ""), header = FALSE, sep = "\t")

## only keep files ending in .gtf
b1.tmp <- batch1$V1[endsWith(batch1$V1, ".gtf")]
b2.tmp <- batch2$V1[endsWith(batch2$V1, ".gtf")]
b345.tmp <- batch345$V1[endsWith(batch345$V1, ".gtf")]
b.list <- list("b1" = b1.tmp, "b2" = b2.tmp, "b345" = b345.tmp)

## Get unique brain regions in each batch
b1.br <- unique(unlist(lapply(strsplit(b1.tmp[-length(b1.tmp)], split = "_", fixed = TRUE), FUN = function(x) x[2])))
b2.br <- unique(unlist(lapply(strsplit(b2.tmp[-length(b2.tmp)], split = "_", fixed = TRUE), FUN = function(x) x[2])))
b345.br <- unique(unlist(lapply(strsplit(b345.tmp[-length(b345.tmp)], split = "[_.]+", fixed = FALSE), FUN = function(x) x[2])))

## Create brain region specific file lists
b.out <- list()
for(j in names(b.list)){
  b.out.tmp <- list()
  for(i in 1:5) {
    b.out.tmp[[i]] <- b.list[[j]][grepl(b1.br[i], b.list[[j]])]
  }
  b.out[[j]] <- b.out.tmp
}

brcat <- list()
for(i in 1:5) {
  h1 <- b.out[[1]][[i]]
  h2 <- b.out[[2]][[i]]
  h3 <- b.out[[3]][[i]]
  hcat <- c(h1, h2, h3)
  brcat[[b1.br[i]]] <- hcat
}

## check number of files in each list
lapply(brcat, FUN = function(x) {length(x)})

## write file lists
for(i in 1:5) {
  write.table(brcat[[i]], file = paste(dirs, names(brcat)[i], "List.txt", sep = ""), row.names = FALSE, col.names = FALSE, quote = FALSE)
}
















