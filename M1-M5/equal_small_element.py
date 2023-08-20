

def solve_using_recursion(A, B):
    global count
    # print(count, A)
    if not A:
        return count
    else:
        lower = 0
        upper = len(A)
        mid = (upper + lower) // 2

        if B >= A[mid]:
            count += mid + 1
            return solve_using_recursion(A[mid+1:], B)
        else:
            return solve_using_recursion(A[0:mid], B)

def solve_using_while(A, B):
    count = 0

    while len(A) > 0:
        lower = 0
        upper = len(A)
        mid = (upper + lower) // 2

        if B >= A[mid]:
            count += mid + 1
            A = A[mid+1:]
        else:
            A = A[0:mid]
        # print(A, mid, count)

    return count


count = 0
print(solve_using_recursion([1, 3, 4, 5, 5, 6], 6))
print(solve_using_while([1, 3, 4, 5, 5, 6], 6))