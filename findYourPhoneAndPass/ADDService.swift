//
//  ADDService.swift
//  findYourPhoneAndPass
//
//  Created by Alejandro Delgado Diaz on 13/06/2017.
//  Copyright © 2017 adelgadodiaz. All rights reserved.
//

import Foundation

class ADDService {
    
    public func fetchFromConfigListWithCode(code:String) -> [String]{
        
        var myArray:[String]
        
        if let path = Bundle.main.path(forResource: "configList", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                myArray = (dict[code] as? [String])!
                return myArray
            }
        }
        return []
    }
    
    public func fetchIntFromConfigListWithCode(code:String) -> Int{
        
        if let path = Bundle.main.path(forResource: "configList", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return  (dict[code] as? Int)!
            }
        }
        return 0
    }
}
