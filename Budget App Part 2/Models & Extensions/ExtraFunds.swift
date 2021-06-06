//
//  ExtraFunds.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/6/21.
//

import Foundation

struct ExtraFunds {
   
   var budgetModel = BudgetModel()
   var total = 0.0
   var numBudgets = 0
   var fundArr: [String] = []
   var fundNumArr: [Double] = []
   
   init() {
      for b in budgetModel.savedEntities {
         total += b.balance
         numBudgets += 1
      }
      fundArr = [String](repeating: "", count: numBudgets)
      fundNumArr = [Double](repeating: 0, count: numBudgets)
   }
   
}
