//
//  TransferCoinsModel.swift
//  Movecoins
//
//  Created by eww090 on 06/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


class TransferCoinsModel : RequestModel {
    var SenderID: String = ""
    var ReceiverID: String = ""
    var Coins: String = ""
    var Message: String = ""
}
