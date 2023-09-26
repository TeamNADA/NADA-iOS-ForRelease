//
//  NetworkResult.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation

public enum NetworkResult<T> {
    case success(T)                 // 서버 통신 성공
    case requestErr(T)              // 요청 에러 발생
    case pathErr                    // 경로 에러
    case serverErr                  // 서버의 내부적 에러
    case networkFail                // 네트워크 연결 실패
}
