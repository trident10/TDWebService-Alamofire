//
//  Result.swift
//  TDServiceAPI
//
//  Created by Yapapp on 09/11/17.
//

import Foundation

public enum TDResult<T, E: TDErrorRepresentable> {
    case Success(T)
    case Error(E)
    
    public init(value: T) {
        self = .Success(value)
    }
    
    public init(error: Error) {
        self = .Error(TDError.init(error) as! E)
    }
}

public protocol TDErrorRepresentable {
    var error: Error {get set}
    var code: Int? {get set}
    var description: String? {get set}
}

public struct TDError: TDErrorRepresentable {
    public var error: Error
    public var code: Int?
    public var description: String?
    
    public init(_ error: Error) {
        self.error = error
    }
    
    public init(_ error: Error, code: Int? = nil, description: String? = nil) {
        self.error = error
        self.code = code
        self.description = description
    }
}


