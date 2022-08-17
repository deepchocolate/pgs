# Calculate the first principal component of a set of P-value thresholded polygenic scores (PGS).
# @param data.frame dta The data containing the PGS.
# @param vector thresNames The column names of the PGS.
# @param bool std If TRUE, standardize the component to mean 0 and unit variance.
pcPGS <- function (dta, thresnames, std=T) {
  pc <- princomp(dta[, thresNames])
  sc <- pc$scores[,1]
  if (std) sc <- (sc – mean(sc))/sd(sc);
  return(sc)
}
