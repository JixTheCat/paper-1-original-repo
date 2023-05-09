import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("df.csv")

selected = [
    "area_harvested"
    , "tonnes_grapes_harvested"
    , "water_used"
    , "total_tractor_passes"
    , "average_per_tonne"
    , "scope1"
    , "fertiliser"
]

axes = pd.plotting.scatter_matrix(df[selected], figsize=[10,10], color=
    "teal")
for ax in axes.flatten():
    if ax.get_xlabel() == "average_per_tonne":
        ax.set_xlabel("average_price_per_tonne")
    if ax.get_ylabel() == "average_per_tonne":
        ax.set_ylabel("average_price_per_tonne")
    if ax.get_xlabel() == "total_operating_costs":
        ax.set_xlabel("operating_costs")
    if ax.get_ylabel() == "total_operating_costs":
        ax.set_ylabel("operating_costs")
    if ax.get_xlabel() == "total_tractor_passes":
        ax.set_xlabel("tractor_passes")
    if ax.get_ylabel() == "total_tractor_passes":
        ax.set_ylabel("tractor_passes")
    if ax.get_xlabel() == "scope1":
        ax.set_xlabel("scope_one_emissions")
    if ax.get_ylabel() == "scope1":
        ax.set_ylabel("scope_one_emissions")
    ax.xaxis.label.set_rotation(0)
    ax.yaxis.label.set_rotation(0)
    ax.yaxis.label.set_ha('right')
    if ax.get_xlabel() == ax.get_ylabel():
        continue
    ax.set_xlim(-4, 4)
    ax.set_ylim(-4, 4)
plt.tight_layout()
plt.gcf().subplots_adjust(wspace=0, hspace=0)
plt.show()

