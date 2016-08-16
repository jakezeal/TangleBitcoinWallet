//
//  NSData+ConvertData.swift
//  Tangle
//
//  Created by Jake on 8/11/16.
//  Copyright © 2016 Jake. All rights reserved.
//

extension NSData {
    func convertDataToType<T>() -> T {
        var valueOfType: T!
        getBytes(&valueOfType, length: sizeof(valueOfType.dynamicType))
        return valueOfType
    }
}