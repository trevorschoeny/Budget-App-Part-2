//
//  TransactionListView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct TransactionListView: View {
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   var body: some View {
      NavigationView {
         List {
            ForEach(model.savedEntities) { t in
               NavigationLink(
                  destination: TransactionDetailView(transaction: t),
                  label: {
                     // MARK: Row Item
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
                  })
            }
            .onDelete(perform: { indexSet in
               updateAccountBalance(indexSet: indexSet)
               model.deleteTransaction(indexSet: indexSet)
            })
         }
         //.listStyle(PlainListStyle())
         .navigationBarTitle("All Transactions")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         NewTransactionView()
      })
   }
   private var addButton: some View {
           switch editMode {
           case .inactive:
            return AnyView(
               Button(action: {
                  showingPopover = true
               }, label: {
                  Image(systemName: "plus")
               })
            )
           default:
               return AnyView(EmptyView())
           }
       }
   private func updateAccountBalance(indexSet: IndexSet) {
      for i in accountModel.savedEntities {
         if model.savedEntities[indexSet.first ?? 0].account == i.name {
            if !model.savedEntities[indexSet.first ?? 0].debit {
               i.balance += model.savedEntities[indexSet.first ?? 0].amount
            } else {
               i.balance -= model.savedEntities[indexSet.first ?? 0].amount
            }
         }
      }
      accountModel.saveData()
   }
}



struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
         .environmentObject(TransactionModel())
    }
}
