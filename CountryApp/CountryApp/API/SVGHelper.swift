//
//  SVGHelper.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 30/07/2025.
//

import SVGKit

class SVGHelper {
    
    static let `default` = SVGHelper()
    
    func imageFromSVGData(_ data: Data) -> UIImage? {
        guard let svgImage = SVGKImage(data: data) else {
            return nil
        }
        
        return svgImage.uiImage
    }

    
}
