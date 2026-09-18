
import Foundation
import Observation
import PlaygroundSupport
import UIKit



enum MyError: Error {
    case noData
    case noConnection
}







func fetchImage(url: String) async throws -> UIImage {
    guard let url = URL(string: url) else {
        throw MyError.noConnection
        
    }
    let (data,_) = try await URLSession.shared.data(from: url)
    if let img = UIImage(data: data) {
        return img
    }
    throw MyError.noData
}

func getAllImages() async throws -> [UIImage] {
    
    
    let urls: [String] = ["https://hws.dev/img/logo.png",
                          "https://hws.dev/paul2.jpg",
                          "https://www.gstatic.com/webp/gallery/1.jpg",
                          "https://picsum.photos/id/237/200/300"
    ]
        
    return try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self)  { group in
        
        for url in urls {
            group.addTask {
                try await fetchImage(url: url)
            }
        }
        
        var myImages: [UIImage] = []
        for try await result in group {
            myImages.append(result)
        }
        return myImages
        
    }
    
}




Task {
    do {
        let images = try await getAllImages()
        print("we have \(images.count)   images")
    }catch {
        print("we have error \(error)")
    }
}
























/*
 
 
 
 
 
 
 
func fetchImage(url: String) async throws -> UIImage? {
    guard let url = URL(string: url) else {
        return nil
        
    }
    let (data,_) = try await URLSession.shared.data(from: url)
    if let img = UIImage(data: data) {
        return img
    }
    return nil
}


Task {
    do {
        async let one = fetchImage(url: "https://hws.dev/img/logo.png")
        async let two =  fetchImage(url: "https://hws.dev/paul2.jpg")
        async let three = fetchImage(url: "https://www.gstatic.com/webp/gallery/1.jpg")
        async let four = fetchImage(url: "https://picsum.photos/id/237/200/300")
        
        let final = try await (one, two, three, four)
        
    }catch {
        print("we haev an error \(error)")
        
        
    }
}

*/



















/*

@propertyWrapper struct Capitalized {
    
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.uppercased() }
    }
    
    func reset() {
       // wrappedValue = ""
        print("I ma in reset")
    }
}




struct User {
    @Capitalized var name: String
    
//    init(rawValue: String) {
//        self._name = Capitalized(wrappedValue: rawValue)
//    }
}





let user = User(name: "jenny1")
print(user.name)


*/










/*
protocol Grouping<Item> {
    associatedtype Item
    
    var items: [Item] { get set}
    
    mutating func append(_ item: Item)
}



struct Player: Grouping<String> {
    var items: [String] = ["d","h"]
    
    mutating func append(_ item: String) {
        self.items.append(item)
    }
}



func process() -> some Grouping<String> {
    let a = Player()
    return a
}


*/







/*
protocol Container<Item> {
    associatedtype Item
    
    mutating func append(_ item: Item)
}




struct MyStack<Element>: Container {
    
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        self.items.append(item)
    }

    typealias Item = Element
    
    mutating func append(_ item: Element) {
        self.push(item)
    }
}







struct Jack {
    var name = "jack"
    
    
    func process() -> any Container {
        let stringStack = MyStack<String>(items: ["d","s","y"])
        return stringStack
    }
    
} //end struct





let j1 = Jack(name: "helene")



let cont1 = j1.process()


*/














/*


protocol Fighter {
    associatedtype Item
    
}


struct XWing: Fighter { typealias Item = String}


struct YWing: Fighter {typealias Item = String }



func launchFighter() -> some Fighter {
    //return XWing()
     return YWing()
}






func test() {
    let red5 = launchFighter()
    if let r = red5 as? XWing {
        print("yes")
    }else{
        print("no")
    }
}




test()


*/







/*

protocol Container {
    associatedtype Item
    var items: [Item] { get set}
    mutating func append(_ item: Item)
}



struct StringContainer: Container {
    typealias Item = String
    var items: [String] = ["g","d","p"]
    
    mutating func append(_ item: String) {
        self.items.append(item)
    }
}


struct IntContainer: Container {
    typealias Item = Int
    var items: [Int] = []
    
    mutating func append(_ item: Int) {
        self.items.append(item)
    }
}






struct Player {
    
    var id: Int = 1
    var team: String = "dolphins"
    
    func makeContainer() -> any Container {
        return StringContainer()
    }
    
}






let player1 = Player()
let cont1 = player1.makeContainer()

print("resuklt is \(cont1.items)")



*/






