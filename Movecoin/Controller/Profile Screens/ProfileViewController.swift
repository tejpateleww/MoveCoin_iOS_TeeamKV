//
//  ProfileViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import TTSegmentedControl
import Kingfisher
import SwiftyJSON
import HealthKit

struct StepsCountDataEntry {
    var stepsCount : Double
    var stepsDate : Date
}

class ProfileViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet var viewSegmentedControl: UIView!
    @IBOutlet weak var btnMyFriends: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var lblTitleTotalMoveCoins: UILabel!
    @IBOutlet weak var lblTitleTotalSteps: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblTotalMoveCoins: UILabel!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var lblAverageSteps: UILabel!
    @IBOutlet weak var viewBarDetails: BasicBarChart!
    
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    private var imagePicker : ImagePickerClass!
    var selectedImage : UIImage?
    var isRemovePhoto = false
    var viewSegmentTT = TTSegmentedControl()
    
    var profileModel: profileDataResponseModel?
    lazy var dataEntries: [DataEntry] = []
    lazy var stepsDataEntry: [StepsCountDataEntry] = []
    
    let leftBarButton = BadgeBarButtonItem()
    var btnChat = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.setupFont()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationBarSetUp(hidesBackButton: true)
        webserviceForProfileData()
        //        setupProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpNavigationItems()
        localizationSetup()
