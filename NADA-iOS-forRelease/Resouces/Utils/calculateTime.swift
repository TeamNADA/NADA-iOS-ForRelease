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

func calculateMinuteTimeToInt(time: String) -> Int {
    let components = time.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }

    let minutes = components[0]
    let seconds = components[1]
    let secondsCaculated = minutes*60 + seconds
    return secondsCaculated
}

extension Date {

    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
}

extension String {
    func toDate() -> Date? { // "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
