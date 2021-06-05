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
                  Text(budget.date!, style: .date)
                     .foregroundColor(.gray)
               }
               .font(.footnote)
            }
            .padding(.vertical, 5.0)
            
            // MARK: Balance & Budget Amount
            HStack {
               Spacer()
               VStack {
                  if budget.balance < 0 {
                     Text("($" + String(budget.balance) + ")")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                  }
                  else if budget.balance == 0 {
                     Text("$" + String(abs(budget.balance)))
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                  }
                  else if budget.balance <= (budget.budgetAmount * 0.25) {
                     Text("$" + String(abs(budget.balance)))
                        .foregroundColor(.orange)
                        .fontWeight(.semibold)
                  }
                  else if budget.balance <= (budget.budgetAmount * 0.5) {
                     Text("$" + String(abs(budget.balance)))
                        .foregroundColor(.yellow)
                        .fontWeight(.semibold)
                  }
                  else {
                     Text("$" + String(abs(budget.balance)))
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                  }
                  HStack(spacing: 0) {
                     Text(" left of ")
                        .foregroundColor(.gray)
                        .font(.body)
                        .offset(y: 1.3)
                     Text("$" + String(budget.budgetAmount))
                        .foregroundColor(.gray)
                        .font(.title2)
                  }
               }
               .font(.largeTitle)
               .padding(.vertical)
               Spacer()
            }
            NavigationLink(destination: PeriodsView(budget: budget, periodArr: budget.periods ?? [Date()])) {
               Text("Periods History")
            }
            
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
         .listStyle(InsetGroupedListStyle())
         
         // MARK: New Period
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
         .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Would you like to start a new period for " + budget.name! + "?"),
                  primaryButton: .default(Text("Yes")) {
                     budget.balance = budget.budgetAmount
                     budget.periods?.append(Date())
                     budgetModel.saveData()
                  },
                  secondaryButton: .cancel())
         })
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Budget")
      .popover(isPresented: self.$showingPopover, content: {
         EditBudgetView(oldBudget: $oldBudget, newBudget: $newBudget, inputBudget: $budget)
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
      oldBudget.name = budget.name
      oldBudget.notes = budget.notes
      oldBudget.periods = budget.periods
      oldBudget.userOrder = budget.userOrder
      
      // New Budget
      newBudget.notes = budget.notes
      newBudget.periods = budget.periods
      newBudget.userOrder = budget.userOrder
   }
}

struct BudgetDetailView_Previews: PreviewProvider {
   static var previews: some View {
      BudgetDetailView(budget: BudgetEntity())
   }
}
