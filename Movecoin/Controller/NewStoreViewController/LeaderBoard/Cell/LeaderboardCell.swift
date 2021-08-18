//
//  LeaderboardCell.swift
//  Movecoins
//
//  Created by Imac on 15/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {
    
    @IBOutlet weak var viewRank: UIView!
    @IBOutlet weak var lblRank: LocalizLabel!
    @IBOutlet weak var lblName: LocalizLabel!
    @IBOutlet weak var lblStep: LocalizLabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewRank.makeCircular()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.setupFont()
    }
    
    func setupFont() {
        
        self.lblRank.font = UIFont.regular(ofSize: 20)
        self.lblName.font = UIFont.regular(ofSize: 20)
        self.lblStep.font = UIFont.regular(ofSize: 20)
        
    }
    
}
