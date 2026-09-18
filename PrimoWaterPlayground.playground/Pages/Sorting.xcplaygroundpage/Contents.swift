//: [Previous](@previous)

import Foundation


var myArr = [33,11,4,14, 7]








func insertionSort(array: inout [Int]) {
    
    for index in 1..<array.count {
        var key = array[index]
        var previousIndex = index-1
        
        while previousIndex >= 0 && array[previousIndex] > key {
            array[previousIndex+1] = array[previousIndex]
            previousIndex -= 1
        }
        array[previousIndex+1] = key
    }
}




insertionSort(array: &myArr)

print("  \n\n    ******* Final array: \(myArr) ")
























/*
func sortBubble(array: inout [Int]) {
    var count = array.count
    for i in 0..<count {
        for j in 0..<count-1-i {
            if array[j] > array[j+1] {
                array.swapAt(j, j+1)
            }
        }
    }
}

*/




