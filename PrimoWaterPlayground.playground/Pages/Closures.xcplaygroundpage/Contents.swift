



func makeIncrementer(input: Int) -> (() -> Int) {
    
    var total = input
    
    return {
        total += 1
        return total
    }
    
}


let incr: (() -> Int) = makeIncrementer(input: 7)



print(incr())
print(incr())











/*

func makeIncrementer(amount: Int) -> () -> Int {
    
    var runningTotal: Int = 0
    
    
    func incrementer() -> Int {
        runningTotal += amount
        print("will return \(runningTotal)")
        return runningTotal
    }
    
    return incrementer
}






let incrementer = makeIncrementer(amount: 10)

incrementer()


incrementer()

incrementer()



*/









/*
func process<T>(clo: () -> T) -> T {
    clo()
}



let x = process() {
    return 11
}

print(x)



let y = process() {
    return 17
}

print(y)

let z = process() {
    return "beem"
}

print(z)


*/











/*
//// AUTO CLOSURE example
func printTest(_ result: @autoclosure () -> Void) {
    print("Before....")
    result()
    print("after....")
}



printTest(print("jack result"))

*/








/*
/// ESCAPING closures
var closures: [() -> Int] = []


@MainActor
func doThis( clo: @escaping () -> Int) {
    closures.append(clo)
}




doThis() { return 11 }
doThis() { return 15 }
doThis() { return 23 }


for i in closures {
    let num = i()
    print("this one value is \(num)")
}

*/










/*
func adder(input: Int) ->  Int {
    return input + 1
}


func reduce(input: Int) ->  Int {
    return input - 1
}



func process(moveBack: Bool) -> (Int) -> Int {
    if moveBack {
        return reduce
    }else{
        return adder
    }
}

let f = process(moveBack: true)

let result = f(5)
print(result)

*/




/*
func process(num1: Int, num2: Int, handler: (Int, Int) -> Int) ->  Int {
    
    /// here, we call the closure. NOTE: we cannot use argument names here
    return handler(num1, num2)
    
}


/// here, we define the closure code and we can use parameter names
let result = process(num1: 5, num2: 10) { (a: Int, b: Int) -> Int in
    return a + b
    
}


print(result)
*/
