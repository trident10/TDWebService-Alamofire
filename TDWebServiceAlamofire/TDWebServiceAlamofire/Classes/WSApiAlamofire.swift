//
//  WebServiceApiAlamofire.swift
//  TDServiceAPI
//
//  Created by Yapapp on 07/11/17.
//

import Foundation
import Alamofire
import TDWebService

public protocol WebServiceAbleAlamofire:  WebServiceAble{
}

extension WebServiceAbleAlamofire{
    
    public func apiCall(_ completionHandler: @escaping (TDResult<WSResult, TDError>) -> Void){
        var configurator = WebServiceConfiguratorClient()
        configurator.dataSource = self
        let result = configurator.createRequest()
        switch result {
        case .Success(let webServiceRequest):
            let api = WebServiceApiAlamofire()
            api.call(webServiceRequest) { (result) in
                completionHandler(result)
            }
            
        case .Error(let error):
            completionHandler(TDResult.Error(error))
        }
    }
}


public class WebServiceApiAlamofire: WebServiceAPI{
    
    public init(){}
    
    public var request: WebServiceRequest?
    public var response: AnyObject?
    public func call(_ request: WebServiceRequest, completionHandler: @escaping (TDResult<WSResult, TDError>) -> Void){
        self.request = request
        let manager = Alamofire.SessionManager.default
        let url:String = request.url
        
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(request.timeOutSession)
        
        manager.request(url, method: self.getHTTPMethodType(type: request.methodType), parameters: request.parameters, encoding: self.getURLEncodingType(type: request.urlEncodingType), headers:request.headers).response(completionHandler: {[weak self] (response) in
            self?.response = response as AnyObject
            if response.error != nil{
                completionHandler(TDResult.Error(TDError.init(WebServiceError.ApiError)))
                return
            }
            else{
                switch request.resultType{
                case .Data:
                    if response.data != nil{
                        completionHandler(TDResult.init(value: response.data!))
                    }
                    else{
                        completionHandler(TDResult.init(value: Data()))
                    }
                    return
                    
                case .String:
                    var description: String?
                    if response.data != nil{
                        description = String(data: response.data!, encoding: .utf8)
                    }
                    if description != nil{
                        completionHandler(TDResult.init(value: description!))
                    }else{
                        completionHandler(TDResult.init(value: ""))
                    }
                    return
                    
                case .JSON:
                    do {
                        //Parsing data & get the Array
                        let jsonData = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as AnyObject
                        var json = Json()
                        json.jsonData = jsonData
                        completionHandler(TDResult.init(value: json))
                        
                    } catch {
                        //Print the error
                        completionHandler(TDResult.Error(TDError.init(WebServiceError.ApiError)))
                    }
                }
            }
        })
        
    }
    
    //MARK:- Private Method(s)
    private func getHTTPMethodType(type: MethodType) -> HTTPMethod{
        switch type {
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        case .DELETE:
            return .delete
        }
    }
    
    private func getURLEncodingType(type: URLEncodingType) -> ParameterEncoding{
        switch type {
        case .FORM:
            return URLEncoding.httpBody
        case .QUERY:
            return URLEncoding.queryString
        case .JSONENCODING:
            return JSONEncoding.default
        default:
            return URLEncoding.httpBody
        }
        
    }

}
