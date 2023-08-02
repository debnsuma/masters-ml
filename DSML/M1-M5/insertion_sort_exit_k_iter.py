def insertionSort(arr,k):
    """
    arr is the list and k is the iteration number
    store the result with variable name res
    """
    #YOUR CODE GOES HERE

    return res

def insertionSort(arr, k):
    if len(arr) == 1:
        return arr[k]
    counter = k
    for i in range(1, len(arr)):
        if counter == 0:
            break
        else:
            x = arr[i]
            j = i - 1
            while j >= 0 and x < arr[j]:
                arr[j + 1] = arr[j]
                j -= 1
            arr[j + 1] = x
            counter -= 1

    return arr[len(arr)//2]


arr = [12, 11, 13, 5, 6]
k = 2
insertionSort(arr, k)