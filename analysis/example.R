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
covs <- paste0('SEX', pcs, collapse='+')
# List of phenotypes that should be analysed with logistic regression
binaries <- c('am')

# Test data in R (will give some warnings)
#data(mtcars)
#dta <- mtcars
#phenotypes <- list('mpg'="Short discription of pheno1", 
#                   'am'="Eg NPR diagnosis")
#pgses <- c('hp', 'wt')
#binaries <- c('am')
#covs <- "gear+carb"
# Using the testdata should produce some output looking like this
# phenotype expoure         beta       stderr           z           p           l95           u95 l95r u95r          r2   family  n pheno_na exp_na                 description
# 1        am      wt -111.4446618 8.587730e+04 -0.00129772 0.998964570 -1.684279e+05  1.682050e+05           0.184190949 binomial 32        0      0            Eg NPR diagnosis
# 2        am      hp   -0.4654768 2.911994e+00 -0.15984815 0.873000692 -6.172879e+00  5.241926e+00           0.000429252 binomial 32        0      0            Eg NPR diagnosis
# 3       mpg      wt   -0.5371701 1.509612e-01 -3.55833115 0.001354124 -8.330486e-01 -2.412915e-01           0.288551676 gaussian 32        0      0 Short discription of pheno1
# 4       mpg      hp   -0.4292733 1.521142e-01 -2.82204633 0.008680861 -7.274116e-01 -1.311350e-01           0.184275543 gaussian 32        0      0 Short discription of pheno1

results <- NULL
for (pheno in names(phenotypes)) {
  for (pgs in pgses) {
    res <- regCompact(phenotype=pheno, exposure=pgs, covariates=covs, binary=(pheno %in% binaries), dta=dta)
    # Store the phenotpe description in the results table
    res$description <- phenotypes[[pheno]]
    results <- rbind(res, results)
  }
}
write.csv(results, '/your/result.csv', row.names=F)