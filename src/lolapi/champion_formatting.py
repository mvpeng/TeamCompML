stats = open('champion_stats.csv')
names = open('champions.txt')
out = open('champion_stats_final_12.csv','w+')

name = {};

for line in names.readlines():
   content = line.split(',');
   name[content[0]] = content[1].strip()

iter = 0;
for line in stats.readlines():
   iter = iter+1

   if name.has_key(str(iter)):
      out.write(name[str(iter)] + ',' + line)
