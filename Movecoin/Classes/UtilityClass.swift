//
//  UtilityClass.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import CoreImage

extension NSObject {
    static var className : String {
        return String(describing: self)
    }
}


@available(iOS, introduced: 8.0, deprecated: 12.0, message: "Core Image Kernel Language API deprecated. (Define CI_SILENCE_GL_DEPRECATION to silence these warnings)")
class AlphaFrameFilter: CIFilter {
  
    static var kernel: CIColorKernel? = {
        
        return CIColorKernel(source: """
kernel vec4 alphaFrame(__sample s, __sample m) {
  return vec4( s.rgb, m.r );
}
""")
    }()
    
    var inputImage: CIImage?
    var maskImage: CIImage?
    
    override var outputImage: CIImage? {
        
        let kernel = AlphaFrameFilter.kernel!
        
        guard let inputImage = inputImage, let maskImage = maskImage else {
            return nil
        }
        
        let args = [inputImage as AnyObject, maskImage as AnyObject]
        return kernel.apply(extent: inputImage.extent, arguments: args)
    }
}
