//
//  Extensions.swift
//  Netflix clone
//
//  Created by Varun Bagga on 27/12/22.
//

import Foundation

extension String {
    func capitalizeFirstLetter()->String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
