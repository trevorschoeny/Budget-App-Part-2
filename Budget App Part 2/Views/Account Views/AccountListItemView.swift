//
//  AccountListItemView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import SwiftUI

struct AccountListItemView: View {
   @ObservedObject var a: AccountEntity
    var body: some View {
      NavigationLink(
         destination: AccountDetailView(account: a),
         label: {
            HStack {
               VStack(alignment: .leading) {
                  Text(a.name ?? "No Name")
                  HStack {
                     if a.debit {
                        Text("Debit Account")
                     } else {
                        Text("Credit Account")
                     }
                  }
                  .foregroundColor(.gray)
                  .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
               }
               Spacer()
               if a.balance >= 0 {
                  Text("$" + String(a.balance) )
                     .foregroundColor(.green)
                     .padding(.trailing)
               }
               else {
                  Text("($" + String(abs(a.balance)) + ")")
                     .foregroundColor(.red)
                     .padding(.trailing)
               }
            }
         })
    }
}

//struct AccountListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//      AccountListItemView(a: $AccountEntity())
//    }
//}
