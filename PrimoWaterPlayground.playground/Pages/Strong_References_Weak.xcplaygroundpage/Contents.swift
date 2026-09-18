

class Person {
    var name: String
    var apt: Apartment
    
    init(name: String, apt: Apartment) {
        self.name = name
        self.apt = apt
        print("\(name) is being initialized")
    }
    
    deinit  {
        print("\(name) is being deinitialized")
    }
    
    
}


class Apartment {
    var unit: Int
    var tenant: Person
    init(unit: Int, tenant: Person) {
        self.unit = unit
        self.tenant = tenant
        print("Apt \(unit) is being initialized")
    }
    
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}





var apt: Apartment = Apartment(unit: 1, tenant: Person(name: "Alice",apt: apt))
var bob: Person = Person(name: "Bob",apt: apt)



bob.apt = apt         // apt count 1
apt.tenant = bob        // Bob count NOT INCREMENTED


print("....will set to nil")
//bob = nil        // reduce apt count to ZERO
//apt = nil


