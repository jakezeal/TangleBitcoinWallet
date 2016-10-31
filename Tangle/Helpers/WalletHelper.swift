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
    fileprivate init() {}
    
    // MARK: - Helper Methods
    /**
     @name  generateRandomSeed
     
     - returns: String
     */
    func generateRandomSeed() -> String {
        
        // Create initial entropy / seed -> Equivalent to BTCRandomDataWithLength
        var entropy = Data(count: WalletHelperConstants.SeedEntropyLength)
        let result = SecRandomCopyBytes(kSecRandomDefault, entropy.count, entropy.withUnsafeMutableBytes({ $0 }))
    
        // Ensure there was no error
        assert(result == 0, "Error with SecRandomCopyBytes: \(String(result))")
        
//        let keychain = BTCKeychain(seed: entropy as Data!, network: BTCNetwork.testnet())
        
        var time: TimeInterval = Date.timeIntervalSinceReferenceDate
        
        let mnemonic = BTCMnemonic(entropy: entropy, password: "", wordListType: .english)
        
        var phrase = ""
        
        print("Mnemonic Seed: \(mnemonic?.seed)")
        print("Entropy: \(mnemonic?.entropy)\n")
        print("Keychain: \(mnemonic?.keychain)\n")
        print("Data: \(mnemonic?.data)\n")
        print("DataWithSeed: \(mnemonic?.dataWithSeed)\n\n\n\n")
        
        for word in (mnemonic?.words)! {
            let word = word as! String
            phrase += word
            
            if word != mnemonic?.words.last as! String {
                phrase += " "
            }
        }
        
        // We store the wallet creation time on the keychain because keychain data persists even when an app is deleted
        
        let data = Data(bytes: &time, count: MemoryLayout<TimeInterval>.size)
        print("Time before setting Keychain: \(time), data: \(data)")
        let bool = setKeychainData(data: data, key: WalletHelperConstants.SeedCreationTime, authenticated: false)
        print("Keychain data set: \(bool)")
        return phrase
    }
    
    // MARK: - Set Keychain Data
    /**
     @name  setKeychainData
     
     - parameter data:          Data
     - parameter key:           String
     - parameter authenticated: Bool
     
     - returns: Bool
     */
    fileprivate func setKeychainData(data: Data, key: String, authenticated: Bool) -> Bool {
        
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
                        String(kSecValueData): data] as [String : Any]
            let status = SecItemAdd(item as CFDictionary, nil)
            
            guard status != noErr else { return true }
            
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil).localizedDescription
            print("SecItemAdd error: \(error)")
            
            return false
        }
        
        
        let update = [String(kSecAttrAccessible): accessible,
                      String(kSecValueData): data] as [String : Any]
        
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        
        guard status != noErr else { return true }
        
        let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil).localizedDescription
        print("SecItemUpdate Error: \(error)")
        
        return false
    }
    
    /**
     @name  getKeychainData
     
     - parameter key:   String
     - parameter error: inout NSError?
     
     - returns: NSData?
     */
    func getKeychainData(key: String, error: inout NSError?) -> Data? {
        let secClass = String(kSecClass)
        let secClassGenericPassword = String(kSecClassGenericPassword)
        let query: [String: Any] = [secClass: secClassGenericPassword,
                                          String(kSecAttrService): WalletHelperConstants.SecurityAttributeService,
                                          String(kSecAttrAccount): key,
                                          String(kSecReturnData): true]
        
        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)
//        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, result as CFTypeRef?)
        
        print("Time data after setting Keychain: \(result as? Data)")
        
        guard status != errSecItemNotFound else { return nil }
        guard status != noErr else { return result as? Data }
        
        error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
        print("SecItemCopyMatching Error: \(error?.localizedDescription)")
        
        return nil
    }
    
}
