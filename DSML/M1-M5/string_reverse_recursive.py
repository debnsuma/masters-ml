def rev(n, temp=''):
    ''' n-indicates the number to be reversed,
         output:Return the number in reversed order in the string format'''

    # YOUR CODE GOES HERE

    if n// 10 == 0:
        return temp + str(n)

    next_n = n // 10
    last_digit = n % 10
    temp += str(last_digit)
    return rev(next_n, temp)


rev(100)