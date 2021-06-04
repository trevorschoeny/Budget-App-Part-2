//
//  TransactionFilterView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/3/21.
//

import SwiftUI

struct TransactionFilterView: View {
   @EnvironmentObject var transactionModel:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @EnvironmentObject var budgetModel:BudgetModel
   
   @Environment(\.presentationMode) var presentationMode
   
   @Binding var searchInput: SearchParameters
   @State var selectedAccount: AccountEntity?
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               
               // MARK: Filter by Date
               Toggle("Filter by Date", isOn: $searchInput.dateToggle)
               if searchInput.dateToggle {
                  Toggle("Filter by Date Range", isOn: $searchInput.dateRangeToggle)
                  DatePicker("Date: ", selection: $searchInput.firstDate, displayedComponents: .date)
                  if searchInput.dateRangeToggle {
                     DatePicker("Through: ", selection: $searchInput.secondDate, displayedComponents: .date)
                  }
               }
               
               // MARK: Filter by Credit/Debit
               Picker(selection: $searchInput.debitToggle, label: Text("Type")) {
                  Text("Credit").tag("Credit" as String?)
                  Text("Debit").tag("Debit" as String?)
               }
               .lineLimit(1)
               .pickerStyle(InlinePickerStyle())
               
               // MARK: Filter by Account
               Picker(selection: $searchInput.account, label: Text("Account")) {
                  ForEach(accountModel.savedEntities) { a in
                     Text(a.name ?? "no name").tag(a as AccountEntity?)
                  }
               }
               .lineLimit(1)
               .pickerStyle(InlinePickerStyle())
               
               // MARK: Filter by Budget
               if searchInput.debitToggle != "Debit" {
                  Picker(selection: $searchInput.budget, label: Text("Budget")) {
                     ForEach(budgetModel.savedEntities) { a in
                        Text(a.name ?? "no name").tag(a as BudgetEntity?)
                     }
                  }
                  .lineLimit(1)
                  .pickerStyle(InlinePickerStyle())
               }
            }
            
            // MARK: Clear Filter Button
            Button(action: {
               searchInput.reset()
               self.presentationMode.wrappedValue.dismiss()
            }, label: {
               Text("Clear Filter")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Ok Button
            Button(action: {
               self.presentationMode.wrappedValue.dismiss()
               
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(.blue)
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Ok")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
         }
         .navigationTitle("Filter")
      }
   }
}

//struct TransactionFilterView_Previews: PreviewProvider {
//   static var previews: some View {
//      TransactionFilterView()
//   }
//}
