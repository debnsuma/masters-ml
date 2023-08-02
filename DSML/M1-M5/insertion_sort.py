def insertion_sort(arr):
    if len(arr) == 1:
        return arr
    for i in range(1, len(arr)):
        x = arr[i]
        j = i - 1
        while j >= 0 and x < arr[j]:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = x

    return arr


# arr = [20, 5, 40, 60, 10, 30]
# # arr = [1,1,1,1, -1, -1, -1]
# insertion_sort(arr)
# # %%
#

def insertionSort(arr):
    value=0
    for i in range(1,len(arr)+1):
        value=arr[i-1]
        j=i-1
        while (j > 0) and (arr[j-1] > value):
            arr[j]=arr[j-1]
            j=j-1
        arr[j]=value

    return arr

arr = [20, 5, 40, 60, 10, 30]
# arr = [1,1,1,1, -1, -1, -1]
insertionSort(arr)
# %%