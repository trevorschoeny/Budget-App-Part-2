//
//  NewBudget.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import Foundation

struct NewBudget {
   var balance = NumbersOnly()
   var budgetAmount = NumbersOnly()
   var extraAmount = NumbersOnly()
   var name: String?
   var notes: String?
   var onDashboard = false
   var periods: [Date]?
   var userOrder: Int16 = 1000
   
   mutating func reset() {
      balance = NumbersOnly()
      budgetAmount = NumbersOnly()
      extraAmount = NumbersOnly()
      name = nil
      notes = nil
      onDashboard = false
      periods = nil
      userOrder = 1000
   }
}