/*

class Vehicle {
    var speed: Int = 0
    
    init(speed: Int){
        print("INIT Vehicle")
        self.speed = speed
        
        print("Customize Vehcile")
        self.speed = 50
    }
    
    init(){
        
    }
    
    deinit {
        print("deinit Vehicle")
    }
    
    
    func updateSpeed(){
        self.speed = 100
    }
    
    
    func updateSpeed(speed: Int){
        self.speed = speed
    }
    
}



class Bicycle: Vehicle {
    var hasBasket: Bool = false
    var wheels: Int
    
    init(hasBasket: Bool, wheels: Int) {
        print("INIT Bicycle")
        self.hasBasket = hasBasket
        self.wheels = wheels
        
        super.init(speed: 20)
        
        print("customize Bicycle")
        self.speed = 77
    }
    
    deinit {
        print("deinit Bicycle")
    }
    
}



class BsaSlr: Bicycle {
    var color: String
    var price: Int
    
    init(color: String, price: Int) {
        print("INIT BSA Slr")
        self.color = color
        self.price = price
        
        super.init(hasBasket: false, wheels: 2)
        
        print("customize BSA")
        self.wheels = 4
        self.hasBasket =  true
    }
    
    
    convenience init(tyres: Int) {
        self.init(color: "green", price: tyres/2)
    }
    
    
    
    deinit {
        print("deinit BsaSLR")
    }
    
    
    override func updateSpeed(){
        super.updateSpeed()
        self.hasBasket = false
    }
    
    
    
}

//
//var a: BsaSlr?
//a = BsaSlr(tyres: 8)
//print("the final res is   speed: \(a?.speed) ")
//
//a?.updateSpeed()
//print("the new speed is: \(a?.speed) basket: \(a?.hasBasket)")
//a = nil



var b: Bicycle?

b = Bicycle(hasBasket: true, wheels: 3)



b?.updateSpeed()

print("Bicycle - speed: \(b?.speed)")


*/










/*

class SimpleClass {
    var value: Int = 0
    
    init(value: Int) {
        self.value = value
    }
    
}





var x = SimpleClass(value: 11)





let explicitClosure = { [x] in
    print("Explicit: \(x.value)")
}




let implicitClosure = {
    print("Implicit: \(x.value)")
}



explicitClosure()
implicitClosure()


x = SimpleClass(value: 33)

print(" ===================== ")

explicitClosure()

implicitClosure()






//x.value = 44
//explicitClosure()
//implicitClosure()



*/






















/*
class SimpleClass {
    var value: Int = 0
}


let x = SimpleClass()
let y = SimpleClass()

let clo = {
    print(x.value, y.value)
}



x.value = 10
y.value = 10



clo()


*/









/*
var a: Int = 0
var b: Int = 0


let clo = { [a] in
    print(a, b)
}


a = 15
b = 15



clo()

*/






/*

class HTMLElement {
    var name: String
    var text: String?
    
   
    
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }
    
    lazy var asHTML: () -> String =  { [unowned self] in
        if let text = self.text {
            return "<br>Yes</br>"
        }else{
            return "<br>No</br>"
        }
    }
    
    
    
    deinit {
        print("Class is getting deinitialized ....")
    }
    
}



var para: HTMLElement? = HTMLElement(name: "forma", text: "this is Atalna")


print(para!.asHTML())
para = nil


*/














/*
class Country {
    var name: String
    var capital: City!
    
    init(name: String, capitalName: String) {
        self.name = name
        self.capital = City(name: "India", country: self)
    }
    
    deinit{
        print("country is being deinitailized ...")
    }
    
}


class City {
    var name: String
    unowned var country: Country
    
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    
    deinit{
        print("city is being deinitailized ...")
    }
}


var italy: Country?
var norway: Country?


let india = Country(name: "India", capitalName: "delhi")

italy = Country(name: "Italy", capitalName: "rome")
norway = Country(name: "Norway", capitalName: "oslo")

let florence = City(name: "Florence", country: italy ?? india)
let bergen = City(name: "Bergen", country: norway ?? india)


*/




















/*


class Pokemon {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

var activePokemon = Pokemon(name: "Pikachu", age: 10)


// Explicit: Snapshots 'activePokemon' pointing to Pikachu immediately
let explicitClosure = { [activePokemon] in
    print("Explicit: \(activePokemon.name) age: \(activePokemon.age)")
}

// Implicit: Captures the 'activePokemon' variable by reference
let implicitClosure = {
    print("Implicit: \(activePokemon.name) age: \(activePokemon.age)")
}

// Mutate the outer variable reference
activePokemon = Pokemon(name: "Charizard", age: 22)

explicitClosure() // Prints: "Explicit: Pikachu"
implicitClosure()



*/






/*



class SimpleClass {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}


var x = SimpleClass(value: 14)


let explicitClosure = { [x] in
    print("Explicit: \(x.value)")
}


let implicitClosure = {
    print("Implicit: \(x.value)")
}


explicitClosure() // prints 14


x = SimpleClass(value: 77) // new object assigned to x ( Explicit will stil point to old object)


implicitClosure()   // print 77

explicitClosure()       // prints 14


//print(isKnownUniquelyReferenced(&x))
//print(isKnownUniquelyReferenced(&y))


*/










