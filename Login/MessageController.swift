//
//  MessageController.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

class MessageController:UIViewController, InputbarDelegate, MessageGatewayDelegate, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var inputbar:Inputbar!
    
    var FriendsID = ""
    var FriendName = ""
    var FriendImage = ""
    
    var chat:Chat! {
        didSet {
             self.title = self.chat.contact.name
        }
    }
    
    private var tableArray:TableArray!
    private var gateway:MessageGateway!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.setInputbar()
        self.setTableView()
        self.setGateway()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)

        self.view.keyboardTriggerOffset = inputbar.frame.size.height
        self.view.addKeyboardPanning() {[unowned self](keyboardFrameInView:CGRect, opening:Bool, closing:Bool) in
            /*
             self.view.removeKeyboardControl()
             */
            
            var toolBarFrame = self.inputbar.frame
            toolBarFrame.origin.y  = keyboardFrameInView.origin.y - toolBarFrame.size.height
            self.inputbar.frame = toolBarFrame
            
            var tableViewFrame = self.tableView.frame
            tableViewFrame.size.height = toolBarFrame.origin.y - 64
            self.tableView.frame = tableViewFrame
            
            self.tableViewScrollToBottomAnimated(animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        self.view.removeKeyboardControl()
        self.gateway.dismiss()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        self.chat.lastMessage = self.tableArray!.lastObject()
    }

    // MARK -

    func setInputbar() {
        self.inputbar.placeholder = nil
        self.inputbar.inputDelegate = self
        self.inputbar.leftButtonImage = UIImage(named:"share")
        self.inputbar.rightButtonText = "Send"
        self.inputbar.rightButtonTextColor = UIColor(red:0, green:124/255, blue:1, alpha:1)
    }
    
    func setTableView() {
        self.tableArray = TableArray()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect(x:0, y:0,width:self.view.frame.size.width,height:10))
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
    
        self.tableView.register(MessageCell.self, forCellReuseIdentifier:"MessageCell")
    }
    
    func setGateway() {
        self.gateway = MessageGateway.sharedInstance
        self.gateway.delegate = self
        self.gateway.chat = self.chat
        self.gateway.loadOldMessages()
    }

    // MARK - Actions

    @IBAction func userDidTapScreen(_ sender: Any) {
        self.inputbar.inputResignFirstResponder()
    }

    // MARK - TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableArray.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.numberOfMessagesInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.message = self.tableArray.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
        return cell;
    }

    // MARK - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.tableArray.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
        return message.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableArray.titleForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 40)
        
        let view = UIView(frame:frame)
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = .flexibleWidth
        
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textAlignment = .center
        label.font = UIFont(name:"Helvetica", size:20)
        label.sizeToFit()
        label.center = view.center
        label.font = UIFont(name:"Helvetica", size:13)
        label.backgroundColor = UIColor(red:207/255, green:220/255, blue:252/255, alpha:1)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.autoresizingMask = []
        view.addSubview(label)
        
        return view
    }

    func tableViewScrollToBottomAnimated(animated:Bool) {
        let numberOfSections = self.tableArray.numberOfSections
        let numberOfRows = self.tableArray.numberOfMessagesInSection(section: numberOfSections-1)
        if numberOfRows > 0 {
            self.tableView.scrollToRow(at: self.tableArray.indexPathForLastMessage() as IndexPath, at:.bottom, animated:animated)
        }
    }

    // MARK - InputbarDelegate

    func inputbarDidPressRightButton(inputbar:Inputbar) {
        let message = Message()
        message.text = inputbar.text
        message.date = NSDate()
        message.chatId = self.chat.identifier
        
        //Store Message in memory
        self.tableArray.addObject(message: message)
        
        //Insert Message in UI
        let indexPath = self.tableArray.indexPathForMessage(message: message)
        self.tableView.beginUpdates()
        if self.tableArray.numberOfMessagesInSection(section: indexPath.section) == 1 {
            self.tableView.insertSections(NSIndexSet(index:indexPath.section) as IndexSet, with:.none)
        }
        self.tableView.insertRows(at: [indexPath as IndexPath], with:.bottom)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: self.tableArray.indexPathForLastMessage() as IndexPath, at:.bottom, animated:true)
        
        //Send message to server
        self.gateway.sendMessage(message: message)
    }
    func inputbarDidPressLeftButton(inputbar:Inputbar) {
        let alertView = UIAlertView(title: "Left Button Pressed", message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    func inputbarDidChangeHeight(newHeight:CGFloat) {
        //Update DAKeyboardControl
        self.view.keyboardTriggerOffset = newHeight
    }

    // MARK - MessageGatewayDelegate

    func gatewayDidUpdateStatusForMessage(message:Message) {
        let indexPath = self.tableArray.indexPathForMessage(message: message)
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! MessageCell
        cell.updateMessageStatus()
    }
    
    func gatewayDidReceiveMessages(array:[Message]) {
        self.tableArray.addObjectsFromArray(messages: array)
        
        self.tableView.reloadData()
    }
}
