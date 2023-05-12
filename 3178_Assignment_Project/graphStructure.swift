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
}


struct ChartUIView: View {
    var data: [TransactionSummaryGraphStruct]
    
    var body: some View {
        Chart(data) { categoryData in
            BarMark(x: .value("Category", categoryData.categoryName),
                    y: .value("Amount", categoryData.value))

        }
    }
}


