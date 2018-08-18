//
//  MessageViewController.swift
//  ParseHeroku
//
//  Created by Daniel Lau on 8/17/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import UIKit
import Parse

class MessageViewController: UIViewController {
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    lazy var refreshControl : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchMessage), for: .valueChanged)
        refresh.tintColor = UIColor.blue
        return refresh
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.addSubview(refreshControl)
        fetchMessage()
    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let message = Message()
        guard let currentUser = PFUser.current()?.username else { return }
        message.username = currentUser
        message.message = messageTextField.text ?? ""
        message.saveInBackground { (success, error) in
            if let error = error {
                print("error posting message", error.localizedDescription)
                return
            }
            
            if success {
                print("sucess posting message")
                self.messageTextField.text = ""
            }
        }
    }
    
    @objc func fetchMessage() {
        let predicate = NSPredicate(format: "text != ''")
        let query = Message.query(with: predicate)
        query?.findObjectsInBackground(block: { (messages, error) in
            
            if let messages = messages {
                MessageController.messages = messages
                print("success fetching")
                self.messageTableView.reloadData()
            }
            
            if let error = error {
                print(error.localizedDescription, "error fetching messages")
            }
        })
        refreshControl.endRefreshing()
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        let message = MessageController.messages[indexPath.row] as! Message
        cell.messageLabel.text = message.message
        cell.userLabel.text = message.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
