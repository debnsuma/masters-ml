from functools import reduce 
def func(integers, names, numbers):
    '''
    input:
    integers -> list of integers to perform the square operation on
    names -> list of names to filter out as per the condition
    numbers -> list of numbers whose product we want
    
    output:
    map_result -> output of integers list
    filter_result -> output of the names lsit
    reduce_result -> output of the numbers list
    '''
    
    # Your code stars here
    map_result = list(map(lambda x: x**2, integers))
    filter_result = list(filter(lambda x: len(x) <= 7, names)) 
    reduce_result = reduce(lambda x, y: x*y, numbers) 
    
    # Your code ends here
    
    return map_result, filter_result, reduce_result



integers = [int(i) for i in "4 6 3 9 2 8 12".split(' ')]
names = 'scaler interviewbit rishabh student course'.split(' ')
numbers = [int(i) for i in "4 6 9 23 5".split(' ')] 


map_result, filter_result, reduce_result = func(integers, names, numbers)

print(map_result, filter_result, reduce_result)
