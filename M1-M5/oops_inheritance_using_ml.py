class MachineLearning:
    def __init__(self,name,category):
        # self.name=name
        # self.category=category

    def getname(self):
        return self.name

    def getcategory(self):
        return self.category

    def print(self):
        print("Name:",self.name)
        print("Category:",self.category)

class Supervised(MachineLearning):
    def __init__(self,name,category):
        super.__init__()
        self.name=name
        self.category=category

    def type(self):
        self.print()
        print('Supervised Learning Algorithm')

class Unsupervised(MachineLearning):
    def __init__(self,name,category):
        super.__init__()
        self.name=name
        self.category=category

    def type(self):
        self.print()
        print('Unsupervised Learning Algorithm')

def mlAnalogy(a,b,c,d):
    '''
    input=> a,b = name and category for Supervised class
            c,d = name and category for Unsupervised class
    output=> type() is called for both classes in the end, it should first print the Name and Category then the type of class in new lines
    '''

    obj1=Supervised(a,b)
    obj1.type()
    obj2=Unsupervised(c,d)
    obj2.type()

    return None
