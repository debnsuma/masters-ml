class Words:

    def __init__(self):
        pass

    def vowel_count(self):
        word = self.string
        count = dict.fromkeys('aeiou', 0)

        for letter in word.lower():
            if letter in count.keys():
                print(letter, sum(count.values()))
                count[letter] += 1

        return sum(count.values())

class Smaller(Words):
    def __init__(self,a):
        super.__init__()
        self.string=a

    def display(self):
        print("The type of Name is smaller")

    def evaluate(self):
        ans= self.vowel_count()

        # YOUR CODE GOES HERE
        print(ans)

class Larger(Words):
    def __init__(self,a):
        super().__init__()
        self.string=a

    def display(self):
        print("The type of Name is larger")

    def evaluate(self):
        ans = self.vowel_count()
        ans = len(self.string) - ans
        # YOUR CODE GOES HERE
        print(ans)

def main(a):
    '''
    input a is string
    '''
    if len(a)<6:
        obj=Smaller(a)
        obj.display()
        obj.evaluate()
    else:
        obj=Larger(a)
        obj.display()
        obj.evaluate()

a = 'asasaada'
main(a)
#%%
