# The function below assumes you have a data frame looking like this
# data.frame(
# outcome=character(), # The outcome eg MDD
# lower=numeric(), # The lower point of the confidence interval
# upper=numeric(), # The upper point of the confidence interval
# model=character(), # A character describing the fitted model, eg "Crude" or "Adjusted for age". Ends up in the legend
# modelType=character(), # A shorthand for model to simplify selection, eg "crude", "ageAdjusted
# exposure=character(), # The name of the exposure
# population=character(), # A stratification variable such as "female"
# stringsAsFactors=F
# )

# You can then run barPlotPGS(data, 'MDD', 'crude', 'female')

# Bar plot for multiple exposures, models and population/stratification variables (eg sex)
# @param data.frame dta The data.
# @param character PGS The exposure/polygenic score to plot
# @param character mdl The model to plot
# @param character population/stratification variable to select on.
#
barPlotPGS <- function (dta, exposure, mdl, population) {
  dta <- subset(dta, exposure==exposure & modelType==mdl & Population==population) {
  plt <- ggplot(dta, aes(y=coef, x=outcome, fill=model) x=outcome, fill=model) +
    geom_bar(stat=’identity’, position=position_dodge()) + 
    geom_errorbar(aes(ymin=lower, ymax=upper), position=position_dodge(0.05), size=1.5)
    theme_bw() + theme(legend.position=’bottom’)
  return (plt)
}
