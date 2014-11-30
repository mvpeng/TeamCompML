import types
import json
import os
import csv


def exhaustively_write(data_struc, csv_file):
   if type(data_struc) is types.DictType:
      for key in data_struc.keys():
         exhaustively_write(data_struc[key],csv_file)
   elif type(data_struc) is types.ListType:
      for i in xrange(0,len(data_struc)):
         exhaustively_write(data_struc[i],csv_file)
   else:
      csv_file.write(str(data_struc)+',')


for f in os.listdir('dump'):
   if f.find('json') != -1:

        json_data = open('dump/'+f)
        data = json.load(json_data)
        if len(data['participants']) == 10:
            csv_file = open('csv_dump/'+f.split('.json')[0]+'.csv','w+')

            for key in data.keys():
               if key == 'participants':
                  for i in range(1,10):
                     exhaustively_write(data['participants'][i],csv_file)
                     csv_file.write('\n')
               else:
                  exhaustively_write(data[key],csv_file)
                  csv_file.write('\n')

