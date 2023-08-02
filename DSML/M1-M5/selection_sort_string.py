def selectionSort(arr):

    for i in range(len(arr)-1):
        min_idx = i
        for j in range(i+1, len(arr)):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[min_idx], arr[i] = arr[i], arr[min_idx]

        print(arr)

    return arr

arr = ['alpha', 'gamma', 'beta', 'delta']

# arr = [1,1,1,1, -1, -1, -1]
selectionSort(arr)