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
   @State var filteredTransactions:[TransactionEntity] = []
   
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   @State var isSearching = false
   
   @State var searchText = ""
   @State var selectedAccount: AccountEntity?
   @State var selectedAccountName = ""
   @State var selectedBudget: BudgetEntity?
   @State var selectedBudgetName = ""
   
    var body: some View {
      NavigationView {
         List {
            HStack() {
               SearchBarView(text: $searchText, isSearching: $isSearching)
                  .onChange(of: searchText, perform: { value in
                     updateFilter()
                  })
               Menu("Filter") {
                  Button(action: {
                     selectedAccount = nil
                     selectedBudget = nil
                     selectedAccountName = ""
                     selectedBudgetName = ""
                     updateFilter()
                  }, label: {
                     Text("Clear Filter")
                        .foregroundColor(.red)
                  })
//                  Text("Account")
                  Picker(selection: $selectedAccount, label: Text("")) {
                     ForEach(accountModel.savedEntities) { a in
                        Text(a.name ?? "no name").tag(a as AccountEntity?)
                     }
                  }
                  .lineLimit(1)
                  .onChange(of: selectedAccount, perform: { value in
                     selectedAccountName = selectedAccount?.name ?? "no name"
                     updateFilter()
                  })
//                  .pickerStyle(WheelPickerStyle())
                  
//                  Text("Budget")
                  Picker(selection: $selectedBudget, label: Text("")) {
                     ForEach(budgetModel.savedEntities) { b in
                        Text(b.name ?? "no name").tag(b as BudgetEntity?)
                     }
                     .lineLimit(1)
                     .onChange(of: selectedBudget, perform: { value in
                        selectedBudgetName = selectedBudget?.name ?? "no name"
                        updateFilter()
                     })
                  }
               }
            }
            .padding(.vertical, 7.0)
            if searchText == ""  && selectedAccount == nil && selectedBudget == nil {
               ForEach(transactionModel.savedEntities) { t in
                  NavigationLink(
                     destination: TransactionDetailView(transaction: t),
                     label: {
                        TransactionListItemView(t: t)
                     })
               }
               .onDelete(perform: { indexSet in
                  updateAccountBalance(indexSet: indexSet)
                  updateBudgetBalance(indexSet: indexSet)
                  transactionModel.deleteTransaction(indexSet: indexSet)
               })
            } else {
               ForEach(filteredTransactions) { t in
                  NavigationLink(
                     destination: TransactionDetailView(transaction: t),
                     label: {
                        TransactionListItemView(t: t)
                     })
               }
               .onDelete(perform: { indexSet in
                  updateAccountBalance(indexSet: indexSet)
                  updateBudgetBalance(indexSet: indexSet)
                  transactionModel.deleteTransaction(indexSet: indexSet)
               })
            }
         }
         .listStyle(InsetGroupedListStyle())
         .navigationTitle("Transactions")
         .navigationBarItems(leading: EditButton()/*, trailing: addButton*/)
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
         if transactionModel.savedEntities[indexSet.first ?? 0].account == i.name {
            if !transactionModel.savedEntities[indexSet.first ?? 0].debit {
               i.balance += transactionModel.savedEntities[indexSet.first ?? 0].amount
            } else {
               i.balance -= transactionModel.savedEntities[indexSet.first ?? 0].amount
            }
         }
      }
      accountModel.saveData()
   }
   private func updateBudgetBalance(indexSet: IndexSet) {
      for i in budgetModel.savedEntities {
         if transactionModel.savedEntities[indexSet.first ?? 0].budget == i.name {
            i.balance += transactionModel.savedEntities[indexSet.first ?? 0].amount
         }
      }
      budgetModel.saveData()
   }
   private func updateFilter() {
      if searchText != "" && selectedAccount != nil && selectedBudget != nil {
         filteredTransactions = transactionModel.savedEntities.filter {
               $0.name!.lowercased().contains(searchText.lowercased())
               && $0.account!.contains(selectedAccountName)
               && $0.budget!.contains(selectedBudgetName)
         }
      } else if searchText != "" && selectedAccount != nil {
         filteredTransactions = transactionModel.savedEntities.filter {
               $0.name!.lowercased().contains(searchText.lowercased())
               && $0.account!.contains(selectedAccountName)
         }
      } else if searchText != "" && selectedBudget != nil {
         filteredTransactions = transactionModel.savedEntities.filter {
               $0.name!.lowercased().contains(searchText.lowercased())
               && $0.budget!.contains(selectedBudgetName)
         }
      } else if selectedAccount != nil && selectedBudget != nil {
         filteredTransactions = transactionModel.savedEntities.filter {
               $0.account!.contains(selectedAccountName)
               && $0.budget!.contains(selectedBudgetName)
         }
      } else if searchText != "" {
            filteredTransactions = transactionModel.savedEntities.filter {
                  $0.name!.lowercased().contains(searchText.lowercased())
            }
      } else if selectedAccount != nil {
         filteredTransactions = transactionModel.savedEntities.filter {
               $0.account!.contains(selectedAccountName)
         }
      } else if selectedBudget != nil {
         filteredTransactions = transactionModel.savedEntities.filter {
               $0.budget!.contains(selectedBudgetName)
         }
      }
   }
}

struct FilteredTransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredTransactionListView()
         .environmentObject(TransactionModel())
    }
}
