//
//  SocketCallExtension.swift
//  Movecoins
//
//  Created by eww090 on 26/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import SocketIO

extension TabViewController {
    
    func SocketOnMethods() {
        
        //        if !SocketIOManager.shared.isSocketOn {
        SocketIOManager.shared.socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
            // SwiftMessages.hideAll()
            SocketIOManager.shared.isSocketOn = false
        }
        
        SocketIOManager.shared.socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected")
            SocketIOManager.shared.isSocketOn = true
            
        }
        
        SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            SocketIOManager.shared.isSocketOn = true
            self.emitSocket_UserConnect()
            self.onSocketConnectUser()
            self.onSocketUpdatelocation()
            
        }
        
        //Connect User On Socket
        SocketIOManager.shared.establishConnection()
    }
    
    // Socket On Connect User
       func onSocketConnectUser() {
           SocketIOManager.shared.socketCall(for: SocketApiKeys.kConnectUser) { (json) in
               print(json)
           }
       }
       
       //     // Socket On Update location
       func onSocketUpdatelocation(){
           SocketIOManager.shared.socketCall(for: SocketApiKeys.kUpdateUserLocation) { (json) in
               print(json)
           }
       }
    
    // Socket Emit Connect user
    func emitSocket_UserConnect(){
        let param = [
            SocketApiKeys.KUserId : SingletonClass.SharedInstance.userData?.iD  ?? "" as Any
            ] as [String : Any]
        SocketIOManager.shared.socketEmit(for: SocketApiKeys.kConnectUser, with: param)
    }
    
    // Socket Emit update location
    func emitSocket_UpdateLocation(latitute:Double,long:Double){
        let param = [
            
            SocketApiKeys.KUserId : SingletonClass.SharedInstance.userData?.iD  ?? "" as Any,
            SocketApiKeys.kLat : latitute,
            SocketApiKeys.kLng : long
            
            ] as [String : Any]
        SocketIOManager.shared.socketEmit(for: SocketApiKeys.kUpdateUserLocation, with: param)
        
    }
    
}
