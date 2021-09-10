//
//  StatsController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 17/08/2021.
//

import UIKit
import CoreData
import Foundation

enum weekday: Int, CaseIterable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
}

class StatsController: UIViewController {
    @IBOutlet weak var day1OutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day2OutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day3OutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day4OutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day5OutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day6OutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day7OutHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var day1OutLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day2OutLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day3OutLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day4OutLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day5OutLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day6OutLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day7OutLabelBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var day1OutChartBar: WeekChartBarView!
    @IBOutlet weak var day2OutChartBar: WeekChartBarView!
    @IBOutlet weak var day3OutChartBar: WeekChartBarView!
    @IBOutlet weak var day4OutChartBar: WeekChartBarView!
    @IBOutlet weak var day5OutChartBar: WeekChartBarView!
    @IBOutlet weak var day6OutChartBar: WeekChartBarView!
    @IBOutlet weak var day7OutChartBar: WeekChartBarView!

    @IBOutlet weak var day1OutTotal: ChartBarLabel!
    @IBOutlet weak var day2OutTotal: ChartBarLabel!
    @IBOutlet weak var day3OutTotal: ChartBarLabel!
    @IBOutlet weak var day4OutTotal: ChartBarLabel!
    @IBOutlet weak var day5OutTotal: ChartBarLabel!
    @IBOutlet weak var day6OutTotal: ChartBarLabel!
    @IBOutlet weak var day7OutTotal: ChartBarLabel!

    @IBOutlet weak var day1OutLabel: UILabel!
    @IBOutlet weak var day2OutLabel: UILabel!
    @IBOutlet weak var day3OutLabel: UILabel!
    @IBOutlet weak var day4OutLabel: UILabel!
    @IBOutlet weak var day5OutLabel: UILabel!
    @IBOutlet weak var day6OutLabel: UILabel!
    @IBOutlet weak var day7OutLabel: UILabel!

    @IBOutlet weak var outChartStack: UIStackView!
    
    //--------------------------------------------------------
    
    @IBOutlet weak var day1InHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day2InHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day3InHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day4InHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day5InHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day6InHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var day7InHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var day1InLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day2InLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day3InLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day4InLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day5InLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day6InLabelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var day7InLabelBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var day1InChartBar: WeekChartBarView!
    @IBOutlet weak var day2InChartBar: WeekChartBarView!
    @IBOutlet weak var day3InChartBar: WeekChartBarView!
    @IBOutlet weak var day4InChartBar: WeekChartBarView!
    @IBOutlet weak var day5InChartBar: WeekChartBarView!
    @IBOutlet weak var day6InChartBar: WeekChartBarView!
    @IBOutlet weak var day7InChartBar: WeekChartBarView!
    
    @IBOutlet weak var day1InTotal: ChartBarLabel!
    @IBOutlet weak var day2InTotal: ChartBarLabel!
    @IBOutlet weak var day3InTotal: ChartBarLabel!
    @IBOutlet weak var day4InTotal: ChartBarLabel!
    @IBOutlet weak var day5InTotal: ChartBarLabel!
    @IBOutlet weak var day6InTotal: ChartBarLabel!
    @IBOutlet weak var day7InTotal: ChartBarLabel!
    
    @IBOutlet weak var day1InLabel: UILabel!
    @IBOutlet weak var day2InLabel: UILabel!
    @IBOutlet weak var day3InLabel: UILabel!
    @IBOutlet weak var day4InLabel: UILabel!
    @IBOutlet weak var day5InLabel: UILabel!
    @IBOutlet weak var day6InLabel: UILabel!
    @IBOutlet weak var day7InLabel: UILabel!
    
    @IBOutlet weak var inChartStack: UIStackView!
    
    
    var outBars: [WeekChartBarView] = []
    var inBars: [WeekChartBarView] = []
    var outBarHeightConstraints: [NSLayoutConstraint] = []
    var inBarHeightConstraints: [NSLayoutConstraint] = []
    var outBarLabelsBottomAnchors: [NSLayoutConstraint] = []
    var inBarLabelsBottomAnchors: [NSLayoutConstraint] = []
    var dayOutLabels: [UILabel] = []
    var dayInLabels: [UILabel] = []
    var outTransactions: [Transaction] = []
    var inTransactions: [Transaction] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = DateFormatter()
    
