//
//  User.swift
//  FirebaseFBLogin
//
//  Created by Hyung Jip Moon on 2017-03-24.
//  Copyright © 2017 leomoon. All rights reserved.
//

import Foundation
import FirebaseAuth

class User
{
    static let sharedInstance = User()
    var current: FIRUser?
}
