//
//  TotalStepsTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 07/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class TotalStepsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
     var stepModel: StepsData? {
            didSet{
                if let data = stepModel {
                    self.lblSteps.text = data.steps
                    
                    if let previousStr = data.previousDate, !previousStr.isEmpty {
                        let previousDateStr = UtilityClass.changeDateFormateFrom(dateString: data.previousDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDate)
                        let toDateStr = UtilityClass.changeDateFormateFrom(dateString: data.createdDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDate)
                        
                        self.lblDate.text = (previousDateStr ?? "") + " to ".localized + (toDateStr ?? "")
                        
                    } else if let dateStr = UtilityClass.changeDateFormateFrom(dateString: data.createdDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDateTime) {
                         self.lblDate.text =  dateStr
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
        lblDate.font = UIFont.regular(ofSize: 15)
        lblSteps.font = UIFont.regular(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
