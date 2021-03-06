//
//  BudgetDetailView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import SwiftUI

struct BudgetDetailView: View {
   
   @EnvironmentObject var budgetModel:BudgetModel
   @State var budget: BudgetEntity
   @State var oldBudget = NewBudget()
   @State var newBudget = NewBudget()
   
   @State var showingPopover = false
   @State var showingFundPopover = false
   @State var showAlert = false
   
   var body: some View {
      VStack {
         List {
            
            // MARK: Description
            VStack(alignment: .leading) {
               Text(budget.name ?? "No Name")
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               // MARK: Date
               HStack(spacing: 0) {
                  Text("Created on ")
                     .foregroundColor(.gray)
                  Text(budget.date ?? Date(), style: .date)
                     .foregroundColor(.gray)
               }
               .font(.footnote)
            }
            .padding(.vertical, 5.0)
            
            // MARK: Balance & Budget Amount
            BudgetBalanceView(budget: budget)
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if budget.notes != "" && budget.notes != nil {
                  Text(budget.notes ?? "")
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
         }
//         .popover(isPresented: self.$showingFundPopover, content: {
//            NewPeriodView(inputFunds: budget.balance)
//         })
         .listStyle(InsetGroupedListStyle())
         
         // MARK: New Period
         VStack {
            Button(action: {
               showAlert = true
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("New Period")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom, 10)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Would you like to start a new period for " + budget.name! + "?"),
                     primaryButton: .default(Text("Yes")) {
                        print("HERE")
                        showingFundPopover = true
                        showingPopover = true
                     },
                     secondaryButton: .cancel())
            })
         }
            
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Budget")
      .popover(isPresented: self.$showingPopover, content: {
         if showingFundPopover {
            NewPeriodView(inputBudget: budget, inputFunds: budget.balance)
               .onDisappear(perform: {
                  showingFundPopover = false
               })
         } else {
            EditBudgetView(oldBudget: $oldBudget, newBudget: $newBudget, inputBudget: $budget, isExtraFunds: !budget.extraAmount.isEqual(to: 0.0))
         }
      })
   }
   private var editButton: some View {
      Button(action: {
         prepareNewBudget()
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
   func prepareNewBudget() {
      
      // Old Budget
      oldBudget.balance.value = String(budget.balance)
      oldBudget.budgetAmount.value = String(budget.budgetAmount)
      oldBudget.date = budget.date ?? Date()
      oldBudget.extraAmount.value = String(budget.extraAmount)
      oldBudget.name = budget.name
      oldBudget.notes = budget.notes
      oldBudget.onDashboard = budget.onDashboard
      oldBudget.userOrder = budget.userOrder
      
      // New Budget
      newBudget.date = budget.date ?? Date()
      newBudget.notes = budget.notes
      newBudget.onDashboard = budget.onDashboard
      newBudget.userOrder = budget.userOrder
   }
}

struct BudgetDetailView_Previews: PreviewProvider {
   static var previews: some View {
      BudgetDetailView(budget: BudgetEntity())
   }
}
