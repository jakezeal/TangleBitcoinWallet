//
//  WalletHelper.swift
//  Tangle
//
//  Created by Jake on 8/10/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import Foundation

class WalletHelper {
    
    // MARK: - Properties
    static let sharedInstance = WalletHelper()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Helper Methods
    func generateRandomSeed() -> String {
        
        let seed = NSMutableData(length: WalletHelperConstants.SeedEntropyLength)
        var time = NSDate.timeIntervalSinceReferenceDate()
        
        SecRandomCopyBytes(kSecRandomDefault, seed!.length, UnsafeMutablePointer<UInt8>(seed!.mutableBytes))
        
        let mnemonic = BTCMnemonic(entropy: seed, password: "", wordListType: .English)
        
        var phrase = String()
        
        for word in mnemonic.words {
            let word = word as! String
            phrase += word
            
            if word != mnemonic.words.last as! String {
                phrase += " "
            }
        }
        
        // We store the wallet creation time on the keychain because keychain data persists even when an app is deleted
        let data = NSData(bytes: &time, length: 8)
        setKeychainData(data, key: WalletHelperConstants.SeedCreationTime, authenticated: false)
        
        return phrase
    }

}

extension WalletHelper {
    // MARK: - Private Helper Methods
    private func setKeychainData(data: NSData, key: String, authenticated: Bool) -> Bool {
        
        guard key.isEmpty else { return false }
        
        let accessible = authenticated
            ? String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
            : String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        
        
        let query = [String(kSecClass): String(kSecClassGenericPassword),
                                 String(kSecAttrService): WalletHelperConstants.SecurityAttributeService,
                                 String(kSecAttrAccount): key]
        
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecItemNotFound {
            
            let item = [String(kSecClass): String(kSecClassGenericPassword),
                        String(kSecAttrService): WalletHelperConstants.SecurityAttributeService,
                        String(kSecAttrAccount): key,
                        String(kSecAttrAccessible): accessible,
                        String(kSecValueData): data]
            let status = SecItemAdd(item as CFDictionary, nil)
            
            guard status != noErr else { return true }
            
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil).localizedDescription
            print("SecItemAdd error: \(error)")
            
            return false
        }
        
    
        let update = [String(kSecAttrAccessible): accessible,
                      String(kSecValueData): data]
        
        let status = SecItemUpdate(query as CFDictionaryRef, update as CFDictionaryRef)
        
        guard status != noErr else { return true }
        
        let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil).localizedDescription
        print("SecItemUpdate Error: \(error)")
        
        return false
    }
}