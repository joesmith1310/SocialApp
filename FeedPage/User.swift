//
//  User.swift
//  socialApp1
//
//  Created by Joe Smith on 19/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import Foundation

class User {
    
    private var _username : String!
    private var _userImg : String!
    private var _userBio : String!
    private var _userMatch : String!
    private var _userID : String!
    
    var userID: String {
        return _userID
    }
    
    var username: String {
        return _username
    }
    
    var userImg: String {
        return _userImg
    }
    
    var bio : String {
        return _userBio
    }
    
    var match : String {
        return _userMatch
    }
    
    init(username : String, userImg : String, userBio : String, userMatch : Int, userID : String) {
        _username = username
        _userImg = userImg
        _userBio = userBio
        _userMatch = String(userMatch)
        _userID = userID
    }
}
