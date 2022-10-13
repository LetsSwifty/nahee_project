//
//  ViewController.swift
//  SQLite3
//
//  Created by 김나희 on 10/13/22.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbPath = setupDBPath()
        dbExcute(dbPath: dbPath)
    }
}


extension ViewController {
    
    // sqlite db 파일 찾기 (sqlite는 하나의 파일이 곧 하나의 데이터 베이스)
    func setupDBPath() -> String {
        let fileManager = FileManager() // 1. 파일 매니저 객체 생성
        let docPathURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! // 2. 앱 내의 문서 디렉터리 경로 찾기 (= NSSearchPathForDirectoriesInDomains)
        let dbPath = docPathURL.appending(path: "db.sqlite").path // 3. db.sqlite 경로를 추가한 데이터베이스 경로 생성
        
        // dbPath 경로에 데이터베이스 없다면 (최초 접속 시)
        if !fileManager.fileExists(atPath: dbPath) {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileManager.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        return dbPath
    }
    
    func dbExcute(dbPath: String) {
        // sqlite3 함수: 결과 값으로 반환하는 것이 아닌 입력된 인자값에 담아주는 방식의 C기반 코드 -> 반환값 성공,실패,오류

        // db 연결 객체
        var db: OpaquePointer? = nil
        
        // db 객체 생성 및 연결
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("Database Connect Fail")
            return
        }
        
        defer {
            print("Close DB Connection!")
            sqlite3_close(db) // db 연결 종료, db 객체 해제
        }
        
        // 컴파일된 sql 구문 저장 객체
        var stmt: OpaquePointer? = nil
        // sql 구문: num이라는 이름의 INTEGER 칼럼을 가지는 sequence라는 이름의 테이블 정의하라. (IF NOT EXISTS 일때)
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        
        // sql 구문 전달 준비, stmt 객체 생성
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("Prepare Statement Fail")
            return
        }
        
        defer {
            print("Finalize Statement")
            sqlite3_finalize(stmt) // sql 구문 삭제, stmt 객체 해제
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE { // sql 구문 전달이 끝나면
            print("Create Table Success")
        }
    }
}
