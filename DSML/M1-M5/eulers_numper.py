import math

result = 1
for i in range(1,6):
    result += 1/math.factorial(i)

print(round(result,2))