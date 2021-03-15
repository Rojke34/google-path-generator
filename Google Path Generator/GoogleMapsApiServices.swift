//
//  GoogleMapsApiServices.swift
//  Google Path Generator
//
//  Created by Kevin Rojas on 20/01/20.
//  Copyright © 2020 Kevin Rojas. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GoogleMapsApiServices: NSObject {
    
    func getGooglePoints(URL: String, _ completion: @escaping (String) -> ()) {
        let manager = Alamofire.SessionManager.default
        
        let encodingURl = URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if let url = encodingURl  {
            manager.request(url).validate(statusCode: 200..<300).responseJSON { (response) in
                if let result = response.result.value {
                    let json = JSON(result)
                    
                    switch json["status"].stringValue {
                    case "OK":
                        guard let info = json["routes"].arrayValue.first else { return }
                        
                        let overview_polyline = info["overview_polyline"]
                        
                        completion(overview_polyline["points"].stringValue)
                        
                    case "OVER_QUERY_LIMIT":
                        fatalError("Si sale este mensaje es porque se ha sobrepasado el limite de la cuota del api google maps")
                    default:
                        fatalError("Ha ocurrido un error, verifica tu conexión a Internet e intentalo nuevamente.")
                    }
                } else {
                    fatalError("Ha ocurrido un error, verifica tu conexión a Internet e intentalo nuevamente.")
                }
            }
        }
        

    }
}

