//
//  TransactionListItemView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/3/21.
//

import SwiftUI

struct TransactionListItemView: View {
   
   @State var t: TransactionEntity
   var body: some View {
      VStack(alignment: .leading) {
         Text(t.name ?? "no name")
            .font(.title3)
            .lineLimit(1)
         HStack(spacing: 0) {
            Text(t.date?.addingTimeInterval(0) ?? Date(), style: .date)
               .font(.callout)
               .fontWeight(.light)
               .foregroundColor(Color.gray)
            Text(" • ")
               .font(.callout)
               .fontWeight(.light)
               .foregroundColor(Color.gray)
            if !t.debit {
               Text("($\(String(t.amount)))")
                  .font(.callout)
                  .fontWeight(.light)
                  .foregroundColor(Color.red)
            } else {
               Text(String(t.amount))
                  .font(.callout)
                  .fontWeight(.light)
                  .foregroundColor(Color.green)
            }
            Text(" • ")
               .font(.callout)
               .fontWeight(.light)
               .foregroundColor(Color.gray)
            Text(t.account ?? "no account")
               .font(.callout)
               .fontWeight(.light)
               .foregroundColor(Color.gray)
               .lineLimit(1)
         }
      }
   }
}

struct TransactionListItemView_Previews: PreviewProvider {
   static var previews: some View {
      TransactionListItemView(t: TransactionEntity())
   }
}
