//
//  ContactsCache.swift
//  Contacts
//
//  Created by FloreaIulian on 12/15/23.
//

import Foundation

final class ContactsCache {
    private let key = "ContactsKey"
    
    func getContacts() -> [Contact] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            let array = try? PropertyListDecoder().decode([Contact].self, from: data)
            return array ?? []
        }
        return []
    }
    
    func saveContacts(_ contacts: [Contact]) {
        let defaults = UserDefaults.standard
        if let data = try? PropertyListEncoder().encode(contacts) {
            defaults.set(data, forKey: key)
        }
    }
}
