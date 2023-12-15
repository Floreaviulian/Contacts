//
//  ContactsModel.swift
//  Contacts
//
//  Created by FloreaIulian on 12/13/23.
//

import Foundation


struct Contact: Codable {
    let id: Int?
    var name: String
    var email: String?
    var phone: String?
    let gender: Gender?
    let status: Status?
    
    var firstName: String? {
        name.components(separatedBy: " ").first
    }
    
    var lastName: String? {
        name.components(separatedBy: " ").last
    }
    
    var shoulUseInitials: Bool {
        if let id = id, id % 2 == 1 {
            return false
        } else {
            return true
        }
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

enum Status: String, Codable {
    case active = "active"
    case inactive = "inactive"
}
