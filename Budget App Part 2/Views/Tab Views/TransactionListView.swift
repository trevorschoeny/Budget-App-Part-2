//
//  TransactionListView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct TransactionListView: View {
   @EnvironmentObject var model:TransactionModel
   
    var body: some View {
      NavigationView {
         List(model.transactions) { t in
            NavigationLink(
               destination: TransactionDetailView(transaction: t),
               label: {
                  // MARK: Row Item
                  VStack(alignment: .leading) {
                     Text(t.description)
                        .font(.title3)
                        .lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                     HStack(spacing: 0) {
                        Text(t.date)
                           .font(.callout)
                           .fontWeight(.light)
                           .foregroundColor(Color.gray)
                        Text(" • ")
                           .font(.callout)
                           .fontWeight(.light)
                           .foregroundColor(Color.gray)
                        if !t.debit {
                           Text("(")
                              .font(.callout)
                              .fontWeight(.light)
                              .foregroundColor(Color.gray)
                        }
                        Text("$" + String(t.amount))
                           .font(.callout)
                           .fontWeight(.light)
                           .foregroundColor(Color.gray)
                        if !t.debit {
                           Text(")")
                              .font(.callout)
                              .fontWeight(.light)
                              .foregroundColor(Color.gray)
                        }
                        Text(" • ")
                           .font(.callout)
                           .fontWeight(.light)
                           .foregroundColor(Color.gray)
                        Text(t.account)
                           .font(.callout)
                           .fontWeight(.light)
                           .foregroundColor(Color.gray)
                           .lineLimit(1)
                     }
                  }
               })
         }
         .navigationBarTitle("All Transactions")
      }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
         .environmentObject(TransactionModel())
    }
}
