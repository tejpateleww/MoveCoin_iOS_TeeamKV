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
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStep: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewRank.makeCircular()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.setupFont()
    }
    
    func setupFont() {
        
        self.lblRank.font = UIFont.bold(ofSize: 20)
        self.lblName.font = UIFont.bold(ofSize: 20)
        self.lblStep.font = UIFont.bold(ofSize: 20)
        
    }
    
}
