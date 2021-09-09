library(vegan)       # decostand is a vegan function

# hellinger transformation: important ecological transformation! READ!!
# d.m  = mode(d)  <- the mode will be the top of the normal distribution graph (the mean of the normal distribution)
# d.max .....     <- decides which PCR is the furthest away from the center (3 PCR's => the center of these 3 values is calculated, and then the furthest away should be eliminated)


#' @export
mode <- function(x) {
  d <- density(x)
  d$x[which.max(d$y)]
}

#' @export
tag_bad_pcr = function(samples,counts,plot = TRUE) {
  counts = decostand(counts,method = "hellinger")
  
  bc = aggregate(counts,
                 by=list(factor(as.character(samples))),
                 mean)
  bc.name = as.character(bc[,1])
  bc = bc[-1]
  rownames(bc)=bc.name
  bc = bc[as.character(samples),]
  
  d = sqrt(rowSums((counts - bc)^2))
  names(d) = as.character(samples)
  
  d.m  = mode(d)
  d.sd = sqrt(sum((d[d <= d.m] - d.m)^2)/sum(d <= d.m))
  
  d.max = aggregate(d,
                    by = list(factor(as.character(samples))),
                    max)
  
  d.max.names = d.max[,1]
  d.max = d.max[,2]
  names(d.max) = d.max.names
  d.max = d.max[as.character(samples)]
  
  d.len = aggregate(d,
                    by = list(factor(as.character(samples))),
                    length)
  
  d.len.names = d.len[,1]
  d.len = d.len[,2]
  names(d.len) = d.len.names
  d.len = d.len[as.character(samples)]
  
  keep = ((d < d.m + (d.sd*2)) | d!=d.max) & d.len > 1
  
  selection = data.frame(samples = as.character(samples),
                         distance= d,
                         maximum = d.max,
                         repeats = d.len,
                         keep    = keep,
                         stringsAsFactors = FALSE)
  
  rownames(selection)=rownames(counts)
  attributes(selection)$dist.mode = d.m
  attributes(selection)$dist.sd = d.sd
  
  if (plot) {
    hist(d, breaks = 20)
    abline(v=d.m,lty=2,col="green")
    abline(v=d.m + (d.sd*2),lty=2,col="red")
  }
  
  return(selection)
}

