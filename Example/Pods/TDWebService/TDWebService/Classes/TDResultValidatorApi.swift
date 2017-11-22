//
//  ResponseValidatorApi.swift
//  TDServiceAPI
//
//  Created by Yapapp on 13/11/17.
//

import Foundation
import TDResult

public protocol TDResultValidatorApi{
    func validateResponse(_ result: TDWSResponse) -> TDResult<TDWSResponse, TDError>
}
