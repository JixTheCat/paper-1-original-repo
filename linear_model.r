# This is a small script that creates a GLM for the four most
# prominent variables within the dataset. It print the attributes and
# relationships from this model.

linear_model <- function(df, formula) {
  set.seed(31415)

  df <- read.csv(
        df,
        stringsAsFactors = TRUE,
        row.names = 1,
        header = TRUE)

    glm.yield <- glm(eval(parse(text=formula)))
    cat("
***************
*    ANOVA    *\n\n")
    print(anova(glm.yield))

    cat("
***************
* GLM Summary *\n\n")
    print(summary(glm.yield))


    cat("
***************
*  GLM Coefs  *\n\n")
    print(coef(glm.yield))

return(glm.yield)
}
