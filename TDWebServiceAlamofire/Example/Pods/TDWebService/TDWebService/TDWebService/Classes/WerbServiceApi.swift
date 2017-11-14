//
//  WerbServiceApi.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation

public protocol WebServiceAPI{
    var request: WebServiceRequest? {get set}
    var response: AnyObject? {get set}
    func call(_ request: WebServiceRequest, completionHandler: @escaping (TDResult<WSResult, TDError>) -> Void)
}

struct WebServiceAPIDefault: WebServiceAPI {
    var request: WebServiceRequest?
    
    var response: AnyObject?
    
    func call(_ request: WebServiceRequest, completionHandler: @escaping (TDResult<WSResult, TDError>) -> Void) {
        print("Pending url session feature needs to be added")
    }
    
    
}
