//
//  ViewController.swift
//  Contacts
//
//  Created by FloreaIulian on 12/13/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private var data = [Contact]()
    private let client = ContactsClient()
    private let cache = ContactsCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        populateContacts()
    }
    
    @objc private func addNewContact() {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController else { return }
        next.onSave = { [weak self] contact in
            guard let self = self else { return }
            
            self.data.append(contact)
            self.tableView.insertRows(at: [IndexPath(row: self.data.count - 1, section: 0)], with: .automatic)
            self.cache.saveContacts(self.data)
        }
        navigationController?.pushViewController(next, animated: true)
     }
    
    private func populateContacts() {
        data = cache.getContacts()
        
        guard data.isEmpty else {
            tableView.reloadData()
            return
        }
        
        client.fetchContacts(URL: "https://gorest.co.in/public/v2/users") { [weak self] results in
            DispatchQueue.main.async {
                self?.data = results
                self?.tableView.reloadData()
                self?.cache.saveContacts(results)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        let headerLabel = UILabel()
        headerLabel.textColor = .systemGray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        headerView.addConstraints([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 21),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 10),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        headerLabel.text = "Contactele mele"
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CustomTableViewCell
        cell.seUp(with: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController else { return }
        next.contact = data[indexPath.row]
        next.onSave = { [weak self] contact in
            guard let self = self else { return }
            
            self.data[indexPath.row] = contact
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.cache.saveContacts(self.data)
        }
        navigationController?.pushViewController(next, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
