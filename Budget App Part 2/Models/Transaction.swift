//
//  Transaction.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import Foundation

class Transaction: Identifiable, Decodable {
   
   var id: UUID?
   var description: String
   var account: String
   var debit: Bool
   var amount: Double
   var date: String
   var notes: String

}
