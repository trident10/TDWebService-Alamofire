//
//  WerbServiceApi.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation
import TDResult

public protocol TDWebServiceApi{
    var request: TDWebServiceRequest? {get set}
    var response: AnyObject? {get set}
    mutating func call(_ request: TDWebServiceRequest, completionHandler: @escaping (TDResult<TDWSResponse, TDError>) -> Void)
    func cancel()
    func cancelAll()
}

public class TDWebServiceApiDefault: TDWebServiceApi {
    
    public init(){}
    
    public var request: TDWebServiceRequest?
    public var response: AnyObject?
    
    public func call(_ request: TDWebServiceRequest, completionHandler: @escaping (TDResult<TDWSResponse, TDError>) -> Void) {
        self.request = request
        DispatchQueue.main.async {
            completionHandler(TDResult.Success(TDWSResponse.init(request: request, response: nil, resultData: "Test")))
        }
    }
    
    public func cancel(){
        print("Pending url session feature needs to be added")
    }
    
    public func cancelAll(){
        print("Pending url session feature needs to be added")
    }
}
