//
//  WebServiceDataModel.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation

public enum MethodType {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum URLEncodingType{
    case FORM
    case QUERY
    case JSONENCODING
    case FileUpload
}

public enum ResultType{
    case String
    case Data
    case JSON
}

public enum WebServiceError: Error{
    case RquestGenerationFailed
    case ResultValidationFailed
    case NetworkNotReachable
    case InvalidUrl
    case ApiError
    case JsonConversionFailure
    case JsonParsingFailure
}

public protocol WSResult {}
extension String: WSResult{}
extension Data: WSResult{}
extension Json: WSResult{}

public struct Json {
    public var jsonData: AnyObject?
    public init(){}
}

public struct WebServiceRequest{
    public var methodType: MethodType = .GET
    public var urlEncodingType: URLEncodingType = .FORM
    public var url: String = ""
    public var parameters:[String:Any]?
    public var headers:[String:String]?
    public var resultType: ResultType = .String
    public var timeOutSession = 60
}