//        setupSegmentedControl()
//        localizationSetup()
        //        localizeUI(parentView: self.viewParent)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.parent?.navigationItem.titleView = nil
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.rightBarButtonItems?.removeAll()
    }
   
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        
        lblTitleTotalSteps.font = UIFont.bold(ofSize: 13)
        lblTitleTotalMoveCoins.font = UIFont.bold(ofSize: 13)
        
        btnMyFriends.titleLabel?.font = UIFont.bold(ofSize: 18)
        lblTotalSteps.font = UIFont.bold(ofSize: 13)
        lblAverageSteps.font = UIFont.bold(ofSize: 13)
        lblTotalMoveCoins.font = UIFont.bold(ofSize: 13)
        lblAverage.font = UIFont.semiBold(ofSize: 13)
        lblMemberSince.font = UIFont.regular(ofSize: 12)
    }
    

    func localizationSetup(){
        
        lblTitleTotalSteps.text = "Total Steps Converted".localized
        lblTitleTotalMoveCoins.text = "Total MoveCoins Created".localized
        lblTotalSteps.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        lblTotalMoveCoins.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        viewSegmentTT.removeFromSuperview()
        viewSegmentTT = TTSegmentedControl()
        viewSegmentTT.frame = viewSegmentedControl.bounds
        setupSegmentedControl(segmentCntrl: viewSegmentTT)
        viewSegmentTT.layer.masksToBounds = true
        self.viewSegmentedControl.layer.masksToBounds = true
        viewSegmentTT.layoutIfNeeded()
     
        self.viewSegmentedControl.addSubview(viewSegmentTT)
    }
    
    func setupView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileViewTapped(_:)))
        viewProfile.addGestureRecognizer(tap)
        viewProfile.isUserInteractionEnabled = true
        self.imagePicker = ImagePickerClass(presentationController: self, delegate: self, allowsEditing: false)
    }
    
    func setUpNavigationItems(){
        
        btnChat.setBackgroundImage(UIImage(named: "chat"), for: .normal)
        btnChat.addTarget(self, action: #selector(btnChatTapped), for: .touchUpInside)
        leftBarButton.customView = btnChat
        //        let leftBarButton = UIBarButtonItem(image: UIImage(named: "chat"), style: .plain, target: self, action: #selector(btnChatTapped))
        self.parent?.navigationItem.leftBarButtonItems = [leftBarButton]
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(btnSettingTapped))
        self.parent?.navigationItem.rightBarButtonItems = [rightBarButton]
        
        // Multiline Title
        
        let upperTitle = NSMutableAttributedString(string: SingletonClass.SharedInstance.userData?.nickName ?? "", attributes: [NSAttributedString.Key.font: FontBook.Bold.of(size: 22.0), NSAttributedString.Key.foregroundColor: UIColor.white])
        //        let lowerTitle = NSMutableAttributedString(string: "\nMember since Augest 5,2019", attributes: [NSAttributedString.Key.font: FontBook.Regular.of(size: 12.0) , NSAttributedString.Key.foregroundColor: UIColor.white])
        //        upperTitle.append(lowerTitle)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height:50))
        label1.numberOfLines = 0
        label1.textAlignment = .center
        label1.attributedText = upperTitle  //assign it to attributedText instead of text
        self.parent?.navigationItem.titleView = label1
    }
    
    func setupProfileData(){
        if let since = UtilityClass.changeDateFormateFrom(dateString: SingletonClass.SharedInstance.userData?.createdDate ?? "", fromFormat: DateFomateKeys.api, withFormat: "MMM dd, yyyy") {
            lblMemberSince.text = "Member since ".localized + since
        }
        if let url = URL(string: SingletonClass.SharedInstance.userData?.profilePicture ?? "") {
            imgProfilePicture.kf.indicatorType = .activity
            imgProfilePicture.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
        }else {
            imgProfilePicture.image = UIImage(named: "m-logo")
        }
        btnMyFriends.setTitle("My Friends ".localized + "(\(profileModel?.data.friends ?? "0"))", for: .normal)
        
        viewSegmentTT.selectItemAt(index: BarChartTitles.Weekly.rawValue, animated: true)
        self.setUpBarChat(index: BarChartTitles.Weekly.rawValue)
        
        leftBarButton.numberOfBages = Int(profileModel?.data.unreadMsgCount ?? "0") ?? 0
        
        lblTotalMoveCoins.text = profileModel?.data.totalCoins ?? "0"
        lblTotalSteps.text = profileModel?.data.totalStepsConverted ?? "0"
    }
    
    @objc func btnChatTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: ChatListViewController.className) as! ChatListViewController
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func btnSettingTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: SettingsViewController.className) as! SettingsViewController
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.imagePicker.present(from: imgProfilePicture)
    }
    
    func setupSegmentedControl(segmentCntrl : TTSegmentedControl){
        segmentCntrl.defaultTextColor = .white
        segmentCntrl.selectedTextColor = .white
        segmentCntrl.containerBackgroundColor = .clear
        segmentCntrl.thumbColor = TransparentColor
        segmentCntrl.thumbGradientColors = [TransparentColor]
        segmentCntrl.borderColor = TransparentColor
        segmentCntrl.border = 1
        segmentCntrl.layer.cornerRadius = segmentCntrl.frame.height / 2
        
        segmentCntrl.allowChangeThumbWidth = false
        segmentCntrl.itemTitles = ["Weekly".localized, "Monthly".localized ,"Yearly".localized]
        segmentCntrl.selectedTextFont = FontBook.Bold.of(size: 16)
        segmentCntrl.defaultTextFont =  FontBook.Bold.of(size: 16)
        
        segmentCntrl.didSelectItemWith = { (index, title) -> () in
            self.setUpBarChat(index: index)
        }
    }
    
    func setUpBarChat(index : Int){
        
        let type = BarChartTitles.init(rawValue: index)
        switch type {
            
        case .Weekly:
            self.lblAverage.text = "Average per week".localized
            self.lblAverageSteps.text = self.profileModel?.data.avarageWeekStepsCount
            self.dataEntries.removeAll()
            
            let maxValue = self.profileModel?.data.weekStepsCount.map{Int($0.totalSteps!) ?? 0}.max() ?? 0
            //                let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //                let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
            
            self.dataEntries.removeAll()
            
            for item in self.profileModel?.data.weekStepsCount ?? [] {
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                formatter.dateFormat = "d"
                let formatter2 = DateFormatter()
                formatter2.locale = Locale(identifier: "en_US_POSIX")
                
                formatter2.dateFormat = "yyyy-MM-dd"
                
                let currentDate = formatter2.date(from: item.day)
                let currentDay = formatter.string(from: currentDate ?? Date())
                let steps = Int(item.totalSteps ?? "0")
                let height: Float
                if maxValue == 0 {
                    height = 0
                } else {
                    height = Float(Float(steps ?? 0)/Float(maxValue))
                }
                self.dataEntries.append(DataEntry(color: UIColor.white, height: height, textValue: "", title: currentDay))
            }
            self.viewBarDetails.updateDataEntries(dataEntries: self.dataEntries, animated: false, time: .Week)
            
            /*
             var interval = DateComponents()
             interval.day = 1
             var anchorComponents = Calendar.current.dateComponents([.weekday], from: Date())
             anchorComponents.weekday = 1
             //            let addComponent = Calendar.Component.weekOfYear
             
             getHealthKitData(interval: interval, anchorComponents: anchorComponents, addComponentValue: -6){
             print("Final Count : ",self.stepsDataEntry.count)
             DispatchQueue.main.async {
             self.healthKitDataWeekSetup()
             }
             }
             */
            
        case .Monthly:
            self.lblAverage.text = "Average per month".localized
            self.lblAverageSteps.text = self.profileModel?.data.avarageMonthStepsCount
            self.dataEntries.removeAll()
            
            let maxValue = self.profileModel?.data.monthStepsCount.map{Int($0.totalSteps!) ?? 0}.max() ?? 0
            
            let formatter2 = DateFormatter()
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.dateFormat = "yyyy-MM-dd"
            
            let aryData = Array(0...29).sorted(by: {$0 > $1})
            var itemCount = 0
            var month = String()
            var isMonthChange = Bool()
            
            for i in aryData {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                formatter.dateFormat = "d"
                
                let formatterMonth = DateFormatter()
                formatterMonth.locale = Locale(identifier: "en_US_POSIX")
                
                formatterMonth.dateFormat = "MM"
                
                var date = Date()
                date.addTimeInterval(TimeInterval(-60*60*24*i))
                
                let currentString = formatter2.string(from: date)
                itemCount += 1
                
                let filterItems = self.profileModel?.data.monthStepsCount.filter{$0.datePartition == currentString }
                if filterItems?.count != 0 {
                    
                    let steps = Int(filterItems?.first?.totalSteps ?? "0")
                    let height: Float
                    if maxValue == 0 {
                        height = 0
                    } else {
                        height = Float(Float(steps ?? 0)/Float(maxValue))
                    }
                    
                    let tempDate = formatter2.date(from: filterItems?.first?.datePartition ?? "")
                    let currentMonth = formatterMonth.string(from: tempDate ?? Date())
                    
                    if month != currentMonth {
                        month = currentMonth
                        isMonthChange = true
                    }
                    if isMonthChange {
                        formatter.dateFormat = "d MMM"
                    }
                    self.dataEntries.append(DataEntry(color: UIColor.white, height: height, textValue: "", title: ((itemCount == 4) || i == 29) ? (isMonthChange ? formatter.string(from: date) : formatter.string(from: date)) : ""))
                } else {
                    self.dataEntries.append(DataEntry(color: UIColor.white, height: 0, textValue: "", title: ((itemCount == 4) || i == 29) ? formatter.string(from: date) : ""))
                }
                if itemCount == 4 || i == 29 {
                    itemCount = 0
                    isMonthChange = false
                }
            }
            self.viewBarDetails.updateDataEntries(dataEntries: self.dataEntries, animated: false, time: .Month)
            
            /*
             var interval = DateComponents()
             interval.day = 1
             var anchorComponents = Calendar.current.dateComponents([ .month], from: Date())
             anchorComponents.month = 1
             //            let addComponent = Calendar.Component.month
             
             getHealthKitData(interval: interval, anchorComponents: anchorComponents, addComponentValue: -29){
             print("Final Count : ",self.stepsDataEntry.count)
             DispatchQueue.main.async {
             self.healthKitDataMonthSetup()
             }
             }
             */
        case .Yearly:
            
            self.lblAverage.text = "Average per year".localized
            self.lblAverageSteps.text = self.profileModel?.data.avarageYearlyStepsCount
            self.dataEntries.removeAll()
            
            let maxValue = self.profileModel?.data.yearlyStepsCount.map{Int($0.totalSteps!) ?? 0}.max() ?? 0
            
            var year = String()
            var isYearChange = Bool()
            
            let formatter2 = DateFormatter()
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.dateFormat = "yyyy-MM-dd"
            
            for item in self.profileModel?.data.yearlyStepsCount ?? [] {
                let formatterYear = DateFormatter()
                formatterYear.locale = Locale(identifier: "en_US_POSIX")
                formatterYear.dateFormat = "yyyy"
                
                let formatterMonth = DateFormatter()
                formatterMonth.locale = Locale(identifier: "en_US_POSIX")
                
                formatterMonth.dateFormat = "MMM"
                
                let currentDate = formatter2.date(from: item.datePartition)
                let month = formatterMonth.string(from: currentDate ?? Date())
                //                let month = formatterMonth.string(from: item.totalSteps)
                let steps = Int(item.totalSteps ?? "0")
                let height: Float
                
                if maxValue == 0 {
                    height = 0
                } else {
                    height = Float(Float(steps ?? 0)/Float(maxValue))
                }
                
                //                let currentYear = formatterYear.string(from: item.datePartition)
                
                //                if year != currentYear {
                //                    year = currentYear
                //                    isYearChange = true
                //                }
                var title = String()
                title = String(month.prefix(1))
                
                self.dataEntries.append(DataEntry(color: UIColor.white, height: height, textValue: "", title: title))
            }
            self.viewBarDetails.updateDataEntries(dataEntries: self.dataEntries, animated: false, time: .Year)
            /*
             var interval = DateComponents()
             interval.month = 1
             var anchorComponents = Calendar.current.dateComponents([.year], from: Date())
             anchorComponents.year = 1
             //            let addComponent = Calendar.Component.year
             
             getHealthKitData(interval: interval, anchorComponents: anchorComponents, addComponentValue: -364){
             print("Final Count : ",self.stepsDataEntry.count)
             DispatchQueue.main.async {
             self.healthKitDataYearSetup()
             }
             }
             */
        case .none:
            return
        }
    }
    
    func getHealthKitData(interval : DateComponents,anchorComponents : DateComponents,addComponentValue : Int, completion: @escaping () -> Void) {
        
        let healthStore = HKHealthStore()
        let calendar = Calendar.current
        
        guard let anchorDate = calendar.date(from: anchorComponents) else {
            fatalError("*** unable to create a valid date from the given components ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription ?? "") ***")
            }
            
            let endDate = Date()
            
            guard let startDate = calendar.date(byAdding: .day, value: addComponentValue, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            self.stepsDataEntry.removeAll()
            
            print("startDate : \(startDate)")
            print("endDate : \(endDate)")
            
            // Plot the weekly step counts over the past 3 months
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { [unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: HKUnit.count())
                    
                    print("Amount of steps: \(value), date: \(date)")
                    self.stepsDataEntry.append(StepsCountDataEntry(stepsCount: value, stepsDate: date))
                }
            }
            print("Array : \(self.stepsDataEntry)")
            completion()
        }
        healthStore.execute(query)
    }
    
    func healthKitDataWeekSetup() {
        
        self.lblAverage.text = "Average per week".localized
        self.lblAverageSteps.text = self.profileModel?.data.avarageWeekStepsCount
        self.dataEntries.removeAll()
        
        let maxValue = stepsDataEntry.map{Float($0.stepsCount)}.max() ?? 0
        
        for item in stepsDataEntry {
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            formatter.dateFormat = "dd"
            
            let currentDay = formatter.string(from: item.stepsDate)
            print("Current Day : \(currentDay)")
            let steps = Float(item.stepsCount)
            
            let height: Float
            if maxValue == 0 {
                height = 0
            } else {
                height = Float(steps/maxValue)
            }
            
            self.dataEntries.append(DataEntry(color: UIColor.white, height: height, textValue: "", title: currentDay))
        }
        self.viewBarDetails.updateDataEntries(dataEntries: self.dataEntries, animated: false, time: .Week)
    }
    
    func healthKitDataMonthSetup() {
        
        self.lblAverage.text = "Average per month".localized
        self.lblAverageSteps.text = self.profileModel?.data.avarageMonthStepsCount
        self.dataEntries.removeAll()
        
        let maxValue = stepsDataEntry.map{Float($0.stepsCount)}.max() ?? 0 //  .map{$0.first?.totalSteps}.max() ?? 0
        
        let formatterDay = DateFormatter()
        formatterDay.locale = Locale(identifier: "en_US_POSIX")
        
        formatterDay.dateFormat = "d"
        
        let formatterMonth = DateFormatter()
        formatterMonth.locale = Locale(identifier: "en_US_POSIX")
        
        formatterMonth.dateFormat = "MM"
        
        let currentMonth = formatterMonth.string(from: Date())
        var isMonthChange = true
        
        for item in stepsDataEntry {
            
            let steps = Float(item.stepsCount)
            let height: Float
            
            if maxValue == 0 {
                height = 0
            } else {
                height = Float(steps/maxValue)
            }
            
            let itemMonth = formatterMonth.string(from: item.stepsDate)
            
            //            if isMonthChange {
            //                formatterDay.dateFormat = "d MMM"
            //            }
            
            self.dataEntries.append(DataEntry(color: UIColor.white, height: height, textValue: "", title: formatterDay.string(from: item.stepsDate)))
            
            if currentMonth != itemMonth {
                isMonthChange = false
            }
        }
        self.viewBarDetails.updateDataEntries(dataEntries: self.dataEntries, animated: false, time: .Month)
    }
    
    func healthKitDataYearSetup() {
        
        self.lblAverage.text = "Average per year".localized
        self.lblAverageSteps.text = self.profileModel?.data.avarageYearlyStepsCount
        self.dataEntries.removeAll()
        
        let maxValue = stepsDataEntry.map{Float($0.stepsCount)}.max() ?? 0 //  .map{$0.first?.totalSteps}.max() ?? 0
        
        var year = String()
        var isYearChange = Bool()
        
        for item in stepsDataEntry {
            let formatterYear = DateFormatter()
            formatterYear.locale = Locale(identifier: "en_US_POSIX")
            
            formatterYear.dateFormat = "yyyy"
            
            let formatterMonth = DateFormatter()
            formatterMonth.locale = Locale(identifier: "en_US_POSIX")
            
            formatterMonth.dateFormat = "MMM"
            
            let month = formatterMonth.string(from: item.stepsDate)
            let steps = Float(item.stepsCount)
            let height: Float
            
            if maxValue == 0 {
                height = 0
            } else {
                height = Float(steps/maxValue)
            }
            
            let currentYear = formatterYear.string(from: item.stepsDate)
            
            if year != currentYear {
                year = currentYear
                isYearChange = true
            }
            var title = String()
            title = String(month.prefix(1))
            
            self.dataEntries.append(DataEntry(color: UIColor.white, height: height, textValue: "", title: title))
        }
        self.viewBarDetails.updateDataEntries(dataEntries: self.dataEntries, animated: false, time: .Year)
    }
}

