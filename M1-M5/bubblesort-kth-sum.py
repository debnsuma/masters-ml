def bubble_sort(a, k):
    n = len(a[:k])
    print(n)
    for i in range(n):
        flag = False
        for j in range(0, n - i - 1):
            if a[j] > a[j+1]:
                a[j + 1], a[j] = a[j], a[j + 1]
                flag = True
        if not flag:
            break

    return a[0] + a[-1]


arr = "54 75 58 96 113 54 667".split(" ")
arr = [int(i) for i in arr]
bubble_sort(arr, 5)

#%%
