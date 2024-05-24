//
//  main.swift
//  ConvertQuantumultXRule
//
//  Created by Ray Jiang on 2024/5/22.
//

import Foundation

let scriptName = "NA"

let rule = #"""

"""#

func convert() {
    let lines = rule.components(separatedBy: "\n")
    var rewriteList: [String] = []
    var scriptList: [String] = []
    var hostname = ""
    var preLine = ""
    for line in lines {
        if line.hasPrefix("hostname") && line.contains("=") {
            hostname = "hostname = %APPEND%" + line.components(separatedBy: "=").last!
        }
        if line.contains("#") {
            preLine = line
        } else {
            if line.contains("url reject") {
                // ^https?:\/\/api\.*weibo\.c(n|om)\/\d\/ad - reject
                if !preLine.isEmpty {
                    rewriteList.append(preLine)
                }
                rewriteList.append(line.components(separatedBy: " ").first! + " - reject")
            } else if line.contains(" url script-response-body ") {
                if !preLine.isEmpty {
                    scriptList.append(preLine)
                }
                let tmp = line.components(separatedBy: " url script-response-body ")
                scriptList.append(scriptName + "=type=http-response,pattern=" + tmp.first! + ",requires-body=1,script-path=" + tmp.last!)
            }
            preLine = ""
        }
    }
    
    if !rewriteList.isEmpty {
        print("[Url Rewrite]")
        for item in rewriteList {
            print(item)
        }
        print("")
    }
    if !scriptList.isEmpty {
        print("[Script]")
        for item in scriptList {
            print(item)
        }
        print("")
    }
    if !hostname.isEmpty {
        print("[MITM]")
        print(hostname)
    }
    print("")
}

convert()
