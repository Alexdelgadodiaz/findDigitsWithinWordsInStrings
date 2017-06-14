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
        
        //fecthing phones and keywords from plist
        let myArrayofPhones = service.fetchFromConfigListWithCode(code: "phoneNumbers")
        let myArrayOfKeywords = service.fetchFromConfigListWithCode(code: "keywords")
        print("Phones: ",  myArrayofPhones,  "Keywords: ",  myArrayOfKeywords)
        
        
        let myString = "phone number 0034555663322 and code 1234567"
        let words = myString.components(separatedBy: " ")
        
        let myArray = self.findKeywordsAndPhoneNumberInArray(myArray: words)
        
        print(myArray)
        
    }
    
    func findKeywordsAndPhoneNumberInArray(myArray:[String]) -> [String:String] {
        
        //call instance of service to fetch the min lenght of the value
        let minLengthKeycode = service.fetchIntFromConfigListWithCode(code: "minLenghtKeywords")
        
        var phone : String = ""
        var keyword : String = ""
        
        for word in myArray {
            if word.containMoreDigitsThan(numbers: minLengthKeycode ){
                if word.characters.count < 9{ keyword = word }else{ phone = word}
            }
        }
        return ["phone":phone, "keyword":keyword]
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
