//
//  ResponseValidatorApi.swift
//  TDServiceAPI
//
//  Created by Yapapp on 13/11/17.
//

import Foundation

public protocol ResultValidatorApi{
    func isResponseValid(_ result: WSResult) -> TDResult<Bool, TDError>
}

struct DefaultResultValidatorApi: ResultValidatorApi{
    func isResponseValid(_ result: WSResult) -> TDResult<Bool, TDError>{
        return TDResult.init(value: true)
    }
}
