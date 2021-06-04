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
      HStack {
         VStack(alignment: .leading) {
            Text(t.name ?? "no name")
               .lineLimit(1)
            Text(t.date?.addingTimeInterval(0) ?? Date(), style: .date)
               .font(.footnote)
               .foregroundColor(Color.gray)
         }
         Spacer()
         VStack(alignment: .trailing) {
            if !t.debit {
               Text("($\(String(t.amount)))")
                  .foregroundColor(Color.red)
            } else {
               Text(String(t.amount))
                  .foregroundColor(Color.green)
            }
            Text(t.account ?? "no account")
               .font(.footnote)
               .lineLimit(1)
         }
         .foregroundColor(Color.gray)
      }
   }
}

//struct TransactionListItemView_Previews: PreviewProvider {
//   static var previews: some View {
//      TransactionListItemView(t: $TransactionEntity())
//   }
//}
