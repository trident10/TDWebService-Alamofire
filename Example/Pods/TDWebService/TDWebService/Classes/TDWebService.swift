//
//  File.swift
//  TDServiceAPI
//
//  Created by Yapapp on 07/11/17.
//

import Foundation
import ObjectiveC
import TDResult

public protocol TDWebService: class {
    
    func bodyParameters() -> [String:Any]?
    func headerParameters() -> [String:String]?
    func url() -> String
    func requestTimeOut()->Int
    func validalidatorClient() -> TDResultValidatorApi?
    func methodType() -> TDMethodType
    func encodingType() -> TDURLEncodingType
    func resultType() -> TDResultType
    
    func apiCall(_ completionHandler: @escaping (TDResult<TDWSResponse, TDError>) -> Void)
    func cancel()
    func cancelAll()
    
}

private var xoAssociationConfigKey: UInt8 = 0
private var xoAssociationApiKey: UInt8 = 1

public extension TDWebService{
    
   var configurator: TDWebServiceConfiguratorClient {
        get {
            return (objc_getAssociatedObject(self, &xoAssociationConfigKey) as? TDWebServiceConfiguratorClient)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
   var api: TDWebServiceApi {
        get {
            return (objc_getAssociatedObject(self, &xoAssociationApiKey) as? TDWebServiceApi)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationApiKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func bodyParameters()->[String:Any]?{
        return nil
    }
    
    public func headerParameters()->[String:String]?{
        return nil
    }
    
    public func requestTimeOut()->Int{
        return 60
    }
    
    public func apiClient() -> TDWebServiceApi{
        return TDWebServiceApiDefault()
    }
    
    public func validalidatorClient() -> TDResultValidatorApi?{
        return nil
    }
    
    public func methodType()-> TDMethodType{
        return .GET
    }
    
    public func encodingType()-> TDURLEncodingType{
        return .QUERY
    }
    
    public func resultType() -> TDResultType{
        return .String
    }
    
    public func apiCall(_ completionHandler: @escaping (TDResult<TDWSResponse, TDError>) -> Void){
        configurator = TDWebServiceConfiguratorClient()
        configurator.dataSource = self
        let result = configurator.createRequest()
        switch result {
            case .Success(let webServiceRequest):
                api = configurator.getApi()
                initiateApiCall(webServiceRequest, completionHandler: completionHandler)
            
            case .Error(let error):
                completionHandler(TDResult.Error(error))
        }
    }
    
    public func cancel(){
        api.cancel()
    }
    
    public func cancelAll(){
        api.cancelAll()
    }
    
    
    public func initiateApiCall(_ request: TDWebServiceRequest, completionHandler: @escaping (TDResult<TDWSResponse, TDError>) -> Void){
        api.call(request) {[weak self] (result) in
            let validator = self?.configurator.getValidator()
            if validator == nil{
                completionHandler(result)
                return
            }
            switch result {
            case .Success(let wsResult):
                let validResult = validator?.validateResponse(wsResult)
                if let finalResult = validResult{
                    completionHandler(finalResult)
                }
                else{
                    completionHandler(TDResult.Error(TDError.init(TDWebServiceError.validatorApiFailed)))
                }
            case .Error(let error):
                completionHandler(TDResult.Error(error))
            }
        }
    }


}
