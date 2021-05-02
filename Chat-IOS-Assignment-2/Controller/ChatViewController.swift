//
//  ChatViewController.swift
//  Chat-IOS-Assignment-2
//
//  Created by ADMIN ODoYal on 27.04.2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    static public let identifier = "ChatViewController"
    static public let nib = UINib(nibName: identifier, bundle: Bundle(for: ChatViewController.self))
    private var messageDB = Database.database().reference().child("Messages")
    private var messages = [MessageEntity]()
    private let storage = Storage.storage().reference()
    private var pickedImageURL : String = ""
    
    @IBOutlet private weak var takeImageButton: UIButton!
    @IBOutlet private weak var signOutButton: UIBarButtonItem!
    @IBOutlet private weak var messageTableView: UITableView!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        fetchMessagesFromFirebase()
        configureMesssageTableView()
        configureMessageTextField()
    }
    
    @IBAction func presstakeImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func pressSignOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let err {
            print(err)
        }
    }
    
    @IBAction func pressSendButton(_ sender: Any) {
        if messageTextField.text != "" || pickedImageURL != "" {
            sendMessageToFirebase()
        }else{
            print("Nothing to upload")
        }
    }
    
}

/// MARK ChatViewController
extension ChatViewController {
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func configureMesssageTableView(){
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        messageTableView.addGestureRecognizer(tapOnTableView)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(MessageTableViewCell.nib, forCellReuseIdentifier: MessageTableViewCell.identifier)
    }
    
    private func configureMessageTextField(){
        messageTextField.delegate = self
    }
    
    @objc private func tappedOnTableView(){
        messageTextField.endEditing(true)
    }
    
    private func uploadImageToFireStore(_ image: UIImage) {
        sendButton.isEnabled = false
        guard let pngImageData = image.pngData() else {return}
        takeImageButton.tintColor = .systemRed
        let name = self.randomString(length: 8)
        
        self.storage.child("images/\(name).png").putData(pngImageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.storage.child("images/\(name).png").downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    print("Failed to download iamge URL")
                    return
                }
                
                self.pickedImageURL = url.absoluteString
                self.takeImageButton.tintColor = .systemGreen
                self.sendButton.isEnabled = true
            }
        }
        
    }
    
    private func sendMessageToFirebase() {
        var messageDict = ["message" : "", "imageURL" : "", "sender" : ""]
        guard let email = Auth.auth().currentUser?.email else {return}
        
        messageDict["sender"] = email
        if let message = messageTextField.text {
            messageDict["message"] = message
        }
        messageDict["imageURL"] = pickedImageURL
        
        sendButton.isEnabled = false
        takeImageButton.isEnabled = false
        messageTextField.text = ""
        pickedImageURL = ""
        
        messageDB.childByAutoId().setValue(messageDict) { [self] (error, reference) in
            if error != nil {
                print("Failed to send message")
            }
            sendButton.isEnabled = true
            takeImageButton.isEnabled = true
            takeImageButton.tintColor = .black
            
        }
    }
    
    private func fetchMessagesFromFirebase() {
        messageDB.observe(.childAdded) { [self] (snapshot) in
            if let values = snapshot.value as? [String : String] {
                
                guard let message = values["message"] else {return}
                guard let sender = values["sender"] else {return}
                guard let imageURL = values["imageURL"] else {return}
                messages.append(MessageEntity(message: message, imageURL: imageURL, sender: sender))
                messageTableView.reloadData()
                scrollToLastMessageCell()
            }
        }
        
    }
    
    private func scrollToLastMessageCell(){
        if messages.count - 1 > 0 {
            let indexPath = IndexPath.init(row: messages.count - 1, section: 0)
            messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

/// MARK UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        defer {
            scrollToLastMessageCell()
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) { [self] in
            switch UIScreen.main.nativeBounds.height {
            case 1136:
//                "iPhone 5 or 5S or 5C"
                containerViewHeightConstraint.constant = 50 + 253
            case 1334:
//                "iPhone 6/6S/7/8"
                containerViewHeightConstraint.constant = 50 + 260
            case 1920, 2208:
//                "iPhone 6+/6S+/7+/8+"
                containerViewHeightConstraint.constant = 50 + 271
            case 2436:
//                "iPhone X/XS/11 Pro"
                containerViewHeightConstraint.constant = 50 + 300
            case 2688:
//                "iPhone XS Max/11 Pro Max"
                containerViewHeightConstraint.constant = 50 + 320
            case 1792:
//                "iPhone XR/ 11 "
                containerViewHeightConstraint.constant = 50 + 310
            default:
                containerViewHeightConstraint.constant = 50 + 300
                print("Unknown")
            }
            view.setNeedsLayout()
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        defer {
            scrollToLastMessageCell()
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) { [self] in
            containerViewHeightConstraint.constant = 50
            view.setNeedsLayout()
        }
    }
}

/// MARK UITableViewDelegate, UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
        cell.configure(messages[indexPath.row])
        return cell
    }
}

/// MARK UIImagePickerControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{return}
        takeImageButton.tintColor = .systemBlue
        uploadImageToFireStore(selectedImage)
    }
}

/// UINavigationControllerDelegate
extension ChatViewController: UINavigationControllerDelegate {
    
}
