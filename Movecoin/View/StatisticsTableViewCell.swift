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
                    self.lblSteps.text = data.steps + " steps. " + dateStr
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
