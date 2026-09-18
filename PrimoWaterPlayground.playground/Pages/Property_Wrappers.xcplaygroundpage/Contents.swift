

/*
/// Option I

@propertyWrapper struct BankBalance {
    private var amount: Int
    private var minimumBal: Int
    
    var wrappedValue: Int {
        get {return amount}
        set {amount  = max(newValue, minimumBal) }
    }
    
    init(wrappedValue: Int) {
        print("Jack: executing init(wrappedValue: Int) for a")
        minimumBal = 100
        amount = max(wrappedValue, minimumBal)
    }
    
} //end struct


/// Struct
struct SavingAccount {
    /// no default values for minimum and balance
    @BankBalance var balance: Int
    var name: String
    var age: Int
}


var a = SavingAccount(balance: 370, name: "Barbara", age: 22)
print("a balance: \(a.balance)")




/// Option II

@propertyWrapper struct BankBalance2 {
    private var amount: Int
    private var minimumBal: Int
    
    var wrappedValue: Int {
        get {return amount}
        set {amount  = max(newValue, minimumBal) }
    }
    
    init(wrappedValue: Int) {
        print("Jack: executing init(wrappedValue: Int) for b")
        minimumBal = 100
        amount = max(wrappedValue, minimumBal)
    }
    
    init(minimum: Int) {
        print("Jack: executing init(minimum: Int) for b")
        minimumBal = minimum
        amount = minimum
    }
    
} //end struct




/// Struct
struct SavingAccount2 {
    /// here, we're passing in  a default minimum balance amount. the init(minimum: Int) is called here.
    @BankBalance2(minimum: 150) var balance: Int
    var name: String
    var age: Int
}

// don't add balance here because the other initializer was called above when property was specified in struct above
var b = SavingAccount2(name: "Barbara", age: 22)
print("b balance: \(b.balance)")












/// OPTION III

 @propertyWrapper struct BankBalance3 {
     private var amount: Int
     private var minimumBal: Int
     
     var wrappedValue: Int {
         get {return amount}
         set {amount  = max(newValue, minimumBal) }
     }
     
     init(wrappedValue: Int) {
         print("Jack: init with wrappedValue ...")
         minimumBal = 100
         amount = max(wrappedValue, minimumBal)
     }
     
     init(minimum: Int) {
         minimumBal = minimum
         amount = minimum
     }
     
     init(wrappedValue: Int, minimum: Int) {
         print("Jack: executing init(wrappedValue: Int, minimum: Int) for c")
         minimumBal = minimum
         amount = max(wrappedValue, minimum)
     }
    
     
     /// ******** DO NOT USE Initializer format below ***************************
     //    init() {
     //        minimumBal = 100
     //        amount = 100
     //    }
         
 } //end struct





 
 struct SavingAccount3 {
     /// pass  default values for minimum and balance (Note: wrappedValue is same as balance )
     @BankBalance3(wrappedValue: 475, minimum: 200) var balance: Int
     var name: String
     var age: Int
 }

 var c = SavingAccount3(name: "Barbara", age: 22)
print("c balance: \(c.balance)")


 
/// ========= Output =====================
/*
 Jack: executing init(wrappedValue: Int) for a
 a balance: 370
 Jack: executing init(minimum: Int) for b
 b balance: 150
 Jack: executing init(wrappedValue: Int, minimum: Int) for c
 c balance: 475
 */




*/





/*

/// NOTE: we use the didSet option to set. This is not a computed property (regular stored property)

@propertyWrapper struct Capitalized {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.uppercased()
        }
    }
    
    init(wrappedValue: String) {
        print("Jack: init for Capitalized struct .... value: \(wrappedValue)")
        self.wrappedValue = wrappedValue.uppercased()
    }
    
}


struct User {
    @Capitalized var fName: String
}

struct User2 {
    @Capitalized var fName: String = "jacko"
}

struct User3 {
    @Capitalized var lastName: String
    var age: Int
}




var u1 = User(fName: "dfdf")  /// this calls init(wrappedValue: String)
var u2 = User2()  /// this calls init(wrappedValue: String)
var u3 = User3(lastName: "york", age: 34) //this calls init(wrappedValue: String)


print(u1.fName)
print(u2.fName)
print(u3.lastName)

*/
