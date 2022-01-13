//
//  Double_Extension.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation
import UIKit

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
