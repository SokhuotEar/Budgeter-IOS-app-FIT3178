//
//  OverviewViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 11/5/2023.
//

import UIKit

class OverviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBAction func nextMonthButtonAction(_ sender: Any) {
        // Get the current month from the label text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        guard let currentMonth = monthLabel.text, let date = dateFormatter.date(from: currentMonth) else {
            return
        }
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)
        
        // Update the label text with the new month value
        if let nextMonth = nextMonth {
            let nextMonthString = dateFormatter.string(from: nextMonth)
            monthLabel.text = nextMonthString
        }
    }
    
    @IBAction func previousMonthButtonAction(_ sender: Any) {
        // Get the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        guard let currentMonth = monthLabel.text, let date = dateFormatter.date(from: currentMonth) else {
            return
        }
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: -1, to: date)

        // Update the label text with the new month value
        if let nextMonth = nextMonth {
            let nextMonthString = dateFormatter.string(from: nextMonth)
            monthLabel.text = nextMonthString
        }
    }

   
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // date conversion
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"

        var components: DateComponents = DateComponents()
        if let date = dateFormatter.date(from: monthLabel.text ?? "") {
            let calendar = Calendar.current
            components = calendar.dateComponents([.month, .year], from: date)
        }
        
        if segue.identifier == "incomeOverviewSegue"
        {
            let destination = segue.destination as! IncomeSummaryViewController
            destination.monthYear = components
        }
    }
    

}
