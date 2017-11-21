//
//  WebServiceDataModel.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation

public enum TDMethodType {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum TDURLEncodingType{
    case FORM
    case QUERY
    case JSONENCODING
    case FileUpload
}

public enum TDResultType{
    case String
    case Data
    case JSON
}

public enum TDWebServiceError: Error{
    case requestGenerationFailed
    case resultValidationFailed
    case networkNotReachable
    case validatorApiFailed
    case invalidUrl
    case apiError
    case jsonConversionFailure
    case jsonParsingFailure
}

public protocol TDWSResult {}
extension String: TDWSResult{}
extension Data: TDWSResult{}
extension TDJson: TDWSResult{}

public struct TDJson {
    public var jsonData: AnyObject?
    public init(){}
}

public struct TDWebServiceRequest{
    public var methodType: TDMethodType = .GET
    public var urlEncodingType: TDURLEncodingType = .FORM
    public var url: String = ""
    public var parameters:[String:Any]?
    public var headers:[String:String]?
    public var resultType: TDResultType = .String
    public var timeOutSession = 60
}
