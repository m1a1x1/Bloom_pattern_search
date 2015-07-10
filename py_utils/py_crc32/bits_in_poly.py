res = bin(int('1EDC6F41', 16))[2:]
print res
cnt = 0
for i in reversed(res): 
  if i == "1":
    print cnt
  cnt = cnt + 1
