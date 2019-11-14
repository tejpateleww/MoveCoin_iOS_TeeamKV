//
//  RequestModel.swift
//  Movecoins
//
//  Created by eww090 on 11/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


class RequestModel{
    
    func  generatPostParams() -> [String : Any]{
        
        var params = [:] as [String : Any]
        
        let bookMirror = Mirror(reflecting: self)
        for (name, value) in bookMirror.children {
            guard let name = name else { continue }
            params[name] = "\(value)"
            
            
            print("\(name): \(type(of: value)) = '\(value)'")
        }
        return params
    }
    
    func  generatGetParams() -> String{
        
        var url_params : String = ""
        
        let bookMirror = Mirror(reflecting: self)
        
        for (name, value) in bookMirror.children {
            guard let name = name else { continue }
            
            if value as? String != "" {
                if(url_params.isEmpty){
                    url_params = "?"+"\(name)="+"\(value)"
                }else{
                    url_params += "&"+"\(name)="+"\(value)"
                }
            }
            print("\(name): \(type(of: value)) = '\(value)'")
        }
        print("params")
        print(url_params)
        return url_params
    }
    
    func generatGetParams_() -> String{
        
        var url_params : String = ""
        
        let bookMirror = Mirror(reflecting: self)
        
        for children in bookMirror.children {
            
            let name_ : String = children.label!
            // guard  let name = name_ else { continue }
            
            let value : String = children.value as! String;
            
            print("\(name_): \(type(of: value)) = '\(value)'")
            if let value_ = value.encodeUTF8() {
                
                if (value_ != "" )
                {
                    if(url_params.isEmpty)
                    {
                        url_params = "?"+"\(name_)="+"\(value_)"
                    }
                    else{
                        url_params += "&"+"\(name_)="+"\(value_)"
                    }
                }
            }else {
                
            }
            print("\(name_): \(type(of: value)) = '\(value)'")
        }
        print("params")
        print(url_params)
        return url_params
    }
}

