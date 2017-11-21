//
//  WebServiceConfigurator.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation
import TDResult

public protocol TDWebServiceConfigurator{
    var dataSource: TDWebService? {set get}
    func createRequest() -> TDResult<TDWebServiceRequest, TDError>
}

public struct TDWebServiceConfiguratorClient: TDWebServiceConfigurator{
    
    public init(){}
    
    public weak var dataSource: TDWebService?
    
    public func createRequest() -> TDResult<TDWebServiceRequest, TDError>{
        if dataSource == nil{
            return TDResult.Error(TDError.init(TDWebServiceError.requestGenerationFailed))
        }
        if !isUrlVerified(urlString: dataSource?.url()){
            return TDResult.Error(TDError.init(TDWebServiceError.invalidUrl))
        }
        if TDReachability.init()?.currentReachabilityStatus == .notReachable{
            return TDResult.Error(TDError.init(TDWebServiceError.networkNotReachable))
        }
        var request = TDWebServiceRequest()
        request.methodType = (dataSource?.methodType())!
        request.urlEncodingType = (dataSource?.encodingType())!
        request.url = (dataSource?.url())!
        request.parameters = dataSource?.bodyParameters()
        request.headers = dataSource?.headerParameters()
        request.timeOutSession = (dataSource?.requestTimeOut())!
        request.resultType = (dataSource?.resultType())!
        return TDResult.init(value: request)
    }
    
    public func validateResult(_ result: TDWSResult) -> TDResult<TDWSResult, TDError>{
        if dataSource == nil{
            return TDResult.Error(TDError.init(TDWebServiceError.resultValidationFailed))
        }
        let resultValidatorAPI = dataSource?.validalidatorClient()
        if resultValidatorAPI != nil{
            return (resultValidatorAPI?.validateResponse(result))!
        }
        return TDResult.Success(result)
        
    }
    
    public func getApi()-> TDWebServiceApi{
        return (dataSource?.apiClient())!
    }
    
    public func getValidator()-> TDResultValidatorApi?{
        return dataSource?.validalidatorClient()
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
