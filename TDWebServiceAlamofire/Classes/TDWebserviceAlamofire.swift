//
//  WebServiceApiAlamofire.swift
//  TDServiceAPI
//
//  Created by Yapapp on 07/11/17.
//

import Foundation
import TDWebService
import TDResult

public protocol TDWebserviceAlamofire:  TDWebService{
}

extension TDWebserviceAlamofire{
    
    public func apiCall(_ completionHandler: @escaping (TDResult<TDWSResult, TDError>) -> Void){
        configurator = TDWebServiceConfiguratorClient()
        configurator.dataSource = self
        let result = configurator.createRequest()
        switch result {
        case .Success(let webServiceRequest):
            api = TDWebServiceApiAlamofire()
            initiateApiCall(webServiceRequest, completionHandler: completionHandler)
        case .Error(let error):
            completionHandler(TDResult.Error(error))
        }
    }
}


public class TDWebServiceApiAlamofire: TDWebServiceApi{
    public func cancel() {
        if #available(iOS 9.0, *) {
            manager.session.getAllTasks { (tasks) in
                _ = tasks.map({[weak self] (task) -> Void in
                    let currentUrl = task.currentRequest?.url
                    if currentUrl != nil{
                        if currentUrl!.absoluteString == self?.request?.url{
                            task.cancel()
                        }
                    }
                })
            }
        } else {
            print("Cannot cancel the task")
        }
    }
    
    public func cancelAll() {
        if #available(iOS 9.0, *) {
            manager.session.getAllTasks { (tasks) in
                _ = tasks.map({[weak self] (task) -> Void in
                    task.cancel()
                })
            }
        } else {
            print("Cannot cancel all tasks")
        }
    }
    
    public init(){}
    
    public var request: TDWebServiceRequest?
    public var response: AnyObject?
    let manager = SessionManager.default
    
    public func call(_ request: TDWebServiceRequest, completionHandler: @escaping (TDResult<TDWSResult, TDError>) -> Void){
        self.request = request
        let manager = SessionManager.default
        let url:String = request.url
        
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(request.timeOutSession)
        
        manager.request(url, method: self.getHTTPMethodType(type: request.methodType), parameters: request.parameters, encoding: self.getURLEncodingType(type: request.urlEncodingType), headers:request.headers).response(completionHandler: {[weak self] (response) in
            self?.response = response as AnyObject
            if response.error != nil{
                completionHandler(TDResult.Error(TDError.init(TDWebServiceError.apiError)))
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
                        var json = TDJson()
                        json.jsonData = jsonData
                        completionHandler(TDResult.init(value: json))
                        
                    } catch {
                        //Print the error
                        completionHandler(TDResult.Error(TDError.init(TDWebServiceError.apiError)))
                    }
                }
            }
        })
        
    }
    
    //MARK:- Private Method(s)
    private func getHTTPMethodType(type: TDMethodType) -> HTTPMethod{
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
    
    private func getURLEncodingType(type: TDURLEncodingType) -> ParameterEncoding{
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
