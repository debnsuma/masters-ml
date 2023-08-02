def sum_series(n):
    '''n = Input in integer format
       output:return sum of the series'''
    # YOUR CODE GOES HERE
    global a
    print(f"{n} + ", end='')
    if n - a <= 0:
        return n

    return n + sum_series(n - a)

a = 2

sum_series(10)