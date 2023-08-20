def recur_search(key, values, lower, upper):

    # base case
    # print(lower, upper)
    if lower >= upper:
        return -1

    mid = (upper + lower)//2

    if values[mid] == key:
        return mid
    elif values[mid] > key:
        upper = mid - 1
        return recur_search(key, values, lower, upper)
    else:
        lower = mid + 1
        return recur_search(key, values, lower, upper)


def solve(A, B):
    count = recur_search(B, A, 0, len(A)) + 1
    final_count = count
    # print(A[count:])
    if count > 0 and len(A[count:]) > 0:
        print(A[count:])
        count = recur_search(B, A[count:], 0, len(A[count:]))
        final_count += count + 1

    return final_count

print(solve([1,1,1,1,3, 3],3))