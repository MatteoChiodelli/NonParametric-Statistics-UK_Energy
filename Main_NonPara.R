acorn_details<-read.csv("Data/acorn_details.csv",header=TRUE,fileEncoding="windows-1252")
# Contains the detail of subgroups of the populations wrt ACORN data

household_legend<-read.csv("Data/informations_households.csv",header=TRUE)
# This file contains each household informations:
# - ACORN group
# - tariff type: Std=fixed, ToU=dynamic
# - the informations about power usage of every house are stored in blocks in hhblock_dataset and halfhourly_dataset
#   every block has multiple houses

weather_hourly<-read.csv("Data/weather_hourly_darksky.csv", header=TRUE)
weather_daily<-read.csv("Data/weather_daily_darksky.csv", header=TRUE)
# Files containing infos about the weather, not fundamental but can be useful

# PROJECT PLAN (draft)

# Question: does the dynamic tariff change WHEN and HOW MUCH households consume during the day?
#           for which households (ACORN) does it work better?
# Stakeholder: energy distributor (UK Power Networks) / regulator (Ofgem)
#
# Remember:
# - 2012: everybody on fixed tariff
# - 2013: ~1100 households (ToU) switched to the dynamic tariff, the others (Std) stayed fixed
#   (2012 part to be confirmed in LCL Report D4)
# - households chose to join -> groups NOT random -> they can be different from the start
# - unit = household (one curve per house), not the single day
#
# Work:
# 1 data cleaning
# 2 inference on group composition (2012: Std vs future ToU)
# 3 inference 2012 vs 2013 (causal effect of the tariff)
# 4 (optional, if we have time) weather


# 1 DATA CLEANING
# - for every house: when it enters and when it exits the program (daily_dataset)
# - keep only complete days (48 half hours), remove houses with no complete days (6 houses)
# - remove for everybody the days when the meters failed for everybody:
#   13-17 Jun 2012, 25 May 2012, 4 Jul 2012, 11-17 Dec 2012, 19-20 Jan 2014, 28 Feb 2014
# - remove houses without ACORN info: 51 out of 5566 (0.9%; 39 Std, 12 ToU)
# - keep only months present in both years and houses present in both years
# - output: for every house one mean daily curve (48 points) for 2012 and one for 2013


# 2 GROUP COMPOSITION (2012, everybody fixed)
# Are the future ToU houses different from the Std houses already before the change?
# - ACORN groups (ToU: more Affluent 44% vs 38%, less Adversity 27% vs 34%)
# - consumption level (kWh/day)
# - shape of the daily curve
# Tools: permutation tests, Mann-Whitney, bootstrap CI, functional permutation test + IWT, depth


# 3 2012 vs 2013 (effect of the tariff)
#                 2012    2013
#   Std           fixed   fixed     -> difference = effect of the year
#   ToU           fixed   dynamic   -> difference = effect of the year + effect of the tariff
#   ToU - Std                       -> effect of the tariff + effect of the group composition
# - for every house: curve 2013 - curve 2012, then compare ToU vs Std
# - in which hours? (IWT), how much? (bootstrap CI), for whom? (by ACORN group)
# - level (consume less) vs shape (move consumption to other hours): use also curve / daily total
# - assumption: without the tariff the two groups would have changed in the same way
# - extension: Data/Tariffs.xlsx has the price of every half hour of 2013
#   -> compare high-price / low-price days (the average over all days dilutes the effect)


# 4 WEATHER (optional)
# - is the year effect due to a different weather?
# - GAM: consumption vs temperature and hour
# - quantile regression: does the tariff lower the peaks?
