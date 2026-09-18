
/// How to create a custom type as a Sequence .... it allows your struct to be used in a FOR In loop
///


struct Player {
    var name: String
}

let p1 = Player(name: "jenna")
let p2 = Player(name: "salma")
let p3 = Player(name: "kim")
let p4 = Player(name: "malachi")
let p5 = Player(name: "carson")
let p6 = Player(name: "meena")
let p7 = Player(name: "robert")

var playerArray = [p1,p2,p3,p4,p5]


struct MyCollection {
    var items: [Player]
    
    mutating func append(_ item: Player) {
        self.items.append(item)
    }
}

extension MyCollection: Sequence {
    func makeIterator() -> MyIterator {
        return MyIterator(collection: self)
    }
}


struct MyIterator: IteratorProtocol {
    typealias Element = Player
    private var index = 0
    private let collection: MyCollection
    
    init(collection: MyCollection) {
        self.collection = collection
    }
    
    mutating func next() -> Player? {
        guard index < collection.items.count else {
            return nil
        }
        
        let element = collection.items[index]
            
        defer { index += 1}
        return element
    }
    
}







var sequence1 = MyCollection(items: playerArray)


for seq in sequence1 {
    print("I have \(seq.name)")
}

















/*

/// **********************************************************************************

struct Player {
    var name: String
}

let p1 = Player(name: "jenna")
let p2 = Player(name: "sally")
let p3 = Player(name: "kim")
let p4 = Player(name: "malachi")
let p5 = Player(name: "carson")



struct Database {
    var players: [Player] = [p1,p2,p3,p4,p5]
}


struct MySequence: Sequence {
    
    func makeIterator() -> MyIterator {
        return MyIterator()
    }
}




struct MyIterator: IteratorProtocol {
    typealias Element = Player
    private var index = 0
    private let database: Database
    
    init(database: Database = Database()) {
        self.database = database
    }
    
    mutating func next() -> Player? {
        guard index < database.players.count else {
            return nil
        }
        let element = database.players[index]
        defer { index += 1}
        return element
    }
    
}



var sequence1 = MySequence()


for seq in sequence1 {
    print("I have \(seq.name)")
}






*/


















/*
 struct Player {
     var name: String
 }


 struct JackSequence: Sequence {
     var data: [Player]
     
     func makeIterator() -> JackIterator {
         return JackIterator(data: data)
     }
 }




 struct JackIterator: IteratorProtocol {
     typealias Element = Player
     private var index = 0
     private let data: [Player]
     
     init(data: [Player]) {
         self.data = data
     }
     
     mutating func next() -> Player? {
         guard index < data.count else {
             return nil
         }
         let element = data[index]
         defer { index += 1}
         return element
     }
     
 }


 var arr = [Player(name: "a"), Player(name: "b"), Player(name: "c")]
 var a = JackSequence(data: arr)


 for jack in a {
     print("I have \(jack.name)")
 }

 




struct MySequence: Sequence {
    let count: Int

    func makeIterator() -> MySequenceIterator {
        return MySequenceIterator(limit: count)
    }
}


struct MySequenceIterator: IteratorProtocol {
    let limit: Int
    var current: Int = 0

    mutating func next() -> Int? {
        guard current < limit else { return nil }
        defer { current += 1 } // Move to the next number after returning
        return current
    }
}



var mySeq = MySequence(count: 5)

for i in mySeq {
    print(" I have \(i)")
}




*/
