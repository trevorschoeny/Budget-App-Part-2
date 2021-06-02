//
//  TransactionDetailView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct TransactionDetailView: View {
   var transaction:TransactionEntity
   
   var body: some View {
      GeometryReader { geo in
         VStack(alignment: .leading, spacing: 0.0) {
            List {
               
               VStack {
                  // MARK: Amount
                  if transaction.debit {
                     Text("$" + String(transaction.amount))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text("($" + String(transaction.amount) + ")")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                  }
                  
                  // MARK: Account
                  if transaction.debit {
                     Text("to " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text("from " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(Color.red)
                  }
               }
               .padding(.vertical)
               .frame(width: geo.size.width-80)
               
               // MARK: Description
               Text(transaction.name ?? "No Name")
                  .font(.title2)
                  .foregroundColor(Color.black)
               
               // MARK: Date
               HStack {
                  Text("Date: ")
                     .foregroundColor(Color.black)
                  Spacer()
                  Text(transaction.date?.addingTimeInterval(0) ?? Date(), style: .date)
                     .foregroundColor(Color.gray)
               }
               
               
               
               // MARK: Budget
               HStack {
                  Text("Budget: ")
                     .foregroundColor(Color.black)
                  Spacer()
                  Text(transaction.budget ?? "No Budget")
                     .foregroundColor(Color.gray)
               }
               
               // MARK: Notes
               HStack {
                  Text("Notes:")
                     .foregroundColor(Color.black)
                  Spacer()
                  if transaction.notes == "" {
                     Text("No Notes")
                        .foregroundColor(Color.gray)
                  }
                  else {
                     Text(transaction.notes ?? "No Notes")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                  }
               }
            }
            .listStyle(InsetGroupedListStyle())
            .lineLimit(5)
         }
         
         
      }
   }
}

struct TransactionDetailView_Previews: PreviewProvider {
   static var previews: some View {
      let model = TransactionModel()
      
      TransactionDetailView(transaction: model.savedEntities[0])
   }
}
