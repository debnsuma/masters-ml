def bubble_sort(a):
    '''
    The bubble sort algorithm is not an efficient sorting algorithm,
    as it provides a worst-case runtime complexity of O(n2), and a best-case complexity of O(n).
    '''
    n = len(a)
    for i in range(n):
        flag = False
        for j in range(0, n - i - 1):
            if a[j] > a[j+1]:
                a[j + 1], a[j] = a[j], a[j + 1]
                flag = True
        if not flag:
            break

    return a


#arr = "64 34 25 12 22 11 90".split()
arr = "46 86 55 13 19 40 80 78".split(" ")
#arr = "54 75 58 96 113 54 667".split(" ")
arr = [int(i) for i in arr]
bubble_sort(arr)