    var changed: Bool = false {
        didSet {
            print("CHANGED IN STATS")
            self.redrawChart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEE"
        
        outChartStack.translatesAutoresizingMaskIntoConstraints = false
        outChartStack.layoutIfNeeded()
        inChartStack.translatesAutoresizingMaskIntoConstraints = false
        inChartStack.layoutIfNeeded()
        
        dayOutLabels = [day1OutLabel, day2OutLabel, day3OutLabel, day4OutLabel, day5OutLabel, day6OutLabel, day7OutLabel]
        dayInLabels = [day1InLabel, day2InLabel, day3InLabel, day4InLabel, day5InLabel, day6InLabel, day7InLabel]
        
        day1OutChartBar.addSubview(day1OutTotal)
        day2OutChartBar.addSubview(day2OutTotal)
        day3OutChartBar.addSubview(day3OutTotal)
        day4OutChartBar.addSubview(day4OutTotal)
        day5OutChartBar.addSubview(day5OutTotal)
        day6OutChartBar.addSubview(day6OutTotal)
        day7OutChartBar.addSubview(day7OutTotal)
        
        day1InChartBar.addSubview(day1InTotal)
        day2InChartBar.addSubview(day2InTotal)
        day3InChartBar.addSubview(day3InTotal)
        day4InChartBar.addSubview(day4InTotal)
        day5InChartBar.addSubview(day5InTotal)
        day6InChartBar.addSubview(day6InTotal)
        day7InChartBar.addSubview(day7InTotal)
        
        outBars = [day1OutChartBar, day2OutChartBar, day3OutChartBar, day4OutChartBar, day5OutChartBar, day6OutChartBar, day7OutChartBar]
        inBars = [day1InChartBar, day2InChartBar, day3InChartBar, day4InChartBar, day5InChartBar, day6InChartBar, day7InChartBar]
        
        outBarHeightConstraints = [day1OutHeightConstraint, day2OutHeightConstraint, day3OutHeightConstraint, day4OutHeightConstraint, day5OutHeightConstraint, day6OutHeightConstraint, day7OutHeightConstraint]
        inBarHeightConstraints = [day1InHeightConstraint, day2InHeightConstraint, day3InHeightConstraint, day4InHeightConstraint, day5InHeightConstraint, day6InHeightConstraint, day7InHeightConstraint]
        
        outBarLabelsBottomAnchors = [day1OutLabelBottomAnchor, day2OutLabelBottomAnchor, day3OutLabelBottomAnchor, day4OutLabelBottomAnchor, day5OutLabelBottomAnchor, day6OutLabelBottomAnchor, day7OutLabelBottomAnchor]
        inBarLabelsBottomAnchors = [day1InLabelBottomAnchor, day2InLabelBottomAnchor, day3InLabelBottomAnchor, day4InLabelBottomAnchor, day5InLabelBottomAnchor, day6InLabelBottomAnchor, day7InLabelBottomAnchor]
        
        redrawChart()
    }
    
    func redrawChart() {
        let dateNoTime = calendar.startOfDay(for: Date())
        var fromDate = calendar.date(byAdding: .day, value: -6, to: dateNoTime)
        fromDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: fromDate ?? Date()))
        
