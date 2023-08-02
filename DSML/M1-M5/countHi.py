def countHi(s, count=0):
    ''' s-indicates the string,
         output:Return the count of occurrences of "hi" in s'''

    # YOUR CODE GOES HERE
    if len(s) < 2:
        return count

    else:
        if s[:2].lower() == 'hi':
            count += 1


        return countHi(s[1:], count)


s = 'hishisha'
countHi(s, 0)