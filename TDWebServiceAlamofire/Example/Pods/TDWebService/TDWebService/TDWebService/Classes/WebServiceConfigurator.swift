//
//  WebServiceConfigurator.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation
import ReachabilitySwift

public protocol WebServiceConfigurator{
    var dataSource: WebServiceAble? {set get}
    func createRequest() -> TDResult<WebServiceRequest, TDError>
}

public struct WebServiceConfiguratorClient: WebServiceConfigurator{
    
    public init(){}
    
    public var dataSource: WebServiceAble?
    
    public func createRequest() -> TDResult<WebServiceRequest, TDError>{
        if dataSource == nil{
            return TDResult.Error(TDError.init(WebServiceError.RquestGenerationFailed))
        }
        if !isUrlVerified(urlString: dataSource?.url()){
            return TDResult.Error(TDError.init(WebServiceError.InvalidUrl))
        }
        if Reachability.init()?.currentReachabilityStatus == .notReachable{
            return TDResult.Error(TDError.init(WebServiceError.NetworkNotReachable))
        }
        var request = WebServiceRequest()
        request.methodType = (dataSource?.methodType())!
        request.urlEncodingType = (dataSource?.encodingType())!
        request.url = (dataSource?.url())!
        request.parameters = dataSource?.bodyParameters()
        request.headers = dataSource?.headerParameters()
        request.timeOutSession = (dataSource?.requestTimeOut())!
        request.resultType = (dataSource?.resultType())!
        return TDResult.init(value: request)
    }
    
    public func validateResult(_ result: WSResult) -> TDResult<Bool, TDError>{
        if dataSource == nil{
            return TDResult.Error(TDError.init(WebServiceError.ResultValidationFailed))
        }
        let resultValidatorAPI = dataSource?.resultValidatorClient()
        if resultValidatorAPI != nil{
            return (resultValidatorAPI?.isResponseValid(result))!
        }
        return TDResult.Success(true)
        
    }
    
    public func getApi()-> WebServiceAPI{
        return (dataSource?.apiClient())!
    }
    
    private func isUrlVerified (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = URL.init(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
}
