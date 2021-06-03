//
//  NumbersOnly.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/3/21.
//

import Foundation

class NumbersOnly: ObservableObject {
   @Published var value = "" {
      didSet {
         let filtered = value.filter { $0.isNumber || $0 == "." }
         if value != filtered {
             value = filtered
         }
      }
   }
}
