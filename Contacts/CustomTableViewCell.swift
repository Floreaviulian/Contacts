//
//  CustomTableCellTableViewCell.swift
//  Contacts
//
//  Created by FloreaIulian on 12/13/23.
//

import UIKit
import Kingfisher
import InitialsImageView

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    func seUp(with: Contact) {
        contactName.text = with.name
        if with.shoulUseInitials {
            contactImage.setImageForName(with.name, circular: true, textAttributes: nil)
        } else {
            contactImage.kf.setImage(with: URL(string: "https://picsum.photos/200/200"), placeholder: nil, options: [.forceRefresh])
        }
    }
}
