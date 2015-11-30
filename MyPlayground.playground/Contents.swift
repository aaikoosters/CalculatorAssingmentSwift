//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var test: Double = 1.0
var tal1: Double
var test2: String = "1.0"
var test3: String = "+ 2"
var test4: String = "2"


let dec1 = NSNumberFormatter().numberFromString(test2)!.doubleValue
//let dec2 = NSNumberFormatter().numberFromString(test3)!.doubleValue
let dec3 = NSNumberFormatter().numberFromString(test4)!.doubleValue
test = dec1
tal1 = dec3
let opt = test * tal1 - tal1 - tal1 *  tal1
print(opt)

let myString = String(test)

let http404Error = (404, "Not Found")
print("The status code is \(http404Error.0)")
// prints "The status code is 404"
print("The status message is \(http404Error.1)")
// prints "The status message is Not Found'
let (_, justTheStatusCode) = http404Error
print("The status code is \(justTheStatusCode)")
// prints "The status code is 404'

private var opStack = Array<String>()
opStack.append("1")
opStack.append("2")
opStack.append("3")
opStack.append("4")
opStack.append("5")
opStack.append("6")
opStack.append("7")

for index in opStack {
    print(index)
}


print(opStack)