        //get incoming transactions
        do {
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let datePredicate = NSPredicate(format: "date >= %@", fromDate! as NSDate)
            let incomingPredicate = NSPredicate(format: "incoming == NO")
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, incomingPredicate])
            request.sortDescriptors = [sortDescriptor]
            request.predicate = andPredicate
            outTransactions = try context.fetch(request)
        } catch {
            print("ERROR FETCHING OUT TRANSACTIONS")
        }
        
        //get outgoing transactions
        do {
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let datePredicate = NSPredicate(format: "date >= %@", fromDate! as NSDate)
            let incomingPredicate = NSPredicate(format: "incoming == YES")
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, incomingPredicate])
            request.sortDescriptors = [sortDescriptor]
            request.predicate = andPredicate
            inTransactions = try context.fetch(request)
        } catch {
            print("ERROR FETCHING IN TRANSACTIONS")
        }
        
        setupTotals(from: fromDate ?? Date())
    }
    
    func setupTotals(from: Date) {
        var filtered: [Transaction] = []
        var dayTotal: Double = 0.0
        var outTotals: [Int] = []
        var inTotals: [Int] = []
        
        //filter outgoing transactions
        for day in weekday.allCases {
            let workingDay: Date = calendar.date(byAdding: .day, value: day.rawValue, to: from) ?? Date()
            filtered = outTransactions.filter{calendar.isDate($0.date!, inSameDayAs: workingDay)}
            dayTotal = filtered.reduce(0) { $0 + $1.total }
            outTotals.append(Int(dayTotal))
            dayOutLabels[day.rawValue].text = dateFormatter.string(from: workingDay)
        }
        
        //filter incoming transactions
        for day in weekday.allCases {
            let workingDay: Date = calendar.date(byAdding: .day, value: day.rawValue, to: from) ?? Date()
            filtered = inTransactions.filter{calendar.isDate($0.date!, inSameDayAs: workingDay)}
            dayTotal = filtered.reduce(0) { $0 + $1.total }
            inTotals.append(Int(dayTotal))
            dayInLabels[day.rawValue].text = dateFormatter.string(from: workingDay)
        }
        
        setupBars(outTotals: outTotals, inTotals: inTotals)
    }
    
    func setupBars(outTotals: [Int], inTotals: [Int]) {
        let outMax: Int = outTotals.max() ?? 0
        let inMax: Int = inTotals.max() ?? 0
        
        var outHeights: [Int] = []
        var inHeights: [Int] = []
            
        for dayInTotal in outTotals {
            outHeights.append(Int(self.outChartStack.frame.height) * dayInTotal / (outMax == 0 ? 1 : outMax))
        }
        
        for dayOutTotal in inTotals {
            inHeights.append(Int(self.inChartStack.frame.height) * dayOutTotal / (inMax == 0 ? 1 : inMax))
        }
            
        var subviews: [UIView?] = []
        var workingLabel: UILabel = UILabel()
            
        for (index, bar) in self.outBars.enumerated() {
            outBarHeightConstraints[index].constant = CGFloat(outHeights[index])
            bar.layoutIfNeeded()
            
            subviews = bar.subviews.filter{ $0 is ChartBarLabel }
            workingLabel = subviews.first as! ChartBarLabel
            workingLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            workingLabel.text = outTotals[index].description
            
            let outLabelFits: Bool = outBarHeightConstraints[index].constant - 20 > workingLabel.intrinsicContentSize.height
            
            workingLabel.textColor = outLabelFits ? .white : .secondaryLabel
            outBarLabelsBottomAnchors[index].constant = outLabelFits ? -workingLabel.intrinsicContentSize.width / 2 + (outBarHeightConstraints[index].constant - workingLabel.intrinsicContentSize.height) : outBarHeightConstraints[index].constant + workingLabel.intrinsicContentSize.width / 2
        }
        
        for (index, bar) in self.inBars.enumerated() {
            inBarHeightConstraints[index].constant = CGFloat(inHeights[index])
            bar.layoutIfNeeded()
            
            subviews = bar.subviews.filter{ $0 is ChartBarLabel }
            workingLabel = subviews.first as! ChartBarLabel
            workingLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            workingLabel.text = inTotals[index].description
            
            let inLabelFits: Bool = inBarHeightConstraints[index].constant - 20 > workingLabel.intrinsicContentSize.height
            
            workingLabel.textColor = inLabelFits ? .white : .secondaryLabel
            inBarLabelsBottomAnchors[index].constant = inLabelFits ? -workingLabel.intrinsicContentSize.width / 2 + (inBarHeightConstraints[index].constant - workingLabel.intrinsicContentSize.height) : inBarHeightConstraints[index].constant + workingLabel.intrinsicContentSize.width / 2
        }
    }
}
