# Standardize a variable to mean 0 and variance 1
#' @param x A numeric vector.
stdVar <- function (x) {
  (x - mean(x, na.rm=T))/sd(x, na.rm=T)
}

# Run a regresion phenotype~exposure + covariate 1 + covariate 2 and extract
# parameters in a tabular format.
# For binary=F, both phenotype and exposure will be standardized to mean 0 and
# unit variance. For binary=T, exposure will be standardized.
# For clustered data (eg samples from families) the clustering argument can be
# used to calculate cluster robust confidence intervals (see sandhiwch::vcovCL)
#' @param phenotype Variable to analyze.
#' @param expoure Exposure variable
#' @param covariates Variables to adjust the exposure for, eg "COV1 + COV2"
#' @param binary Pass TRUE to runa binomial/logistic model.
#' @param dta A data.frame containing all necessary variables
#' @param clustering Pass the name of the clustering variable in dta to add cluster robust confidence intervals.
#' @param A data.frame with results.
regCompact <- function (phenotype, exposure, covariates, binary, dta, clustering=F) {
  frm <-  as.formula(paste0(phenotype, '~', exposure, '+', covariates))
  fam <- ifelse(binary == T, 'binomial', 'gaussian')
  dta[, exposure] <- stdVar(dta[, exposure])
  if (binary == F) dta[, phenotype] <- stdVar(dta[, phenotype])
  m <- glm(frm, data=dta, family=fam)
  cfs <- coef(summary(m))[exposure, ]
  # Calculate incremental R2
  if (binary == F) {
    R2 <- cfs[1]^2
  } else {
    require(fmsb)
    m2 <- update(m, as.formula(paste0('. ~ . -', exposure)))
    R2 <- NagelkerkeR2(m)$R2 - NagelkerkeR2(m2)$R2
  }
  confin <- confint.default(m)[exposure, ] # Use asymptotic std errs
  out <- data.frame(
    phenotype=phenotype,
    expoure=exposure,
    beta=cfs[1], stderr=cfs[2], z=cfs[3], p=cfs[4], # Beta, SE, Z, P
    l95=confin[1], u95=confin[2], # Asymptotic CI
    l95r='', u95r='', # Cluster-robust CI if applicable
    r2=R2,
    family=fam,
    n=nrow(dta),
    pheno_na=sum(is.na(dta[, phenotype])), # NAs in phenotype
    exp_na=sum(is.na(dta[, exposure])), # NAs in exposure
    stringsAsFactors = F)
  if (is.character(clustering)) {
    require(sandwhich)
    vcm <- vcovCL(m, cluster=dta[, clustering])
    robErr <- qt(0.975, df=m$df.residual)*sqrt(vcm[exposure, exposure])
    out$u95r <- coef(m)[exposure] + robErr
    out$l95r <- coef(m)[exposure] - robErr
  }
  rownames(out) <- NULL
  return(out)
}
