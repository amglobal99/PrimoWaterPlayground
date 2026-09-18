//: [Previous](@previous)



var arr = [3,5,7,10,14]  // lbound = 0   ubound = 4



func search(array: [Int], key: Int) -> Int? {
    
    var lbound = 0
    var ubound = array.count-1
    
    
    while lbound <= ubound {
        print("lbound: \(lbound)   ubound: \(ubound) ")
        let middle = (lbound + ubound)/2
        print("middle is \(middle) and key is \(key)")
        if array[middle] == key {
            print("middle \(middle) matches key \(key) ")
            return middle
        }else if array[middle] < key {
            lbound = middle + 1
            print("lbboud canged to \(lbound)")
        }else {
            ubound = middle - 1
            
        }
        
    }
    
    return nil
    
}







let soln = search(array: arr, key: 14)
print(soln)







/*
 func sortBinary(arr: [Int], key: Int) -> Int? {
     
     var lBound = 0
     var uBound = arr.count - 1
     
     while lBound <= uBound {
         print("lbound: \(lBound)   ubound: \(uBound) ")
         let middle = (lBound + uBound)/2  // ( 0+4)/2 = 2
         
         print("middle is \(middle) and key is \(key)")
         
         if arr[middle] == key {
             print("middle \(middle) matches key \(key) ")
             return middle
         }else if arr[middle] < key {
             lBound = middle + 1
             print("lbboud canged to \(lBound)")
         }else {
             uBound = middle - 1
             print("uboud canged to \(uBound)")
         }
     }
     
     
     
     return nil
 }

 */
