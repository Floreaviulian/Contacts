//
//  ContactsClient.swift
//  Contacts
//
//  Created by FloreaIulian on 12/13/23.
//

import UIKit

class ContactsClient: NSObject {
    func fetchContacts(URL url: String, completion: @escaping ([Contact]) -> Void) {
        // fetch the data
        let url = URL(string: url)!

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let contact = try? JSONDecoder().decode([Contact].self, from: data) {
                    print(contact)
                    completion(contact)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
}
