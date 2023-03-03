source('analysis/regcompact.R')
# Load your data as you wish
dta <- read.csv('/your/file')
# Phenotypes to analyze and a description of them can be
# stored like this.
phenotypes <- list('pheno1'="Short discription of pheno1", 
                   'pheno2'="Eg NPR diagnosis")
pgses <- c('pgs1', 'pgs2')
# Define covariates of the model
pcs <- paste0('PrincipalComponent', 1:10)
covs <- paste0('SEX', paste0(pcs, collapse='+'))
# List of phenotypes that should be analysed with logistic regression
binaries <- c('am')

results <- NULL
for (pheno in names(phenotypes)) {
  for (pgs in pgses) {
    res <- regCompact(phenotype=pheno, exposure=pgs, covariates=covs, binary=(pheno %in% binaries), dta=dta)
    # Store the phenotpe description in the results table
    res$description <- phenotypes[[pheno]]
    results <- rbind(results, res)
  }
}
write.csv(results, '/your/result.csv', row.names=F)