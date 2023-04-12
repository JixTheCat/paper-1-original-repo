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




