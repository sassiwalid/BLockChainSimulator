//
//  ViewController.swift
//  Blockchain
//
//  Created by walid sassi on 10/4/19.
//  Copyright © 2019 walid sassi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Variables
    let firstAccount = "1000"
    let secondAccount = "900"
    let bitcoinChain = Blockchain()
    let reward = 150
    //intialize dictionary of Accounts
    var accounts :[String:Int] = ["0000": 1000000]
    
    
    //MARK:IBOUtlets
    @IBOutlet weak var firstAccountBalanceLabel: UILabel!
    @IBOutlet weak var FirstCoinsToSendTextField: UITextField!
    @IBOutlet weak var SecondCoinsToSendTextField: UITextField!
    @IBOutlet weak var secondAccountBalanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        //First launch the Genesis transaction
        transaction(from: "0000", to: firstAccount, amount: 100, type: "genesis")
        transaction(from: firstAccount, to: secondAccount, amount: 50, type: "normal")
        UpdateBTCBalanceStatus()
    }
    
    func transaction (from:String,to:String,amount:Int, type:String){
        //Some checks before validate the transaction
        guard let account = accounts[from] else{
            return
        }
        if account - amount < 0 {
            return
        }
        // validate the transaction
        accounts.updateValue(account - amount, forKey: from)
        // Now change the receiver account
        guard let accountTo = accounts[to] else{
            accounts[to] = amount
            return
        }
        accounts.updateValue(accountTo + amount, forKey: to)
        // Now add block to our blockchain
        if type == "genesis" {
            bitcoinChain.createInitialBlock(data: "from : \(from) to: \(to)")
        }else if type == "normal"{
            bitcoinChain.addBlock(data: "from : \(from) to: \(to) amount:\(amount)")
        }
        
    }
    // Update the balance for each Account
    func UpdateBTCBalanceStatus(){
        firstAccountBalanceLabel.text = "Balance: \(accounts[firstAccount] ?? 0) BTC"
        secondAccountBalanceLabel.text = "Balance: \(accounts[secondAccount] ?? 0) BTC"
    }
    
    func BlockChainValidity()->Bool{
        for (index,element) in bitcoinChain.blockChain.enumerated() where index > 0{
            // check hash previous element
            if element.previousHash != bitcoinChain.blockChain[index - 1].hash{
                return false
            }
        }
        return true
    }
    @IBAction func FirstSendCoinsButtonClicked(_ sender: Any) {
        if FirstCoinsToSendTextField.text != "" {
            transaction(from: firstAccount, to: secondAccount, amount: Int(FirstCoinsToSendTextField!.text!) ?? 0, type: "normal")
            UpdateBTCBalanceStatus()
            FirstCoinsToSendTextField.text = ""
        }
    }
    
    @IBAction func SecondSEndCoinsButtonClicked(_ sender: Any) {
        if SecondCoinsToSendTextField.text != "" {
            transaction(from: secondAccount, to: firstAccount, amount: Int(SecondCoinsToSendTextField!.text!) ?? 0, type: "normal")
            UpdateBTCBalanceStatus()
            SecondCoinsToSendTextField.text = ""
        }
    }
    
    @IBAction func FirstAccountMineButtonClicked(_ sender: Any) {
        transaction(from: "0000", to: firstAccount, amount: 100, type: "normal")
        UpdateBTCBalanceStatus()
    }
    
    @IBAction func secondAccountMineButtonClicked(_ sender: Any) {
        transaction(from: "0000", to: secondAccount, amount: 100, type: "normal")
        UpdateBTCBalanceStatus()
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
