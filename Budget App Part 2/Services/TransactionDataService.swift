//
//  TransactionDataService.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import Foundation

class TransactionDataService {
   
   static func getLocalData() -> [Transaction] {
      
      // Parse local json file
      
      // Get a url path to the json file
      let pathString = Bundle.main.path(forResource: "transactions", ofType: "json")
      
      // Check if pathString is not nil. Otherwise...
      guard pathString != nil else {
         return [Transaction]()
      }
      
      // Create a URL object
      let url = URL(fileURLWithPath: pathString!)
      
      do {
         // Create a data object
         let data = try Data(contentsOf: url)
         
         // Decode the data with a json decoder
         let decoder = JSONDecoder()
         
         do {
            let transactionData = try decoder.decode([Transaction].self, from: data)
            
            // Add a unique ID for transactions
            for t in transactionData {
               t.id = UUID()
            }
            
            // Return the transactions; SUCCESS!!
            return transactionData
         }
         catch {
            // Error with parsing json
            print(error)
         }
      }
      catch {
         // Error with getting data
         print(error)
      }
      
      return [Transaction]()
   }
   
}
