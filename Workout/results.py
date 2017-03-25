# -*- coding: utf-8 -*-
"""
Created on Tue Mar 14 23:25:08 2017

@author: dorsimon
"""
import numpy as np
from time import sleep

result=3
squat_num=0
press_num=0
deadlift_num=0

while True:
        
    if result==1:
        squat_num=squat_num+1
    elif result==2:
        press_num=press_num+1
    elif result==3:
        deadlift_num=deadlift_num+1
        
    results_vector = np.asarray([ result, squat_num, press_num, deadlift_num ])
    results_vector.tofile('results.csv',sep=',',format='%10.5f')    
    print(results_vector)
    sleep(2.5)

    
    