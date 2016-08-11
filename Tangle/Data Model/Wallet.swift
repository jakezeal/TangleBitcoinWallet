//
//  Wallet.swift
//  Tangle
//
//  Created by Jake on 8/8/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import Foundation

final class Wallet {

    let mnemonic: BTCMnemonic!
    
    let seed: NSData!
    let keychain: BTCKeychain!
    
    let mnemonicString: String!
    
    let passcodeEnabled = false
    
    // Creating Wallet
    init(generateKeyInWalletWithEntropySeed seed: NSData, andPassword password: String) {
        
        mnemonic = BTCMnemonic(entropy: seed, password: password, wordListType: .English)
        self.seed = mnemonic.seed
        keychain = BTCKeychain(seed: mnemonic.seed)
        
        var mnemonicString = String()
        
        if let mnemonic = mnemonic {
            
            for word in mnemonic.words {
                let word = word as! String
                mnemonicString += word
                
                if word != mnemonic.words.last as! String {
                    mnemonicString += " "
                }
            }
        }
        
        self.mnemonicString = mnemonicString
        print(mnemonicString)
    }

}