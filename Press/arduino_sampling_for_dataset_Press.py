# -*- coding: utf-8 -*-
"""
Created on Thu Oct  6 22:13:37 2016

@author: dorsimon

Press
"""


'''
Reads in data over a serial connection and plots the results live. Before closing, the data is saved to a .txt file.
'''
import time
import sys
import serial
import numpy as np
import datetime


recorded=False

#finds COM port that the Arduino is on (assumes only one Arduino is connected)

    
length = 85                 #determines length of data taking session (in seconds)
time_length=2.5

acc_x = [0]*length               #create empty variable of length of test
acc_y = [0]*length
acc_z = [0]*length
gy_x = [0]*length               
gy_y = [0]*length
gy_z = [0]*length

for j in range(8):
    try:
        print('trying to connect')
        s = serial.Serial(port='/dev/cu.HC-05-DevB', baudrate=9600);
        print('connection succesful')
    except:
        print('did not manage to connect, closing and reopening')
        try:        
            s.close();
            print('old connection close')
        except:
            sys.exit('no device to connect to, check device');
        s = serial.Serial(port='/dev/cu.HC-05-DevB', baudrate=9600);
        print('new connection started')
    pass 
    input("Press any key to continue to next recording") #incase needed for keyboard input
    t_end = time.time() + time_length;
    while time.time() < t_end:  #while you are taking data
        data = s.readline()    #reads until it gets a carriage return. MAKE SURE THERE IS A CARRIAGE RETURN OR IT READS FOREVER
        sep = data.split()      #splits string into a list at the tabs
        print (sep)
        try:    
            acc_x.append(int(sep[0]))   #add new value as int to current list
            acc_y.append(int(sep[1]))
            acc_z.append(int(sep[2]))
            gy_x.append(int(sep[3]))   
            gy_y.append(int(sep[4]))
            gy_z.append(int(sep[5]))
        except:
            print('data appending did not succeed')            
            pass
#        
        del acc_x[0]
        del acc_y[0]
        del acc_z[0]
        del gy_x[0]
        del gy_y[0]
        del gy_z[0]
    
    rows = list(zip(acc_x, acc_y, acc_z, gy_x, gy_y, gy_z));               #combines lists together
    
    row_arr = np.array(rows);               #creates array from list
    print(row_arr)
    
    #savetxt_compact('/Users/dorsimon/Desktop/test_radio2.txt', row_arr, fmt='%.4f')
    
#    with open('/Users/dorsimon/Desktop/Workout.csv','ab') as f_handle: #ab mode enables to append the new values, a for append, b for binary values
#        np.savetxt(f_handle,row_arr)
    
    
    #old writing options
    #np.savetxt('/Users/dorsimon/Desktop/Wourout.txt', row_arr) #save data in file (load w/np.loadtxt())

    #this is the working one    
    np.savetxt('/Users/dorsimon/Desktop/machine learning project/New Data Set/Press/Samples/Press_' + str(datetime.datetime.now().strftime('%d%mU%H%M%S')) + '.txt', row_arr) #save data in file (load w/np.loadtxt())
    
    #this one is test for MATLAB    
    #np.savetxt('/Users/dorsimon/Desktop/machine learning project/Data Set/BT/testBT.txt', row_arr) #save data in file (load w/np.loadtxt())
    
#    f=open('/Users/dorsimon/Desktop/machine learning project/Data Set/BT/testBT.txt','ab')
#    np.savetxt(f,row_arr)
#    f.close()
    
    recorded=True
    print('movement recorded')
s.close() #closes serial connection (very important to do this! if you have an error partway through the code, type this into the cmd line to close the connection)

