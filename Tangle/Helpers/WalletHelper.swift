//
//  WalletHelper.swift
//  Tangle
//
//  Created by Jake on 8/10/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import Foundation

final class WalletHelper {
    
    // MARK: - Properties
    static let sharedInstance = WalletHelper()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Helper Methods
    /**
     generateRandomSeed
     
     - returns: String
     */
    func generateRandomSeed() -> String {
        
        let seed = NSMutableData(length: WalletHelperConstants.SeedEntropyLength)
        var time: NSTimeInterval???? = NSDate.timeIntervalSinceReferenceDate()
        
        SecRandomCopyBytes(kSecRandomDefault, seed!.length, UnsafeMutablePointer<UInt8>(seed!.mutableBytes))
        
        let mnemonic = BTCMnemonic(entropy: seed, password: "", wordListType: .English)
        
        var phrase = ""
        
        for word in mnemonic.words {
            let word = word as! String
            phrase += word
            
            if word != mnemonic.words.last as! String {
                phrase += " "
            }
        }
        
        // We store the wallet creation time on the keychain because keychain data persists even when an app is deleted
        let data = NSData(bytes: &time, length: sizeof(time.dynamicType))
        print("Time before setting Keychain: \(time), data: \(data)")
        setKeychainData(data, key: WalletHelperConstants.SeedCreationTime, authenticated: false)
        
        return phrase
    }
    
    /**
     setKeychainData
     
     - parameter data:          NSData
     - parameter key:           String
     - parameter authenticated: Bool
     
     - returns: Bool
     */
    private func setKeychainData(data: NSData, key: String, authenticated: Bool) -> Bool {
        
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
    
    /**
     getKeychainData
     
     - parameter key:   String
     - parameter error: inout NSError?
     
     - returns: NSData?
     */
    func getKeychainData(key: String, inout error: NSError?) -> NSData? {
        let query: [String: AnyObject] = [String(kSecClass): String(kSecClassGenericPassword),
                                          String(kSecAttrService): String(WalletHelperConstants.SecurityAttributeService),
                                          String(kSecAttrAccount): String(key),
                                          String(kSecReturnData): true]
        
        var result: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionaryRef, &result)
        
        print("Time data after setting Keychain: \(result as? NSData)")
        
        guard status != errSecItemNotFound else { return nil }
        guard status != noErr else { return result as? NSData }
        
        error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
        print("SecItemCopyMatching Error: \(error?.localizedDescription)")
        
        return nil
    }
    
}