# 1. Length of String
def lengthString(str):

    return len(str)

# print(lengthString("Geeks"))

# 2. Vowels in String
def countVowels(s):
    counts = 0
    for i in s.lower():
        if i in "aeiou":
            counts += 1
    return counts

# print(countVowels("SumanDebnath"))

# 3. Count Distinct Vowels in String
def countVowels(s):
    counts = 0
    seen_vowels = ""
    for i in s.lower():
        if i in "aeiou" and i not in seen_vowels:
            counts += 1
            seen_vowels += i
    return counts

# print(countVowels("aaaaa"))

# 4. Count Words in String
def countWords(s):
    count = 1
    for i in s:
        if i == " ":
            count += 1
    print(count)
    return count

# print(countWords("Hi Sir asdad adada"))

import string


def validate(s):
    numcheck = False
    upplcheck = False
    lowercheck = False
    speccheck = False

    if len(s) < 10:
        return 0
    else:
        for i in s:
            if i in string.digits:
                numcheck = True
                continue
            elif i in string.ascii_lowercase:
                lowercheck = True
            elif i in string.ascii_uppercase:
                upplcheck = True
            elif i in "@#$-*":
                speccheck = True

    if numcheck and upplcheck and lowercheck and speccheck:
        return 1
    else:
        return 0

def isPanagram(s):
    counter = [0] * 256
    for i in s.lower():
        counter[ord(i)] += 1
    if 0 not in counter[97:123]:
        return 1
    else:
        return 0

# isPanagram("CNoeIsyDkScKaTupgmBoPeSswOMfCDqoPeLAGvxsxEiwngUwUylljXYnDgdQAETqPgisLTqJRMjRTMcjaqNYKGYrshcQytCNC")

def isPanagram(s):
    counter = [0] * 26
    result = ""
    for i in s.lower():
        counter[ord(i)-97] += 1
    for i, j in enumerate(counter):
        if j == 0:
            result += chr(i+97)

    return result

# print(isPanagram("APFGMRZXIFPSXKOQDRRQJBBZ"))

def isAnagram(a, b):
    counter = [0] * 26

    if len(a) != len(b):
        return False
    for i, j in zip(a, b):
        counter[ord(i) - 97] += 1
        counter[ord(j) - 97] -= 1

    print(counter)
    if set(counter) == {0}:
        return True
    else:
        return False

# isAnagram('aabaa','baaaaa')

def solve(A,B):

    for i in A:
        if ord(i) == B:
            return A.index(i)
    return -1

#print(solve("abc", 100))

def solve(A,B,C):

    for i in A:
        if ord(i) == B:
            result = A.replace(i, chr(C))
            return result
    return A

#print(solve("abc", 100, 97))

def date_format(date):
    '''Input: date takes the string as input
       Output:return resultant date formats'''

    # YOUR CODE GOES HERE

    dd, mm, yyyy = date.split("/")
    print(f"{mm}/{dd}/{yyyy}")
    print(f"{yyyy}/{mm}/{dd}")

# date_format("08/12/1998")
a = 'hello'
b = a
a = 'yello'

print(b)
print(a)
