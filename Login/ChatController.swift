//
//  ChatListController.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit

class ChatController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var  tableView:UITableView!
    var tableData:[Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.setTest()
        
        self.title = "Chats"
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame:CGRect(x:0,y: 0,width:self.view.frame.size.width,height: 10))
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func setTest() {
        let contact = Contact()
        contact.name = "Player 1"
        contact.identifier = "12345"
        
        let chat = Chat()
        chat.contact = contact
        
        let texts = ["Hello!",
                     "This project try to implement a chat UI similar to Whatsapp app.",
                     "Is it close enough?"]
        
        var lastMessage:Message!
        for text in texts {
            let message = Message()
            message.text = text
            message.sender = .Someone
            message.status = .Received
            message.chatId = chat.identifier
            
            LocalStorage.sharedInstance.storeMessage(message: message)
            lastMessage = message
        }
        
        chat.numberOfUnreadMessages = texts.count
        chat.lastMessage = lastMessage

        self.tableData.append(chat)
    }

    // MARK - TableViewDataSource

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:NSInteger) -> Int
    {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        let cellIdentifier = "ChatListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ChatCell
        cell.chat = self.tableData[indexPath.row]
        
        return cell
    }

    // MARK - UITableViewDelegate

    func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        self.tableView.deselectRow(at: indexPath as IndexPath, animated:true)
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "Message") as! MessageController
        controller.chat = self.tableData[indexPath.row]
        self.navigationController!.pushViewController(controller, animated:true)
    }
}
