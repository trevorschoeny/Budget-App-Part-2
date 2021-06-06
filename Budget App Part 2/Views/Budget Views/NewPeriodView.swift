//
//  NewPeriodView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct NewPeriodView: View {
   
   @EnvironmentObject var budgetModel:BudgetModel
   @State var extraFunds = ExtraFunds()
   @State var inputBudget: BudgetEntity?
   @State var inputFunds: Double = 0
   
   @Environment(\.presentationMode) var isPresented

   
   var body: some View {
      NavigationView {
         VStack {
            List {
               VStack(alignment: .leading) {
                  HStack(spacing: 0) {
                     Text("You have ")
                     if inputFunds == 0 {
                        if extraFunds.total - extraFunds.fundNumArr.reduce(0, +) >= 0 {
                           Text("$" + String(extraFunds.total - extraFunds.fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.green)
                        } else {
                           Text("$" + String(extraFunds.total - extraFunds.fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.red)
                        }
                     } else {
                        if inputFunds - extraFunds.fundNumArr.reduce(0, +) >= 0 {
                           Text("$" + String(inputFunds - extraFunds.fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.green)
                        } else {
                           Text("$" + String(inputFunds - extraFunds.fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.red)
                        }
                     }
                     Text(" remaining funds.")
                  }
                  Text("Allocate them for the next period, or continue.")
                     .font(.footnote)
                     .foregroundColor(.gray)
               }
               ForEach (0..<budgetModel.savedEntities.count) { i in
                  HStack {
                     Text(budgetModel.savedEntities[i].name! + ": ")
                     Spacer()
                     Text("$")
                     TextField("0.00", text: $extraFunds.fundArr[i])
                        .keyboardType(.decimalPad)
                        .onChange(of: extraFunds.fundArr[i]) { _ in
                           extraFunds.fundNumArr[i] = Double(extraFunds.fundArr[i]) ?? 0.0
                        }
                     
                  }
               }
            }
            
            // MARK: Start New Period
            VStack {
               Button(action: {
                  if inputFunds == 0 {
                     for i in 0..<budgetModel.savedEntities.count {
                        budgetModel.savedEntities[i].extraAmount = Double(extraFunds.fundArr[i]) ?? 0.0
                        budgetModel.savedEntities[i].balance = budgetModel.savedEntities[i].budgetAmount + budgetModel.savedEntities[i].extraAmount
                        budgetModel.saveData()
                     }
                  } else {
                     for i in 0..<budgetModel.savedEntities.count {
                        if budgetModel.savedEntities[i].name == inputBudget?.name {
                           print("HERE 1")
                           print(budgetModel.savedEntities[i].extraAmount)
                           print(Double(extraFunds.fundArr[i]) ?? 0.0)
                           budgetModel.savedEntities[i].extraAmount = Double(extraFunds.fundArr[i]) ?? 0.0
                           budgetModel.savedEntities[i].balance = budgetModel.savedEntities[i].budgetAmount + budgetModel.savedEntities[i].extraAmount
                        } else {
                           print("HERE 2")
                           budgetModel.savedEntities[i].extraAmount += Double(extraFunds.fundArr[i]) ?? 0.0
                           budgetModel.savedEntities[i].balance += Double(extraFunds.fundArr[i]) ?? 0.0
                        }
                     }
                     budgetModel.saveData()
                  }
                  self.isPresented.wrappedValue.dismiss()
               }, label: {
                  ZStack {
                     Rectangle()
                        .font(.headline)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                        .frame(height: 55)
                        .cornerRadius(10)
                        .padding(.horizontal)
                     Text("Start New Period")
                        .font(.headline)
                        .foregroundColor(.white)
                  }
               })
               .padding(.bottom, 10)
            }
         }
         .navigationTitle("New Period")
      }
   }
}

//struct NewPeriodView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPeriodView()
//    }
//}
