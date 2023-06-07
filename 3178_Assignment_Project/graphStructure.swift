//
//  graphStructure.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 9/5/2023.
//

import Foundation

//
//  ChartUIView.swift
//  FIT3178-Week09-LabSolution
//
//  Created by Jason Haasz on 29/4/2023.
//

import SwiftUI
import Charts

struct TransactionSummaryGraphStruct: Identifiable {
    var id = UUID()
    var categoryName: String
    var value: Double
    var budget: Double
}


struct ChartUIView: View {
    var data: [TransactionSummaryGraphStruct]
    var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
            Chart(data) { categoryData in
                BarMark(x: .value("Category", categoryData.categoryName),
                        y: .value("Amount", categoryData.value))
                .annotation(content: {
                    Text(String(format: "%.2f", categoryData.value)).font(.headline)
                })
                
            }
            Spacer()
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

struct BudgetChartUIView: View {
    var data: [TransactionSummaryGraphStruct]
    var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
            Chart(data) { categoryData in
                BarMark(x: .value("Category", categoryData.categoryName),
                        y: .value("Amount", categoryData.value))
                .annotation(content: {
                    Text(String(format: "%.2f", categoryData.value)).font(.headline)
                })
            }.chartLegend(.visible)
            Spacer()
            Text("Summary").font(.title)
            Text("Red for overspending").font(.footnote)
            List(data) { datum in
                VStack(alignment: .leading)
                {
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

                        if datum.value > datum.budget
                        {
                            Text("Overspend")
                            Spacer()
                            // round the value
                            Text(String(format: "%.2f", datum.value)).font(.headline).foregroundStyle(.red)
                        }
                        else if datum.value <= datum.budget
                        {

                            Text("Spending")
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









