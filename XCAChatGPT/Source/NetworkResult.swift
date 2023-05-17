//
//  NetworkResult.swift
//  XCAChatGPT
//
//  Created by sun on 2023/05/10.
//

enum NetworkResult<T>{
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
