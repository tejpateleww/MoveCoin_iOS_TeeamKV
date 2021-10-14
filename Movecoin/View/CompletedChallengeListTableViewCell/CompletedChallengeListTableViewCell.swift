//
//  CompletedChallengeListTableViewCell.swift
//  Pods
//
//  Created by Rahul Patel on 14/09/21.
//

import UIKit

class CompletedChallengeListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChallengeEndsOn: UILabel!
    @IBOutlet weak var lblNameOfChallenge: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblNumberOfParticipants: UILabel!
    @IBOutlet weak var lblWinner: UILabel!

    @IBOutlet weak var vwCell: UIView!
    
    
    var dictChallenge : ChallengesDatum?
    {
        didSet{
            if let data = dictChallenge {
                prepareView()

                if let dateStr = UtilityClass.changeDateFormateFrom(dateString: data.endTime, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.challengDateFormat) {
                    self.lblChallengeEndsOn.text = "title_ended_on".localized + " \(dateStr)"
                }

                self.lblNameOfChallenge.text = data.name
                // For Image
                let productsURL = NetworkEnvironment.baseImageURL + data.prizeImage
                if let url = URL(string: productsURL) {
                    self.imgProduct.kf.indicatorType = .activity
                    self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
                    self.imgProduct.contentMode = .scaleAspectFill
                }
                self.lblNumberOfParticipants.text = "\(data.totalParticipant ?? 0) " + "title_participants".localized
                self.lblWinner.text = data.nickName
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func prepareView()
    {
        self.lblChallengeEndsOn.font = UIFont.regular(ofSize: 13)
        self.lblNameOfChallenge.font = UIFont.regular(ofSize: 20)
        self.lblNumberOfParticipants.font = UIFont.regular(ofSize: 13)
        self.lblWinner.font = UIFont.regular(ofSize: 16)
        
        self.lblChallengeEndsOn.textColor = UIColor.white.withAlphaComponent(0.5)
        self.lblNameOfChallenge.textColor = UIColor.white.withAlphaComponent(0.5)
        self.lblNumberOfParticipants.textColor = UIColor.white.withAlphaComponent(0.5)
        self.lblWinner.textColor = UIColor.white.withAlphaComponent(0.5)
        
        self.lblChallengeEndsOn.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        self.lblNameOfChallenge.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        self.lblNumberOfParticipants.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        
        self.contentView.semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
