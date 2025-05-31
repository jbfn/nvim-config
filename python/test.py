class MyClass:
    other: str
    lst: list[str]

    def __init__(self, other: str):
        self.other = other
        self.lst = []
        other = self.other
        return self.other

    def thing(self):
        self.other
        return [i for i in self.lst]


thing = MyClass("")