/*
@Observable final class ContentViewModel: Sendable {
    var value: Int  = 0
}


func startContinuousObservation(model: ContentViewModel) {
    withObservationTracking {
        // Access properties here to track them
        print("current val is \(model.value)")
    } onChange: {
        Task { @MainActor in
            print("value changed to \(model.value)")
            startContinuousObservation(model: model)
        }
    }
}



class ValueObserver {
    var model: ContentViewModel
    
    @MainActor init(model: ContentViewModel) {
        self.model = model
        startContinuousObservation(model: model)
    }
    
} // end class


let obs = ValueObserver(model: ContentViewModel())

 
 obs.model.value = 101
 Thread.sleep(forTimeInterval: 5)
 obs.model.value = 39
 Thread.sleep(forTimeInterval: 5)
 obs.model.value = 45






let model = ContentViewModel()

startContinuousObservation(model: model)

model.value = 33

model.value = 44


*/











/*

public func withObservationTracking<T: Sendable>(of value: @Sendable @escaping @autoclosure () -> T, execute: @Sendable @escaping (T) -> Void) {
    
    Observation.withObservationTracking {
        execute(value())
    } onChange: {
        //Runloop.current.perform {
            //withObservationTracking(of: value(), execute: execute)
            Task{ @MainActor in
                print("value changed")
                withObservationTracking(of: value(), execute: execute)
            }
       //}
    }
}



class ValueObserver {
    var model: ContentViewModel
    
    @MainActor init(model: ContentViewModel) {
        self.model = model
        withObservationTracking(of: model.value, execute:  {
            print($0)
        })
    }
    
} // end class



PlaygroundPage.current.needsIndefiniteExecution = true




let obs = ValueObserver(model: ContentViewModel())

Thread.sleep(forTimeInterval: 3)
obs.model.value = 22
Thread.sleep(forTimeInterval: 3)
obs.model.value = 34
Thread.sleep(forTimeInterval: 4)
obs.model.value = 46


 */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/*
@Observable final class User: Sendable {
    var name: String = "Paula"
    var age: Int = 28
}


    

final class Coord: Sendable {
    let user = User()
    
    func startTracking() {
        withObservationTracking {
            print("current name is \(user.name)")
        } onChange: {
            print("  val is about to change")
            self.startTracking()
        }
    }
}




let c1 = Coord()
c1.startTracking()



c1.user.name = "Mega"

c1.user.name = "Noni"



*/





















/*
enum MyError: Error {
    case badUrl
    case noNetwork
}




func doSomething() async throws -> String? {
    print("starting func ...")
    do {
        throw MyError.badUrl
    }catch{
        print("I caught an error ...")
        test()
    }
    print("I am at bottom ... returning nil")
    return nil
}



func test() {
    print("I am in test")
}




let a = try await doSomething()

print("a is \(a)")


*/



/*
@propertyWrapper struct Balance {
    private var minimum: Int
    private var balance: Int
    
    /// computed property
    var wrappedValue: Int {
        get{
            return balance
        }
        set{
            print("setting balance to \(newValue)")
            balance = min(newValue, minimum)
        }
    }
    
    /// initializer using min value
    init(min: Int) {
        print("init(min) called ...")
        minimum = min
        balance = min
    }
    
    /// initializer using min value and balance value
    init(minVal: Int, wrappedValue: Int) {
        print("init(min, wrappedValue) called ...")
        minimum = minVal
        balance = min(wrappedValue, minVal)
    }
    
    /// initializer using just balance value
    init(wrappedValue: Int) {
        print("init(wrapppedValue) called ... value: \(wrappedValue)")
        minimum = 100
        balance = min(wrappedValue, minimum)
    }

}



// in the options below, aside from the initializer for struct, which init version s called in struct Balance

// Option 1
struct MyAccount {
    @Balance var bal: Int
    var name: String
}

/// here, struct MyStruct uses its initalizer to init name ... then calls initializer from struct Balance.
print(" -- will create a new MyAccount -- ")
var acct = MyAccount(bal: 3400, name: "jenny") //init(wrapppedValue) called ... value: 3400



//Option 2

struct MyAccount2 {
    @Balance(min: 350) var bal: Int
    var name: String
}

/// in this case, MyAccount2 uses its initializer to init name .... then calls initializer from struct Balance
print(" -- will create a new MyAccount2 -- ")
var acct2 = MyAccount2(name: "pala")  //init(min) called ..





//Option 3

struct MyAccount3 {
    @Balance(minVal: 450, wrappedValue: 2200) var bal: Int
    var name: String
}

/// here, we pass in both min value and balance value ... which is same as wrapoped value
print(" -- will create a new MyAccount3 -- ")
var acct3 = MyAccount3(name: "pala") //init(min, wrappedValue) called ...





print(" ****************** ")
print(acct.bal)
print(" ****************** ")
print(acct2.bal)
print(" ****************** ")
print(acct3.bal)
print(" ****************** ")


*/
