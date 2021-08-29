//
//  User.swift
//  GitHubApiDemo
//
//  Created by Hsu Hua on 2021/7/7.
//

import Foundation

struct User: Codable {
    var id: Int64
    var accountName: String?
    var avatar: String?
}
