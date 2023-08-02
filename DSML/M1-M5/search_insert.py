def searchInsert(A, B):
    count = 0

    while len(A) > 0:
        lower = 0
        upper = len(A)
        mid = (upper + lower) // 2
        if B == A[mid]:
            if count == 0:
                return mid
            else:
                return mid + count
        if B >= A[mid]:
            count += mid + 1
            A = A[mid+1:]
        else:
            A = A[0:mid]
        print(A, mid, count)

    return count

print(searchInsert([10, 20, 30, 40, 50, 60], 1))