## Create the function to visualize distance
"coldiss" <- function(D, nc = 4, byrank = TRUE, diag = FALSE)
{
  require(gclus)
  if (max(D)>1) D <- D/max(D)
  if (byrank) {
    spe.color <- dmat.color(1-D, cm.colors(nc))
  }
  else {
    spe.color <- dmat.color(1-D, byrank=FALSE, cm.colors(nc))
  }
  spe.o <- order.single(1-D)
  speo.color <- spe.color[spe.o, spe.o]
  op <- par(pty="s")
  if (diag) {
    plotcolors(spe.color, rlabels=attributes(D)$Labels,
               main="Dissimilarity Matrix",
               dlabels=attributes(D)$Labels)
  }
  else {
    plotcolors(spe.color, rlabels=attributes(D)$Labels,
               main="Dissimilarity Matrix")
  }
  par(op)
}
