# data_prep.py has to be executed in order for df.csv to exist
set.seed(100)
df <- read.csv("df.csv")

model1 <- lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df)
model2 <- lm(ha_tonnes_grapes_harvested ~ area_harvested*((scope1)+water_used)+data_year_id:giregion, data=df)
model3 <- lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df)
model4 <- lm(ha_value ~ area_harvested*((scope1)+water_used)+data_year_id:giregion,data=df)

# We create our first model

# MODEL 1
anova(lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
summary(lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
#Linear Regression 
#
#6068 samples
#   5 predictor
#
#No pre-processing
#Resampling: Cross-Validated (10 fold, repeated 100 times) 
#Summary of sample sizes: 4768, 4767, 4768, 4769, 4768, 4769, ... 
#Resampling results:
#
#  RMSE      Rsquared   MAE      
#  0.308865  0.9044952  0.2164945
#
#Tuning parameter 'intercept' was held constant at a value of TRUE


# MODEL 2
# Lets look at ratios
anova(lm(df$ha_tonnes_grapes_harvested ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
summary(lm(df$ha_tonnes_grapes_harvested ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
#Linear Regression 
#
#6068 samples
#   5 predictor
#
#No pre-processing
#Resampling: Cross-Validated (10 fold, repeated 100 times) 
#Summary of sample sizes: 4768, 4768, 4768, 4769, 4769, 4768, ... 
#Resampling results:
#
#  RMSE       Rsquared   MAE      
#  0.5104218  0.7408576  0.3492901
#
#Tuning parameter 'intercept' was held constant at a value of TRUE

# MODEL 3
# We add Value to the model :P
anova(lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
summary(lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
# Residual standard error: 0.1688 on 1962 degrees of freedom
#   (2877 observations deleted due to missingness)
# Multiple R-squared:  0.9723,	Adjusted R-squared:  0.9715 
# F-statistic:  1274 on 54 and 1962 DF,  p-value: < 2.2e-16
#Linear Regression 
#
#6068 samples
#   5 predictor
#
#No pre-processing
#Resampling: Cross-Validated (10 fold, repeated 100 times) 
#Summary of sample sizes: 2590, 2590, 2591, 2590, 2590, 2591, ... 
#Resampling results:
#
#  RMSE       Rsquared   MAE      
#  0.1652455  0.9723429  0.1008465
#
#Tuning parameter 'intercept' was held constant at a value of TRUE


# MODEL 4
anova(lm(df$ha_value ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
summary(lm(df$ha_value ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
# Residual standard error: 0.1949 on 1791 degrees of freedom
#   (2877 observations deleted due to missingness)
# Multiple R-squared:  0.9662,	Adjusted R-squared:  0.962 
# F-statistic: 227.9 on 225 and 1791 DF,  p-value: < 2.2e-16
#Linear Regression 
#
#6068 samples
#   5 predictor
#
#No pre-processing
#Resampling: Cross-Validated (10 fold, repeated 100 times) 
#Summary of sample sizes: 2590, 2590, 2590, 2590, 2590, 2591, ... 
#Resampling results:
#
#  RMSE     Rsquared   MAE      
#  0.22349  0.9500051  0.1279485
#
#Tuning parameter 'intercept' was held constant at a value of TRUE

# note that vtha~tha is not a great predictor of one another.
# but it is a significant variable!
summary(lm(df$ha_value ~ df$ha_tonnes_grapes_harvested))
anova(lm(df$ha_value ~ df$ha_tonnes_grapes_harvested))

# note that scope1 is only good for predicting the amount of grapes not the quality.

# here are some plots
ggplot(df, aes(x=tonnes_grapes_harvested, y=tonnes_grapes_harvested*average_per_tonne, col=climate))+geom_point()+xlab("Yield")+ylab("Yield * Average Price")+theme_light()
ggplot(df, aes(x=ha_tonnes_grapes_harvested, y=ha_tonnes_grapes_harvested*average_per_tonne, col=climate))+geom_point()+xlab("Yield / Area Harvested")+ylab("Yield * Average Price / Area Harvested")+theme_light()

#######################
# Lets make some maps #
library(terra)
nt <- read.csv("no_trans.csv")
v <- vect("data/Wine_Geographical_Indications_Australia_2022/Wine_Geographical_Indications_Australia_2022.shp")
aus <- vect("data/STE_2021_AUST_SHP_GDA2020/STE_2021_AUST_GDA2020.shp")

v$ha_tonnes_grapes_harvested <- 0
v$ha_value <- 0

mean.t <- function(x) {mean(x, na.rm=TRUE)}
aggs.ha_tonnes_grapes_harvested <- aggregate(nt$ha_tonnes_grapes_harvested*1000, list(nt$giregion), FUN=mean.t)
aggs.ha_value <- aggregate(nt$ha_value, list(nt$giregion), FUN=mean.t)

for (region in unique(df$giregion))
{
v[v$GI_NAME==region , ]$ha_tonnes_grapes_harvested <- aggs.ha_tonnes_grapes_harvested[aggs.ha_tonnes_grapes_harvested$Group.1==region , ]$x
v[v$GI_NAME==region , ]$ha_value <- aggs.ha_value[aggs.ha_value$Group.1==region , ]$x
}

# note these are the averages.
plot(v, "ha_value")
lines(aus)
sbar(1000, lonlat=TRUE, label="1000km")
north(xy="bottomleft", type=2)

# below is just a way to grab the coefs from a linear model.
summary(model2)$coefficients



















