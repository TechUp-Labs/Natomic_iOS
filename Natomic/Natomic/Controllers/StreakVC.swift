//
//  StreakVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 17/04/24.
//

import UIKit

class StreakVC: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var streakLbl: UILabel!
    @IBOutlet weak var daysFinishedLbl: UILabel!
    @IBOutlet weak var totalNubOfNotesLbl: UILabel!
    @IBOutlet weak var streakNameLbl: UILabel!
    
    var selectedDate = Date()
    var totalSqaures = [String]()
    var totalDaysFinished = Int()
    var userData : [UserEntity]?
    var streak = DatabaseManager.Shared.calculateStreak()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        streakLbl.text = "\(streak) day streak"
        let fullName = USER_NAME
        let firstName = fullName.components(separatedBy: " ").first ?? ""

        streakNameLbl.text = "You are doing really great, \(firstName) !"
        calendarCollectionView.registerCell(identifire: "CalendarCell")
//        setCellsView()
        configureCellSize()
        setMonthView()
        monthLbl.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        calendarCollectionView.reloadData()
        calendarCollectionView.layoutIfNeeded()
        calendarHeight.constant = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height + 50
        self.view.layoutIfNeeded()
//        setUserData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.userInterfaceIdiom == .phone {
            configureCellSize() // Ensures that the layout is updated based on the current view size
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            coordinator.animate(alongsideTransition: { _ in
                self.configureCellSize()
                self.calendarCollectionView.reloadData()
            }, completion: nil)
        }
    }


    
    func setUserData(){
        self.userData = DatabaseManager.Shared.getUserContext()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Combine date and time in a single format

        self.userData?.sort { (entity1, entity2) in
            if let dateTime1 = dateFormatter.date(from: "\(entity1.date ?? "") \(entity1.time ?? "")"),
               let dateTime2 = dateFormatter.date(from: "\(entity2.date ?? "") \(entity2.time ?? "")") {
                return dateTime1 > dateTime2
            }
            return false // Return false as a fallback
        }
    }
    func cellsPerRow() -> CGFloat {
        // Check the device type and orientation
        let deviceIsTablet = UIDevice.current.userInterfaceIdiom == .pad
        let orientationIsLandscape = UIDevice.current.orientation.isLandscape
        
        if deviceIsTablet {
            return orientationIsLandscape ? 4 : 4  // More cells in landscape
        } else {
            return orientationIsLandscape ? 7 : 7  // Same number for simplicity, adjust as needed
        }
    }

    func configureCellSize() {
        let numberOfCellsPerRow = cellsPerRow()
        let flowLayout = calendarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpacing = flowLayout.sectionInset.left + // left margin
                           flowLayout.sectionInset.right + // right margin
                           flowLayout.minimumInteritemSpacing * (numberOfCellsPerRow - 1) // space between cells

        let width = (calendarCollectionView.bounds.width - totalSpacing) / numberOfCellsPerRow
        let height = width  // Adjust if a different height is needed

        flowLayout.itemSize = CGSize(width: width, height: height)
        calendarCollectionView.collectionViewLayout = flowLayout
        calendarHeight.constant = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height + 50
    }


    
//    func setCellsView(){
//        let width = (calendarCollectionView.frame.size.width) / 7
//        let height = (calendarCollectionView.frame.size.width) / 7
//        
//        let flowLayout = calendarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.itemSize = CGSize(width: width, height: height)
//    }
    
    func setMonthView() {
        totalSqaures.removeAll()
        
        let calendarHelper = CalendarHelper()
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        let calendar = Calendar.current
        
        while (count <= daysInMonth + startingSpaces) {
            if count <= startingSpaces {
                totalSqaures.append("")
            } else {
                let dayOffset = count - startingSpaces - 1
                let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonth)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-M-d" // Adjust the format as needed.
                let dateString = dateFormatter.string(from: currentDate)
                totalSqaures.append(dateString)
            }
            count += 1
        }
        
        monthLbl.text = calendarHelper.monthString(date: selectedDate) + " " + calendarHelper.yearString(date: selectedDate)
        let totalNotesAdded = DatabaseManager.Shared.countNotesInMonth(monthYear: calendarHelper.monthString(date: selectedDate) + " " + calendarHelper.yearString(date: selectedDate))
        totalNubOfNotesLbl.text = String(totalNotesAdded)
        calendarCollectionView.reloadData()
    }

    
    override open var shouldAutorotate: Bool
    {
        return false
    }

    @IBAction func closeBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .closeStreakScreenButtonClick)
        self.dismiss(animated: true)
    }
    
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .previousMonthButtonTapped)

        totalDaysFinished = 0
        daysFinishedLbl.text = String(totalDaysFinished)
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
//        UIView.animate(withDuration: 0.5) { [self] in
            calendarHeight.constant = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height + 50
//            view.layoutIfNeeded()
//        }

    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .nextMonthButtonTapped)
        totalDaysFinished = 0
        daysFinishedLbl.text = String(totalDaysFinished)
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
//        UIView.animate(withDuration: 0.5) { [self] in
            calendarHeight.constant = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height + 50
//            view.layoutIfNeeded()
//        }
    }
}

extension StreakVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSqaures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        let dateString = totalSqaures[indexPath.item]
        if dateString.isEmpty {
            cell.dayOfMonthLbl.text = ""
            cell.dayBGView.isHidden = true
            cell.streackImg.isHidden = true
        } else {
            if DatabaseManager.Shared.isDateExist(totalSqaures[indexPath.item]){
                totalDaysFinished += 1
                daysFinishedLbl.text = String(totalDaysFinished)
                cell.streackImg.isHidden = false
                cell.dayBGView.isHidden = true
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-M-d"
                if let date = dateFormatter.date(from: dateString) {
                    let dayFormatter = DateFormatter()
                    dayFormatter.dateFormat = "d" // Use "dd" if you want to include leading zeros
                    cell.dayOfMonthLbl.text = dayFormatter.string(from: date)
                    cell.dayBGView.isHidden = false
                    cell.streackImg.isHidden = true
                }

            }

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TrackEvent.shared.track(eventName: .dateSelection)
    }
    
}
