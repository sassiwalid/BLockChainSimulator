//
//  Blockchain.swift
//  Blockchain
//
//  Created by walid sassi on 10/4/19.
//  Copyright © 2019 walid sassi. All rights reserved.
//

import Foundation


class Blockchain {
    var blockChain = [Block]()
    
    func createInitialBlock(data:String){
        let block = Block()
        block.data = data
        block.hash = block.generateHash()
        block.previousHash = "0000"
        block.index = 0
        blockChain.append(block)
    }
    
    func addBlock(data:String){
        let block = Block()
        block.data = data
        block.hash = block.generateHash()
        block.previousHash = blockChain[blockChain.count - 1].hash
        block.index = blockChain.count
        blockChain.append(block)
    }
}
