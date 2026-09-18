
/*

protocol AnyCellModel {
    static var identifier: String {get}
    static var defaultValue: String { get}
    static var isEditable: Bool { get }
}



extension AnyCellModel {
    
    static var identifier: String {
        return "JAcko"
    }
}




protocol Drivable {
    var speed: Int {get}
    var isDriving: Bool {get set}
    static var maxSpeed: Int { get }
}




protocol Loggable {
    static func log(message: String)
    
}

struct FileLogger: Loggable {
    static func log(message: String) {
        print("FileLogger: \(message)")
    }
}


struct ConsoleLogger: Loggable {
    static func log(message: String) {
        print("ConsoleLogger: \(message)")
    }
}



func processWithLogger(logerType: Loggable.Type, data: String) {
    logerType.log(message: data)
}


processWithLogger(logerType: ConsoleLogger.self, data: "sent to console log by jack")
processWithLogger(logerType: FileLogger.self, data: "sent by file logger")

*/


/*
 protocol Vehicle {
     static var numberOfWheels: Int { get }
     static func startEngine()
     func drive()
 }



 struct Car: Vehicle {
     static var numberOfWheels: Int { return 4 }
     static func startEngine() {
         print("Car engine started.")
     }
     func drive() {
         print("Driving the car.")
     }
 }

 struct Bicycle: Vehicle {
     static var numberOfWheels: Int { return 2 }
     static func startEngine() {
         print("Bicycle has no engine to start.")
     }
     func drive() {
         print("Riding the bicycle.")
     }
 }





 // Function accepting a protocol metatype
 func describeVehicleType(type: Vehicle.Type) {
     print("This vehicle type has \(type.numberOfWheels) wheels.")
     type.startEngine()
 }



 // Using the function with concrete type metatypes
 describeVehicleType(type: Car.self)
 describeVehicleType(type: Bicycle.self)



 // Example of storing a protocol metatype in a variable
 let someVehicleType: Vehicle.Type = Car.self
 print("Stored vehicle type has \(someVehicleType.numberOfWheels) wheels.")
 someVehicleType.startEngine()

 */









 protocol Loggable {
     var name: String {get}
     func log(message: String)
     static func notify(message: String)
 }


 struct ConsoleLogger: Loggable {
     var name: String
     
     func log(message: String) {
         print("ConsoleLogger mesage: \(message)")
     }
     
     static func notify(message: String) {
         print("ConsoleLogger STATIC mesage: \(message)")
     }
 }




 struct FileLogger: Loggable {
     var name: String
     
     func log(message: String) {
         print("FileLogger message: \(message)")
     }
     
     static func notify(message: String) {
         print("ConsoleLogger STATIC mesage: \(message)")
     }
 }





 func process(logger: Loggable, msg: String) {
     logger.log(message: msg)
 }



 func process(logger: Loggable.Type, msg: String) {
     logger.notify(message: msg)
 }



 let c1 = ConsoleLogger(name: "jolly")

 let f1 = FileLogger(name: "sheena")


 process(logger: c1, msg: "Message using an instance of Logable")

 print("****************")

 process(logger: FileLogger.self, msg: "using file logger Type")


 
