//
//  FilteredTransactionListView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/3/21.
//

import SwiftUI

struct FilteredTransactionListView: View {
   @EnvironmentObject var transactionModel:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @EnvironmentObject var budgetModel:BudgetModel
   
   @State private var editMode = EditMode.inactive
   @State private var showingTransactionPopover = false
   @State private var showingFilterPopover = false
   @State var isSearching = false
   
   @State var searchInput = SearchParameters(firstDate: Date(), secondDate: Date())
   
   var body: some View {
      NavigationView {
         VStack {
            HStack() {
               SearchBarView(text: ($searchInput.text.bound), isSearching: $isSearching)
               Button(action: {
                  showingFilterPopover = true
               }, label: {
                  Text("Filter")
                     .padding(.trailing, 5.0)
               })
               .popover(isPresented: $showingTransactionPopover, content: {
                  NewTransactionView(isPopover: true)
               })
            }
            .padding(.vertical, 7.0)
            .padding(.horizontal)
            List {
               
               ForEach(transactionModel.savedEntities.filter{t in checkFilter(t: t)}) { t in
                  NavigationLink(
                     destination: TransactionDetailView(transaction: t),
                     label: {
                        TransactionListItemView(t: t)
                     })
               }
               .onDelete(perform: { indexSet in
                  delete(indexSet: indexSet)
               })
            }
            .navigationTitle("Transactions")
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .environment(\.editMode, $editMode)
         }
      }
      .popover(isPresented: $showingFilterPopover, content: {
         TransactionFilterView(searchInput: $searchInput)
      })
   }
   private var addButton: some View {
      switch editMode {
      case .inactive:
         return AnyView(
            Button(action: {
               showingTransactionPopover = true
            }, label: {
               Image(systemName: "plus")
            })
         )
      default:
         return AnyView(EmptyView())
      }
   }
   private func delete(indexSet: IndexSet) {
      
      let filteredTransactions = transactionModel.savedEntities.filter{t in checkFilter(t: t)}
      
      if filteredTransactions == [] {
         updateAccountBalance(index: indexSet.first ?? 0)
         updateBudgetBalance(index: indexSet.first ?? 0)
         transactionModel.deleteTransaction(index: indexSet.first ?? 0)
      } else {
         let filteredIndex = indexSet.first ?? 0
         var masterIndex: Int = 0
         for i in 0..<transactionModel.savedEntities.count {
            if filteredTransactions[filteredIndex] == transactionModel.savedEntities[i] {
               masterIndex = i
            }
         }
         updateAccountBalance(index: masterIndex)
         updateBudgetBalance(index: masterIndex)
         transactionModel.deleteTransaction(index: masterIndex)
      }
   }
   private func updateAccountBalance(index: Int) {
      for i in accountModel.savedEntities {
         if transactionModel.savedEntities[index].account == i.name {
            if !transactionModel.savedEntities[index].debit {
               i.balance += transactionModel.savedEntities[index].amount
            } else {
               i.balance -= transactionModel.savedEntities[index].amount
            }
         }
      }
      accountModel.saveData()
   }
   private func updateBudgetBalance(index: Int) {
      for i in budgetModel.savedEntities {
         if transactionModel.savedEntities[index].budget == i.name {
            i.balance += transactionModel.savedEntities[index].amount
         }
      }
      budgetModel.saveData()
   }
   func checkFilter(t: TransactionEntity) -> Bool {
      
      // Account
      if searchInput.account != nil && t.account != searchInput.account?.name {
         return false
      }
      // Budget
      if searchInput.debitToggle != "Debit" {
         if searchInput.budget != nil && t.budget != searchInput.budget?.name {
            return false
         }
      }
      // Debit
      if searchInput.debitToggle == "Credit" && t.debit {
         return false
      }
      // Credit
      if searchInput.debitToggle == "Debit" && !t.debit {
         return false
      }
      // Date & Date Range
      if searchInput.dateToggle {
         if !searchInput.dateRangeToggle {
            if !Calendar.current.isDate(searchInput.firstDate.startOfDay, inSameDayAs:t.date?.startOfDay ?? Date()) {
               return false
            }
         } else {
            if !(t.date ?? Date() >= searchInput.firstDate.startOfDay && t.date ?? Date() <= searchInput.secondDate.startOfDay) {
               return false
            }
         }
      }
      
      // Text & Notes
      let nameMatch = t.name?.lowercased().contains(searchInput.text?.lowercased() ?? "") ?? false
      let notesMatch = t.notes?.lowercased().contains(searchInput.text?.lowercased() ?? "") ?? false
      if (searchInput.text == nil || searchInput.text == "") {
         return true
      } else if nameMatch {
         return true
      } else if notesMatch {
         return true
      }
      return false
   }
}
struct FilteredTransactionListView_Previews: PreviewProvider {
   static var previews: some View {
      FilteredTransactionListView()
         .environmentObject(TransactionModel())
   }
}
