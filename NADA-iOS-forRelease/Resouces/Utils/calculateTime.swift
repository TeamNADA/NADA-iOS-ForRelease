//
//  calculateTime.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/14.
//

import Foundation

func calculateTime(sec: Int) -> String {
    let hour = sec / 3600
    let minute = (sec % 3600) / 60
    let second = (sec % 3600) % 60
    return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
}

func calculateMinuteTime(sec: Int) -> String {
    let minute = (sec % 3600) / 60
    let second = (sec % 3600) % 60
    return "\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
}
