//
//  TransactionDetailView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct TransactionDetailView: View {
   var transaction:Transaction
   
    var body: some View {
      GeometryReader { geo in
         ScrollView {
            VStack(alignment: .leading) {
               
               // MARK: Description
               Text(transaction.description)
                  .font(.title3)
                  .fontWeight(.medium)
                  .foregroundColor(Color.black)
                  .padding(.top)
                  
               
               // MARK: Date
               Text(transaction.date)
                  .font(.title2)
                  .foregroundColor(Color.gray)
                  .padding(.bottom)
                  
               VStack {
                  VStack {
                     
                     // MARK: Amount
                     if transaction.debit {
                        Text("$" + String(transaction.amount))
                           .font(.largeTitle)
                           .fontWeight(.semibold)
                           .foregroundColor(Color.green)
                     }
                     else {
                        Text("($" + String(transaction.amount) + ")")
                           .font(.largeTitle)
                           .fontWeight(.semibold)
                           .foregroundColor(Color.red)
                     }
                     
                     // MARK: Account
                     if transaction.debit {
                        Text("to " + transaction.account)
                           .font(.title2)
                           .fontWeight(.light)
                           .foregroundColor(Color.green)
                     }
                     else {
                        Text("from " + transaction.account)
                           .font(.title2)
                           .fontWeight(.light)
                           .foregroundColor(Color.red)
                     }
                  }
                  .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                  .frame(width: geo.size.width-40)
                  .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
                  .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                  .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.3), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: -5, y: 5)
               }
               .padding(.bottom)
               .frame(width: geo.size.width-40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
               
               // MARK: Notes
               Text("Notes:")
                  .font(.title2)
                  .foregroundColor(Color.gray)
                  .padding(.bottom, 5.0)
                  
               Text(transaction.notes)
                  .foregroundColor(Color.gray)
               
               Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .padding(.horizontal, 20.0)
            .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
         }
         .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
      }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
      let model = TransactionModel()
      
      TransactionDetailView(transaction: model.transactions[2])
    }
}
