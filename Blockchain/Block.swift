//
//  Block.swift
//  Blockchain
//
//  Created by walid sassi on 10/4/19.
//  Copyright © 2019 walid sassi. All rights reserved.
//

import Foundation


class Block {
    var data : String!
    var hash: String!
    var previousHash: String!
    var index: Int!
    
    func generateHash() -> String {
        return NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
