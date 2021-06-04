//
//  NewAccount.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/4/21.
//

import Foundation

struct NewAccount {
   var balance = NumbersOnly()
   var debit = true
   var name: String?
   var notes: String?
   
   mutating func reset() {
      balance.value = ""
      debit = true
      name = nil
      notes = nil
   }
}
