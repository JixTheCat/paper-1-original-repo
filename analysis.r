# data_prep.py has to be executed in order for df.csv to exist
df <- read.csv("df.csv")

# We create our first model
anova(lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
summary(lm(tonnes_grapes_harvested ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
#0.9077

# We add Value to the model :P
anova(lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
summary(lm(value ~ data_year_id+giregion+area_harvested+water_used+scope1,data=df))
# 0.9296


# Lets look at ratios
anova(lm(df$tha ~ df$area_harvested+df$scope1+df$water_used+df$data_year_id:df$giregion))
summary(lm(df$tha ~ df$area_harvested+df$scope1+df$water_used+df$data_year_id:df$giregion))

anova(lm(df$vtha ~ df$area_harvested+df$scope1+df$water_used+df$data_year_id:df$giregion))
summary(lm(df$vtha ~ df$area_harvested+df$scope1+df$water_used+df$data_year_id:df$giregion))

# note that vtha~tha is not a great predictor of one another.
summary(lm(df$vtha ~ df$tha*df$giregion*df$data_year_id))

# here are some plots
plot(df$area_harvested , df$tonnes_grapes_harvested*df$average_per_tonne, col=factor(df$giregion))
plot(df$area_harvested , df$tonnes_grapes_harvested, col=factor(df$giregion))
abline(predict(mod, df[df$giregion=="McLaren Vale" , ]), df$area_harvested)
#######################
# Lets make some maps #
library(terra)
v <- vect("data/Wine_Geographical_Indications_Australia_2022/Wine_Geographical_Indications_Australia_2022.shp")
aus <- vect("data/STE_2021_AUST_SHP_GDA2020/STE_2021_AUST_GDA2020.shp")

v$tha <- 0
v$vtha <- 0

mean.t <- function(x) {mean(x, na.rm=TRUE)}
aggs.tha <- aggregate(df$tha, list(df$giregion), FUN=mean.t)
aggs.vtha <- aggregate(df$vtha, list(df$giregion), FUN=mean.t)

for (region in unique(df$giregion))
{
v[v$GI_NAME==region , ]$tha <- aggs.tha[aggs$Group.1==region , ]$x
v[v$GI_NAME==region , ]$vtha <- aggs.vtha[aggs$Group.1==region , ]$x
}

plot(v, "tha")
lines(aus)

#    data (or map) frame
#    map legend
#    map title
#    north arrow
#    map scale bar
#    metadata (or map citation)
#    border (or neatline)
#    inset (or locator) map.


