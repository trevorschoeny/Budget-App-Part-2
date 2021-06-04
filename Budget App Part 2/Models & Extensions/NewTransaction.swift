//
//  NewTransaction.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/4/21.
//

import Foundation

struct NewTransaction {
   var account: AccountEntity?
   var amount = NumbersOnly()
   var budget: BudgetEntity?
   var date: Date
   var debit = false
   var name: String?
   var notes: String?
   
   mutating func reset() {
      account = nil
      amount.value = ""
      budget = nil
      date = Date()
      debit = false
      name = nil
      notes = nil
   }
}
