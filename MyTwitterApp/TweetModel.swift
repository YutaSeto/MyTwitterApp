//
//  TweetModel.swift
//  MyTwitterApp
//
//  Created by setoon on 2022/12/04.
//

import Foundation
import RealmSwift

class TweetModel: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var tweet: String = ""
    @objc dynamic var date: Date = Date()
}
