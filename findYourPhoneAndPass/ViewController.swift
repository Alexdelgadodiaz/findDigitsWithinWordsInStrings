//
//  ViewController.swift
//  findYourPhoneAndPass
//
//  Created by Alejandro Delgado Diaz on 13/06/2017.
//  Copyright © 2017 adelgadodiaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let service = ADDService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //fecthing phones and keywords from plist usuing ADDService to read the plist.
        let myArrayofPhones = service.fetchFromConfigListWithCode(code: "phoneNumbers")
        let myArrayOfKeywords = service.fetchFromConfigListWithCode(code: "keywords")
        print("Phones: ",  myArrayofPhones,  "Keywords: ",  myArrayOfKeywords)
        
        //EXAMPLE string to that could to check both numbers.
        let myString = "phone number 0034666554433 and codepass 1234567"
        print(myString)
        //split the string in words and set words in array
        let words = myString.components(separatedBy: " ")
        
        //dict with founded numbers. ["phone:0034222331122", "passcode":12345]
        let numbersFromExampleString = self.findpasscodesAndPhoneNumberInArray(arrayOfWords: words)
        
        //print if the phonenumbers is defined in the plist.
        if checkIfKnownPhoneNumber(numbersFromExampleString: numbersFromExampleString , numbersFromPlist: myArrayofPhones) {
            print("The phone number from the example string is a known number")

        }
    }
    
    //function to know if the phone given in the example string is part of the plist
    func checkIfKnownPhoneNumber(numbersFromExampleString: [String:String], numbersFromPlist:[String]) -> Bool {
      
        for phoneNumberInPlist in numbersFromPlist{
            for (key, value) in numbersFromExampleString {
                if (key == "phone" && (value.range(of: String(phoneNumberInPlist)) != nil)){
                    return true
                }
            }
        }
        return false
    }
    
    //returns the phones and passcodes founded in the example String.
    func findpasscodesAndPhoneNumberInArray(arrayOfWords:[String]) -> [String:String] {
        
        //call instance of service to fetch the min lenght of the value
        let minLengthKeycode = service.fetchIntFromConfigListWithCode(code: "minLenghtpasscodes")
        
        var phone : String = ""
        var passcode : String = ""
        
        for word in arrayOfWords {
            if word.containMoreDigitsThan(numbers: minLengthKeycode ){
                if word.characters.count < 9{ passcode = word }else{ phone = word}
            }
        }
        return ["phone":phone, "passcode":passcode]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension String {
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
    
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    //checks if the word contains more than X digits so we can differentiable
    //from words containing digits from words that not.
    func containMoreDigitsThan(numbers:Int) -> Bool {
        
        var digitCounter : Int = 0
        for (char) in self.characters.enumerated() {
            if  (char.element >= "0" && char.element <= "9") {
                digitCounter = digitCounter + 1
            }
        }
        return digitCounter >= numbers
    }
}
