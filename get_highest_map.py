import os
import operator

### to run: python3 ./get_highest_map.py

path = ''

files_list =sorted(os.listdir(path))
#only last 10
#files_list = files_list[-10:]
results = {}

for file in files_list:

    os.chdir('')
    # command = './darknet detector map ./build/darknet/x64/data/xx.data ./build/darknet/x64/xx.cfg ./build/darknet/x64/backup_r/' + file
    command = './darknet detector map ./build/darknet/x64/data/xx.data ./build/darknet/x64/cfg/xx.cfg ~/Desktop/darknet-master_03_02/build/darknet/x64/backup/'+file
    stat = os.popen(command).read()

    lines = []
    lines = stat.split('\n')
    mAP = float(lines[-2].split('or ')[1].split(' %')[0])
    IoU = float(lines[-4].split('IoU = ')[1].split(' %')[0])
    results[file] = mAP

    with open('path/results.txt' , 'a') as f:
        f.write(file +' mAP: '+ str(mAP) +'% IoU: '+ str(IoU)+ '%\n')

# max_precision = max(results.values())
# for file, precision in results.items():
#     if max_precision == precision:
#         print(file)
#
# sorted_x = sorted(results.items(), key=operator.itemgetter(1))
# for i in range(len(sorted_x)-10):
#     print(sorted_x[i][0])
    # os.remove(path+'/'+sorted_x[i][0])