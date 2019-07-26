# -*- coding: utf-8 -*-
"""
Created on Thu Dec 29 16:11:07 2016

@author: marckendal
"""

import pandas as pd
import json
from lib import PostCodeClient
import numpy as np




# Get area code from a postcode

# convert postcodes
hpd = pd.read_csv('hpddata2.csv', header=0)

print("step 1")
postcodes = pd.DataFrame(hpd.iloc[:,0:2])
postcodes1 = postcodes.dropna()
postcodes1.to_csv('postcodes1.csv')


lpc = pd.read_csv('london_postcodes.csv')
london_postcodes = lpc.loc[:,['pcds', 'oslaua' ]]
london_postcodes = london_postcodes.rename(columns={'pcds': 'PostCode', 'oslaua': 'LA_Code'})
london_postcodes1 = london_postcodes.dropna()
london_postcodes1.to_csv('london_postcodes1.csv')

mergedHPD  = postcodes1.merge(london_postcodes1, on='PostCode', how='inner')
mergedHPD.to_csv('mergedHPD.csv')



    
#
#def cust_mean(grp):
#        grp['mean'] = grp['Price'].mean()
#        return grp
       
mergedHPD['Mean'] = mergedHPD['Price'].groupby(mergedHPD['LA_Code']).transform('mean')
#meanMerged = mergedHPD.groupby(['LA_Code'])['Price'].mean()
#london_postcodes

duplicates_removed = mergedHPD.drop_duplicates(subset='LA_Code')


# source_cols = duplicates_removed.columns
# new_cols = ['Region']
# categories = {London}
#duplicates_removed['Region']= duplicates_removed[duplicates_removed.columns].apply("London")

duplicates_removed['Region'] = 'London'

duplicates_removed.to_csv('no_duplicates.csv')







#client = PostCodeClient()
#def get_area_code(postcode):  
##    quotes = '"' + postcode + '"'
#
#    ACresults = client.getLookupPostCode(postcode)
#    values = json.loads(ACresults)
#    try:
#        area_code = values['result']['codes']['admin_district']  
#    except KeyError :
#        area_code = "skip"
#    return area_code        
#
#
#df4= get_area_code("BR1 1DJ")
#
#
#
#


## convert postcodes
#hpd = pd.read_csv('hpddata2.csv', header=0)
#
#print("step 1")
#postcodes = pd.DataFrame(hpd.iloc[:,0:2])
#postcodes1 = postcodes.dropna()
#df2 = pd.DataFrame([])
#
#print("step2")
#def get_postcode_list(dataframe):
#        i=0
#        for row in postcodes1.head(n=100000).itertuples():
#            print("step3")
#            area_code_conversion = get_area_code(row.PostCode)
#            print("step 4")
#            
##  if Key Error
#            if area_code_conversion == "skip":
#                i+= 1
#                continue
#            dataframe = dataframe.append(pd.DataFrame.from_records({'Price': [row.Price], 'AreaCode' : [area_code_conversion], 'PostCode': [row.PostCode]}),ignore_index=True)
#            print(dataframe)
#        return(dataframe) 
#
#
#print("step6")
#df2 = get_postcode_list(df2)
#print("step7")
#df2.to_csv('df100000.csv')
#print("step8")
#        

#def get_london_postcode_data:
#    
        
        
        
        
        
    #for row in postcodes1.itertuples():
#   print(row)    
        
     #        df2.append(df1, ignore_index=True)
#        df1.loc[row] = [row.PostCode, area_code_conversion]
#        df1.append(row.PostCode, area_code_conversion)
   
        
#        
#        df = DataFrame(columns=('Price', 'PostCode'))
#>>> for i in range(5):
#>>>     df.loc[i] = [randint(-1,1) for n in range(3)]
#>>>
#>>> print(df)
        
#df1 = pd.DataFrame()        
    

#postcodes1.apply(get_area_code(print_postcode), axis = 1)  


#get_area_code(col1), 
# 



#ACresults = client.getLookupPostCode("NW11 8LA")
#print (ACresults)
#postcodes = house_price_data.as_matrix(['PostCode']) 
#df3 =postcodes.apply(get_area_code, 1)
#df1 = house_price_data.insert(0,postcodes, postcodes, allow_duplicates=True)
#df1 = pd.Dataframe(house_price_data, index='PostCode')
#postcodes.apply(get_area_code(postcodes), axis=1)






    
    





#for each postcode in column postcodes get 


#area_code = postcode[postcode.find(s1)]
#area_code_fixed = area_code[3:12]

#admin_district_pos = postcode.find(s1)
#area_code = postcode[admin_district_pos+12:admin_district_pos+50]
