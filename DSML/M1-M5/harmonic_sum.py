def harmonic_sum(n):
    '''n = Input in integer format
       output:return harmonic sum'''
    # YOUR CODE GOES HERE

    if n == 1:
        return 1

    return round(1/n + harmonic_sum(n-1), 3)

harmonic_sum(7)