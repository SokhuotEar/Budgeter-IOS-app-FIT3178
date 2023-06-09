//
//  graphStructure.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 9/5/2023.
//

import Foundation

//  Source:
//  ChartUIView.swift
//  FIT3178-Week09-LabSolution
//
//

import SwiftUI
import Charts

/** the strct that aids with graphing*/
struct TransactionSummaryGraphStruct: Identifiable {
    var id = UUID()
    var categoryName: String
    var value: Double
    var budget: Double
}

/** chat ui view struct for grpahing for income or  spending summary*/
struct ChartUIView: View {
    var data: [TransactionSummaryGraphStruct]
    var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
            Chart(data) { categoryData in
                BarMark(x: .value("Category", categoryData.categoryName),
                        y: .value("Amount", categoryData.value))
                // set annotation for each bar grpah
                .annotation(content: {
                    Text(String(format: "%.2f", categoryData.value)).font(.headline)
                })
                
            }
            Spacer()
            // shows the list of data for each category at below the graph
            List(data) { datum in
                VStack(alignment: .leading)
                {
                    HStack {
                        Text("\(datum.categoryName)").bold()
                        Spacer()
                        // round the value
                        Text(String(format: "%.2f", datum.value)).font(.headline)
                    }
                }
                

            }
        }
    }
}

/** chat ui view struct for grpahing for cashflow summary*/
struct BudgetChartUIView: View {
    var data: [TransactionSummaryGraphStruct]
    var title: String

    // body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
            // chart
            Chart(data) { categoryData in
                BarMark(x: .value("Category", categoryData.categoryName),
                        y: .value("Amount", categoryData.value))
                .annotation(content: {
                    Text(String(format: "%.2f", categoryData.value)).font(.headline)
                })
            }.chartLegend(.visible)
            Spacer()
            Text("Summary").font(.title)
            Text("Red if cashflow target is not achieved").font(.footnote)
            
            // the list that shows the cash flow for each category
            List(data) { datum in
                VStack(alignment: .leading)
                {
                    // show category name
                    Spacer()
                    Text("\(datum.categoryName)").bold()
                    Spacer()
                    HStack {
                        Text("Budget")
                        Spacer()
                        Text(String(format: "%.2f", datum.budget)).font(.headline)
                    }
                    Spacer()
                    HStack {
                        // shows
                        if datum.value <= datum.budget
                        {
                            Text("Not Achieved")
                            Spacer()
                            // round the value
                            Text(String(format: "%.2f", datum.value)).font(.headline).foregroundStyle(.red)
                        }
                        else if datum.value <= datum.budget
                        {

                            Text("Achieved")
                            Spacer()
                            // round the value
                            Text(String(format: "%.2f", datum.value)).font(.headline).foregroundStyle(.green)
                        }
                    }
                    Spacer()
                }
            }

        }
    }
}









