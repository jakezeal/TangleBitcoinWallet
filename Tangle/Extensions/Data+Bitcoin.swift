//
//  Data+Bitcoin.swift
//  Tangle
//
//  Created by Jake on 8/11/16.
//  Copyright © 2016 Jake. All rights reserved.
//

extension Data {
    func scanValue<T>(start: Int, length: Int) -> T {
        return subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
}
