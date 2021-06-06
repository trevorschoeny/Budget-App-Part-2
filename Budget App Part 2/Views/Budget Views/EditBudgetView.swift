//
//  EditBudgetView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import SwiftUI

struct EditBudgetView: View {
   
   @EnvironmentObject var transactionModel: TransactionModel
   @EnvironmentObject var budgetModel: BudgetModel
   @Binding var oldBudget: NewBudget
   @Binding var newBudget: NewBudget
   @Binding var inputBudget: BudgetEntity
   @State var diffStartBalance = true
   
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   @State var isExtraFunds: Bool
   
   var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField(oldBudget.name.bound, text: $newBudget.name.bound)
               
               // MARK: onDashboard
               Toggle("Include on Dashboard", isOn: $newBudget.onDashboard)
               
               
               // MARK: Budget Amount
               HStack {
                  Text("Budget: ")
                  Text("$ ")
                  TextField(oldBudget.budgetAmount.value, text: $newBudget.budgetAmount.value)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Balance
               HStack {
                  Text("Balance: ")
                  Text("$ ")
                  TextField(oldBudget.balance.value, text: $newBudget.balance.value)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Add Extra Funds?
               Toggle("Add Extra Funds? (For this period only)", isOn: $isExtraFunds)
               
               // MARK: Extra Funds
               if isExtraFunds {
                  HStack {
                     Text("Extra Funds: $ ")
                     TextField(oldBudget.extraAmount.value, text: $newBudget.extraAmount.value)
                        .keyboardType(.decimalPad)
                  }
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  TextEditor(text: $newBudget.notes.bound)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               newBudget.reset()
               newBudget.notes = oldBudget.notes
               newBudget.onDashboard = oldBudget.onDashboard
               newBudget.periods = oldBudget.periods
               newBudget.userOrder = oldBudget.userOrder
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newBudget.budgetAmount.value.filter({ $0 == "."}).count > 1 && newBudget.balance.value.filter({ $0 == "."}).count > 1{
                  showAlert = true
               }
               // Update Budget
               else {
                  budgetModel.updateBudget(budget: inputBudget, newBudget: newBudget, oldBudget: oldBudget, isExtraFunds: isExtraFunds)
                  updateNames()
                  oldBudget = newBudget
                  newBudget.reset()
                  newBudget.notes = oldBudget.notes
                  newBudget.onDashboard = oldBudget.onDashboard
                  newBudget.periods = oldBudget.periods
                  newBudget.userOrder = oldBudget.userOrder
                  self.isPresented.wrappedValue.dismiss()
               }
               
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Update")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entry"), message: Text("Please enter a valid input."), dismissButton: .default(Text("Ok")))
            })
         }
         .navigationTitle("Edit Budget")
      }
   }
   private func updateNames() {
      if newBudget.name != nil && newBudget.name != "" {
         for t in transactionModel.savedEntities {
            if t.budget == oldBudget.name {
               t.budget = newBudget.name
            }
         }
      }
   }
}

//struct EditBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBudgetView()
//    }
//}
