import random

array = list(range(100))
random.shuffle(array)
result = []
while len(array) != 0:
    a = array.pop()
    result.append(a)
    print(a)

sorted(result)
# print(a)
print(len(result))