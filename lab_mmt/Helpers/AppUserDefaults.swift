//
//  AppUserDefaults.swift
//  BKSchedule
//
//  Created by Imbaggaarm on 6/17/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class AppUserDefaults {
    private init() {}
    
    static let sharedInstance = AppUserDefaults()
    
    private let userDefaults = UserDefaults.standard
    
    private let kUSER_ACCOUNT = "USER_ACCOUNT";
    private let kPASSWORD = "PASSWORD"
    private let kEMAIL = "EMAIL"
    
    func getUserAccount() -> (email: String, password: String)? {
        if let value = userDefaults.value(forKey: kUSER_ACCOUNT) as? [String: String],
            let email = value[kEMAIL],
            let password = value[kPASSWORD] {
           return (email, password)
        }
        return nil
    }
    
    func setUserAccount(email: String, password: String) {
        let dict = [kEMAIL: email, kPASSWORD: password]
        userDefaults.setValue(dict, forKey: kUSER_ACCOUNT)
    }
    
    func removeUserAccount() {
        userDefaults.setValue(nil, forKey: kUSER_ACCOUNT)
    }
    
    
    func clearCache() {
        removeUserAccount()
    }
    
    func retrieve(imageNamed name: String) -> UIImage? {
        guard let imagePath = path(for: name) else {
            return nil
        }
        
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    func store(data: Data, name: String) throws -> URL {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(name)
        do {
            try data.write(to: fileURL)
            return fileURL
        }
        catch (let error) {
            throw error
        }
    }
    
    private func path(for imageName: String, fileExtension: String = "jpeg") -> URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent("\(imageName).\(fileExtension)")
    }
    
}
