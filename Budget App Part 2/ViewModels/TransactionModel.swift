//
//  TransactionModel.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import Foundation

class TransactionModel: ObservableObject {
   @Published var transactions = [Transaction]()
   
   init() {
      // we're going to turn getLocalData into a type method by adding the "static" keyword to it. This allows you to call the method without creating an instance of the class.
      self.transactions = TransactionDataService.getLocalData()
   }
}
