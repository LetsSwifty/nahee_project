//
//  LogType.swift
//  CH07-CoreData
//
//  Created by 김나희 on 10/15/22.
//

import Foundation

enum LogType: Int16 {
    case create
    case edit
    case delete
}

extension Int16 {
    func toLogType() -> String {
        switch self {
        case 0:
            return "생성"
        case 1:
            return "수정"
        case 2:
            return "삭제"
        default:
            return ""
        }
    }
}
