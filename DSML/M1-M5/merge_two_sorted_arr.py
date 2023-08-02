def merge_two_arr(a, b):
    i = len(a) + len(b)
    res = []
    a_pointer = 0
    b_pointer = 0
    for i in range(i):
        if a_pointer < len(a) and b_pointer < len(b):
            if a[a_pointer] < b[b_pointer]:
                res.append(a[a_pointer])
                a_pointer += 1
            else:
                res.append(b[b_pointer])
                b_pointer += 1
        elif a_pointer >= len(a):
            res.extend(b[b_pointer:])
            break
        else:
            res.extend(a[a_pointer:])
            break

    return res

def merge(arr, low, mid, high):
    left = arr[low:mid + 1]
    right = arr[mid + 1:]
    return merge_two_arr(left, right)

def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid_point = len(arr)//2
    left = arr[:mid_point]
    right = arr[mid_point:]

    half_a = merge_sort(left)
    half_b = merge_sort(right)

    return merge_two_arr(half_a, half_b)



arr = [10, 15, 20, 11, 13]
merge_sort(arr)

