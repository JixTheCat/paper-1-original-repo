"""This is the data preparation for the analysis conducted in paper one

It requires the SWA data libraries used in this project to function.
"""
# These are three files required:
from data import rain, temp
from carbon_converter import *
# Note that conn.py is also required due to data needing it.

# normal imports
import pandas as pd
import numpy as np

# You will require the df.feather output file from the SWA-Data pipeline.
df = pd.read_feather("df.feather")

# Lets get rid of some errors!
# $1 sale price is ludicruous - There are other ludicruous prices like $50 etc as well. You can go harder at removing these.
df.loc[1848, "average_per_tonne"] = np.nan
df.loc[5493, "average_per_tonne"] = np.nan
# Less than 1ha we can write off.
#df = df.drop(index=df[df['area_harvested']<1].index)

###################################
# We insert values for emissions
#
# We convert the use of fuels into CO2E
# This includes both scope1 and scope 2 in the totals, as well as separate columns for comparison.
df["total_irrigation_electricity"] = df["total_irrigation_electricity"].apply(scope2)
df["irrigation_energy_diesel"] = df["irrigation_energy_diesel"].div(1000).apply(diesel_irrigation)
df["irrigation_energy_electricity"] = df["irrigation_energy_electricity"].div(1000).apply(scope2)
df["irrigation_energy_pressure"] = df["irrigation_energy_pressure"].div(1000).apply(scope2)
df["diesel_vineyard"] = df["diesel_vineyard"].div(1000).apply(diesel_vehicle)
df["electricity_vineyard"] = df["electricity_vineyard"].div(1000).apply(scope2)
df["petrol_vineyard"] = df["petrol_vineyard"].div(1000).apply(petrol_vehicle)
df["lpg_vineyard"] = df["lpg_vineyard"].div(1000).apply(lpg_vehicle)
df["biodiesel_vineyard"] = df["biodiesel_vineyard"].div(1000).apply(biodiesel_vehicle)

df["scope2"] = df["total_irrigation_electricity"]\
    + df["irrigation_energy_electricity"]\
    + df["irrigation_energy_pressure"]\
    + df["electricity_vineyard"]

df["scope1"] = df["irrigation_energy_diesel"]\
    + df["diesel_vineyard"]\
    + df["petrol_vineyard"]\
    + df["lpg_vineyard"]\
    + df["biodiesel_vineyard"]

df["total_emissions"] = df["scope1"] + df["scope2"]

################################
# We add total fertiliser used
#
df['nitrogen_applied'] = df['synthetic_nitrogen_applied']+df['organic_nitrogen_applied']
df['fertiliser_applied'] = df['synthetic_fertiliser_applied']+df['organic_fertiliser_applied']

df["fertiliser"] = df['fertiliser_applied'] + df['nitrogen_applied']

######################
# We add in climates
#
df["rain"] = df["giregion"].apply(rain)
df["temp"] = df["giregion"].apply(temp)
df.loc[df["rain"]=="Unknown Climate", "rain"] = np.nan
df.loc[df["temp"]=="Unknown Climate", "temp"] = np.nan
df["climate"] = df["temp"] + " " + df["rain"]
df.loc[df["climate"]=="Unknown Climate Unknown Climate", "climate"] = np.nan

########################
# We change units
#
# changing ha to m2 for area to remove 1s and fractions for the log transform
df["area_harvested"] = df["area_harvested"]*1000

#create a flage for disease/fire/frost
df["not_harvested"] = 0
df.loc[df["area_not_harvested"]>0, "not_harvested"] = 1

# red grapes
df["red_grapes"] = 0
df.loc[df["vineyard_area_red_grapes"]>0, "red_grapes"] = 1

# include value
df["value"] = df["area_harvested"]*df["average_per_tonne"]
# include ratios
df["tha"] = df["tonnes_grapes_harvested"].div(df["area_harvested"])
df["vtha"] = df["tha"]*df["average_per_tonne"]



# The variables are logarithmically transformed and then centrered.
df_floats = df.select_dtypes(float)
df_o = df.select_dtypes("O")
df_int = df.select_dtypes(int)

df_floats = df_floats.apply(np.log)

# Be sure to remove any values that become infinite, or are Null due to the transform or are missing/invalid values.
df_floats = df_floats.replace({np.inf: np.nan, -np.inf: np.nan})

df_floats = df_floats.loc[df_floats[df_floats["tonnes_grapes_harvested"].notnull()].index].copy()
df_floats = df_floats.drop(df_floats[df_floats["water_used"].isnull()].index)
df_floats = df_floats.drop(df_floats[df_floats["area_harvested"].isnull()].index)
df_floats = df_floats.drop(df_floats[df_floats["total_emissions"].isnull()].index)

# Scale and centre
df_floats = df_floats - df_floats.mean()
df_floats = df_floats/df_floats.std()

df = pd.concat([df_floats, df_o, df_int], axis=1)

#df = df.replace({np.nan: 0}) <- this is bad

df.to_csv("df.csv")