// ----------------------------------------------------
//MARK:- --------- ImagePicker Delegate Methods ---------
// ----------------------------------------------------

extension ProfileViewController :  ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag: Int) {
        isRemovePhoto = false
        if(image == nil && SelectedTag == 101){
            self.imgProfilePicture.image = UIImage(named: "m-logo")//UIImage.init(named: "imgPetPlaceholder")
            self.selectedImage = nil
            isRemovePhoto = true
        }else if image != nil{
            self.imgProfilePicture.image = image
            self.selectedImage = self.imgProfilePicture.image
        }else{
            return
        }
        webserviceCallForEditProfile()
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension ProfileViewController {
    
    func webserviceForProfileData() {
        
        let model = ProfileData()
        model.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
        
        UserWebserviceSubclass.profileData(profileDataModel: model) { (response, status, anyData) in
            if status {
                let res = profileDataResponseModel(fromJson: response)
                self.profileModel = res
                self.setupProfileData()
            }
        }
    }
    
    func webserviceCallForEditProfile(){
        
        UtilityClass.showHUD()
        let editModel = EditProfileModel()
        editModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
        if isRemovePhoto {
            editModel.remove_photo = 1
        }
        UserWebserviceSubclass.editProfile(editProfileModel: editModel, image: selectedImage){ (json, status, res) in
            
            UtilityClass.hideHUD()
            
            if status{
                let loginResponseModel = LoginResponseModel(fromJson: json)
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
                self.getUserData()
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

