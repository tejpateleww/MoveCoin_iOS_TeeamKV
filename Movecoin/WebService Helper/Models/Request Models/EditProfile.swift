//
//  EditProfileModel.swift
//  Movecoins
//
//  Created by eww090 on 14/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


class EditProfileModel : RequestModel {
    
    /*
     FullName:mayur shiroya
     email:developer.ew.w.4@gmail.com
     UserName:mayur00700
     NickName:mayur
     Password:123456
     Latitude:23.4564621
     Longitude:72.5454151
     DeviceToken:651546161151
     DeviceType:ios
     ReferralCode:ladcnibf
     Phone:9924455779
     DateOfBirth:1992-07-07
     Gender:male
     
     
     // ------ Optional -------
     ProfilePicture
     SocialID
     SocialType
     Step
     */
    
   
    var UserID : String = ""
    var Email : String = ""
    var NickName : String = ""
    var Latitude : String = ""
    var Longitude : String = ""
    var DeviceToken : String = ""
    var DeviceType : String = ""
    var Phone : String = ""
    var Gender : String = ""
    var DateOfBirth : String = ""
    var Height : String = ""
    var Weight : String = ""
}
