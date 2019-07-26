# -*- coding: utf-8 -*-
"""
Created on Tue Jan  3 15:47:17 2017

@author: marckendal
"""

#Read postcodes files
import pandas as pd
#

hpd = pd.read_csv('hpddata2.csv', header=0)

print("step 1")
postcodes = pd.DataFrame(hpd.iloc[:,0:2])
postcodes1 = postcodes.dropna()
postcodes1.to_csv('postcodes1.csv')

ukpc = pd.read_csv('UK_postcodes.csv')
uk_postcodes = ukpc.loc[:,['pcds', 'oslaua' ]]
uk_postcodes = uk_postcodes.rename(columns={'pcds': 'PostCode', 'oslaua': 'LA_Code'})
uk_postcodes1 = uk_postcodes.dropna()
uk_postcodes1.to_csv('uk_postcodes1.csv')
#
mergedHPD_UK  = postcodes1.merge(uk_postcodes1, on='PostCode', how='inner')
mergedHPD_UK.to_csv('mergedHPD_UK.csv')
#
#
#
mergedHPD_UK['Mean'] = mergedHPD_UK['Price'].groupby(mergedHPD_UK['LA_Code']).transform('mean')


duplicates_removed_UK = mergedHPD_UK.drop_duplicates(subset='LA_Code')
la_uk = pd.read_csv('ewlatoregionlookup.csv', skiprows=4)
la_uk = la_uk.rename(columns={'LA code': 'LA_Code'})
duplicates_removed_UK_LA = duplicates_removed_UK.merge(la_uk, on='LA_Code', how='outer  ')
duplicates_removed_UK_LA.to_csv('duplicates_removed_UK_LA.csv')# 

# source_cols = duplicates_removed.columns
# new_cols = ['Region']
# categories = {London}
#duplicates_removed['Region']= duplicates_removed[duplicates_removed.columns].apply("London")

#duplicates_removed['Region'] = 'London'
#
   
###
##def cust_mean(grp):
##        grp['mean'] = grp['Price'].mean()
##        return grp
#       
#mergedHPD['Mean'] = mergedHPD['Price'].groupby(mergedHPD['LA_Code']).transform('mean')
##meanMerged = mergedHPD.groupby(['LA_Code'])['Price'].mean()
##london_postcodes
#
#duplicates_removed = mergedHPD.drop_duplicates(subset='LA_Code')