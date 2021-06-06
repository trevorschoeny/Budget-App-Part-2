//
//  NewBudgetView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/2/21.
//

import SwiftUI

struct NewBudgetView: View {
   
   @EnvironmentObject var budgetModel: BudgetModel
   @State var newBudget = NewBudget()
   
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   @State var diffStartBalance = false
   
   var body: some View {
      NavigationView {
         VStack {
            
            Form {
               Toggle("Include on Dashboard", isOn: $newBudget.onDashboard)
               // MARK: Name
               TextField("Add budget name here...", text: $newBudget.name.bound)
               
               // MARK: Budget Amount
               HStack {
                  Text("$ ")
                  TextField("Budget Amount", text: $newBudget.budgetAmount.value)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Different Starting Balance?
               Toggle("Custom Starting Balance?", isOn: $diffStartBalance)
               
               // MARK: Balance
               if diffStartBalance {
                  HStack {
                     Text("$ ")
                     TextField("Starting Balance", text: $newBudget.balance.value)
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
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newBudget.name == "" || newBudget.name == nil ||  newBudget.budgetAmount.value.filter({ $0 == "."}).count > 1 {
                  showAlert = true
               }
               // Save Account
               else {
                  budgetModel.addBudget(newBudget: newBudget, diffStartBalance: diffStartBalance)
                  newBudget.reset()
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
                  Text("Add")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entry"), message: Text("Please enter a valid input."), dismissButton: .default(Text("Ok")))
            })
         }
         .navigationTitle("Add Budget")
      }
   }
}

struct NewBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewBudgetView()
    }
}
