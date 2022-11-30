//
//  PurchaseHistory.swift
//  Movecoins
//
//  Created by eww090 on 13/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


class PurchaseHistory : RequestModel {
    var UserID: String = ""
}

class BlockList : RequestModel {
    var block_by: String = ""
}

class BlockUser : RequestModel {
    var block_by: String = ""
    var block_user_id: String = ""
}

class UnblockUser : RequestModel {
    var block_id: String = ""
}
