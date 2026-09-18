
protocol Container {
    associatedtype Item
    
    mutating func append(_ item: Item)
}




struct MyStack<Element>: Container {
    
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    typealias Item = Element
    
    mutating func append(_ item: Element) {
        self.push(item)
    }
    
    
    
    
}





var stringStack = MyStack<String>()

stringStack.push("Hello")
stringStack.push("World")



print(stringStack)






var intStack = MyStack<Int>()

intStack.push(12)
intStack.push(18)

print(intStack)









/*


struct Stack<Element> {
    
    var items: [Element] = []
    
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        items.popLast()
    }
}




var intStack = Stack<Int>()

intStack.push(12)
intStack.push(16)
intStack.push(7)


print(intStack)




var stringStack = Stack<String>()

stringStack.push("Hello")
stringStack.push("World")
stringStack.push("This")
stringStack.push("Is")
stringStack.push("A")
stringStack.push("Test")


print(stringStack)  







/*

struct Stack<Element> {
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}



var stackOfStrings = Stack<String>()
var stackOfInt = Stack<Int>()

stackOfInt.push(21)

for i in stackOfInt.items{
    print(i)
}

*/




*/
