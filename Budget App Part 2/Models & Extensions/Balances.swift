//
//  Balances.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import Foundation

class Balances: ObservableObject {
   
   var accountModel = AccountModel()
   
   var totalBalance = 0.0
   var totalAssets = 0.0
   var totalLiabilities = 0.0
   var currentAssets = 0.0
   var currentLiabilities = 0.0
   var currentBalance = 0.0
   
   init() {
         for a in accountModel.savedEntities {
            totalBalance += a.balance
            if a.balance > 0 {
               totalAssets += a.balance
            } else {
               totalLiabilities += a.balance
            }
            if a.isCurrent {
               currentBalance += a.balance
               if a.balance > 0 {
                  currentAssets += a.balance
               } else {
                  currentLiabilities += a.balance
               }
            }
         }
   }
   
}
