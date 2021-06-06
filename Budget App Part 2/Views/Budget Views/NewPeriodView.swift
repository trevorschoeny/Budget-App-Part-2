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
   @State var remainingTotal: Double = 0
   
   @Environment(\.presentationMode) var isPresented
   
   init() {
      remainingTotal = extraFunds.fundNumArr.reduce(0, +)
   }
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               Text("You have $" + String(extraFunds.total - remainingTotal) + " remaining funds. Allocate them elsewhere for the next period, or continue.")
               ForEach (0..<budgetModel.savedEntities.count) { i in
                  HStack {
                     Text(budgetModel.savedEntities[i].name! + ": ")
                     Spacer()
                     Text("$")
                     TextField("0.00", text: $extraFunds.fundArr[i])
                        .keyboardType(.decimalPad)
                        .onTapGesture {
                           let d: Double = Double(extraFunds.fundArr[0]) ?? 0.0
                           extraFunds.fundNumArr[0] = d
                        }
                     
                  }
               }
//               .onChange(of: $extraFunds.fundArr) { _ in
//                  let x = 0
//               }
            }
            
            // MARK: Start New Period
            VStack {
               Button(action: {
                  for i in 0..<budgetModel.savedEntities.count {
                     budgetModel.savedEntities[i].extraAmount = Double(extraFunds.fundArr[i]) ?? 0.0
                     budgetModel.savedEntities[i].balance = budgetModel.savedEntities[i].budgetAmount + budgetModel.savedEntities[i].extraAmount
                     budgetModel.savedEntities[i].periods?.append(Date())
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
