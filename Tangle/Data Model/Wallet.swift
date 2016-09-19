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
    
    init(generateKeyInWalletWithEntropySeed seed: NSData, andPassword password: String) {
        
        // create another init for keychain retreival
        
        mnemonic = BTCMnemonic(entropy: seed, password: password, wordListType: .English)
        
        
        print("Words: \(mnemonic.words) \n")
        print("Seed: \(mnemonic.seed) \n")
        print("Entropy: \(mnemonic.entropy) \n")
        
        self.seed = mnemonic.seed
        keychain = BTCKeychain(seed: mnemonic.seed)
        
        var mnemonicWords = ""
        
        if let mnemonic = mnemonic {
            
            for word in mnemonic.words {
                let word = word as! String
                mnemonicWords += word
                
                if word != mnemonic.words.last as! String {
                    mnemonicWords += " "
                }
            }
        }
        
        self.mnemonicString = mnemonicWords
        print("Words String: \(mnemonicWords) \n")
    }
}