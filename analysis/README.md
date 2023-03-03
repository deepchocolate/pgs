# Test data in R

Showing some replacements one can make in `example.R` to make it run. This will produce som warnings
as this is a small sample.
```
data(mtcars)
dta <- mtcars
phenotypes <- list('mpg'="Short discription of pheno1", 
                   'am'="Eg NPR diagnosis")
pgses <- c('hp', 'wt')
binaries <- c('am')
covs <- "gear+carb"

results <- NULL
for (pheno in names(phenotypes)) {...}
```
Running regCompact() with the above data should produce some output looking like this

```
 phenotype expoure         beta       stderr           z           p           l95           u95 l95r u95r          r2   family  n pheno_na exp_na                 description
 1        am      wt -111.4446618 8.587730e+04 -0.00129772 0.998964570 -1.684279e+05  1.682050e+05           0.184190949 binomial 32        0      0            Eg NPR diagnosis
 2        am      hp   -0.4654768 2.911994e+00 -0.15984815 0.873000692 -6.172879e+00  5.241926e+00           0.000429252 binomial 32        0      0            Eg NPR diagnosis
 3       mpg      wt   -0.5371701 1.509612e-01 -3.55833115 0.001354124 -8.330486e-01 -2.412915e-01           0.288551676 gaussian 32        0      0 Short discription of pheno1
 4       mpg      hp   -0.4292733 1.521142e-01 -2.82204633 0.008680861 -7.274116e-01 -1.311350e-01           0.184275543 gaussian 32        0      0 Short discription of pheno1
```
