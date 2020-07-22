//
//  StatisticsTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 05/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var coinsEarnModel: CoinsEarn? {
        didSet{
            if let data = coinsEarnModel {
                self.lblPoints.text = data.coins
                
                if let dateStr = UtilityClass.changeDateFormateFrom(dateString: data.createdDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDate){
                    
                    self.lblSteps.text = data.steps + " steps. ".localized + dateStr
                    
                    if let previousDate = UtilityClass.changeDateFormateFrom(dateString: data.previousDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDate) {
                        
                        let createdDt = UtilityClass.getDate(dateString: data.createdDate, dateFormate: DateFomateKeys.apiDOB)
                        let previousDt = UtilityClass.getDate(dateString: data.previousDate, dateFormate: DateFomateKeys.apiDOB)
                            
                        if previousDt < createdDt {
                            
                            let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: createdDt)!
                            let days = createdDt.interval(ofComponent: .day, fromDate: previousDt)
                            if days >= 7 {
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                dateFormatter.dateFormat = DateFomateKeys.displayDate
                                let lastweek = dateFormatter.string(from: lastWeekDate)
                               
                                self.lblSteps.text = data.steps + " steps. ".localized + lastweek + " to ".localized + dateStr
        
                            } else {
                                self.lblSteps.text = data.steps + " steps. ".localized + previousDate + " to ".localized + dateStr
                            }
                        }
                    }
                }
                // For Image
                 if let url = URL(string: SingletonClass.SharedInstance.userData?.profilePicture ?? "") {
                    self.imgProfile.kf.indicatorType = .activity
                    self.imgProfile.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSteps.font = UIFont.regular(ofSize: 15)
        lblPoints.font = UIFont.regular(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
