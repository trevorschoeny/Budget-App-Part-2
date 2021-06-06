//
//  NewAccount.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/4/21.
//

import Foundation

struct NewAccount {
   var balance = NumbersOnly()
   var date = Date()
   var debit = true
   var isCurrent = true
   var name: String?
   var notes: String?
   var onDashboard = false
   var userOrder: Int16 = 1000
   
   mutating func reset() {
      balance = NumbersOnly()
      date = Date()
      debit = true
      isCurrent = true
      name = nil
      notes = nil
      onDashboard = false
      userOrder = 1000
      
   }
}
