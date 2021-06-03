//
//  searchParameters.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/3/21.
//

import Foundation

struct SearchParameters {
   var text: String?
   var account: AccountEntity?
   var budget: BudgetEntity?
   var firstDate: Date
   var secondDate: Date
   var debitToggle: String?
   var dateToggle = false
   var dateRangeToggle = false
   
   mutating func reset() {
      text = nil
      account = nil
      budget = nil
      firstDate = Date()
      secondDate = Date()
      debitToggle = nil
      dateToggle = false
      dateRangeToggle = false
   }
}
