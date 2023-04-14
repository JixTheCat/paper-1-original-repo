# data_prep.py has to be executed in order for df.csv to exist
df <- read.csv("df.csv")

# We create our first model
anova(lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
summary(lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
# 0.9059

# We add Value to the model :P
anova(lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
summary(lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
# 0.9747

# Lets look at ratios
anova(lm(df$ha_tonnes_grapes_harvested ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
summary(lm(df$ha_tonnes_grapes_harvested ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
# 0.7763

anova(lm(df$ha_value ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
summary(lm(df$ha_value ~ df$area_harvested*((df$scope1)+df$water_used)+df$data_year_id:df$giregion))
# 0.9637 

# note that vtha~tha is not a great predictor of one another.
# but it is a significant variable!
summary(lm(df$ha_value ~ df$ha_tonnes_grapes_harvested))
anova(lm(df$ha_value ~ df$ha_tonnes_grapes_harvested))

# note that scope1 is only good for predicting the amount of grapes not the quality.

# here are some plots
plot(df$area_harvested , df$tonnes_grapes_harvested*df$average_per_tonne, col=factor(df$giregion))
plot(df$area_harvested , df$tonnes_grapes_harvested, col=factor(df$giregion))
abline(predict(mod, df[df$giregion=="McLaren Vale" , ]), df$area_harvested)
#######################
# Lets make some maps #
library(terra)
v <- vect("data/Wine_Geographical_Indications_Australia_2022/Wine_Geographical_Indications_Australia_2022.shp")
aus <- vect("data/STE_2021_AUST_SHP_GDA2020/STE_2021_AUST_GDA2020.shp")

v$ha_tonnes_grapes_harvested <- 0
v$ha_value <- 0

mean.t <- function(x) {mean(x, na.rm=TRUE)}
aggs.ha_tonnes_grapes_harvested <- aggregate(df$ha_tonnes_grapes_harvested, list(df$giregion), FUN=mean.t)
aggs.ha_value <- aggregate(df$ha_value, list(df$giregion), FUN=mean.t)

for (region in unique(df$giregion))
{
v[v$GI_NAME==region , ]$ha_tonnes_grapes_harvested <- aggs.ha_tonnes_grapes_harvested[aggs.ha_tonnes_grapes_harvested$Group.1==region , ]$x
v[v$GI_NAME==region , ]$ha_value <- aggs.ha_value[aggs.ha_value$Group.1==region , ]$x
}

plot(v, "ha_tonnes_grapes_harvested")
lines(aus)

#    data (or map) frame
#    map legend
#    map title
#    north arrow
#    map scale bar
#    metadata (or map citation)
#    border (or neatline)
#    inset (or locator) map.

spl <- lm(df$tha ~ bs(df$water_used, df=3) )
x_lim <- range(df$tha, na.rm=TRUE)
x_grid <- seq(x_lim[1], x_lim[2])
preds <- predict(spl, list(x_grid))
plot(df$tha, df$water_used)
lines(x_grid, preds, col="blue", lty="dotted")



















