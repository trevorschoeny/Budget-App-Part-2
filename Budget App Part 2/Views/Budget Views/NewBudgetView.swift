//
//  NewBudgetView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/2/21.
//

import SwiftUI

struct NewBudgetView: View {
   
   @EnvironmentObject var budgetModel: BudgetModel
   
   @Environment(\.presentationMode) var isPresented
   @State var selectedName = ""
   @State var showAlert = false
   @State var selectedAmount = NumbersOnly()
   
   var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField("Add budget name here...", text: $selectedName)
               
               HStack {
                  Text("$ ")
                  TextField("Budget Amount", text: $selectedAmount.value)
                     .keyboardType(.decimalPad)
                     .foregroundColor(Color.gray)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               selectedName = ""
               selectedAmount.value = ""
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if selectedName == "" || selectedAmount.value.filter({ $0 == "."}).count > 1 {
                  
                  showAlert = true
                  
               }
               // Save Account
               else {
                  budgetModel.addBudget(name: selectedName, budgetAmount: Double(selectedAmount.value) ?? 0.0)
                  selectedName = ""
                  selectedAmount.value = ""
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
