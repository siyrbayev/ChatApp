//
//  MessageTableViewCell.swift
//  Chat-IOS-Assignment-2
//
//  Created by ADMIN ODoYal on 02.05.2021.
//

import UIKit
import Kingfisher
import FirebaseAuth

class MessageTableViewCell: UITableViewCell {
    static public let identifier = "MessageTableViewCell"
    static public let nib = UINib(nibName: identifier, bundle: Bundle(for: MessageTableViewCell.self))
    
    
    public var message: MessageEntity? {
        didSet{
            if let message = message {
                let url = URL(string: message.imageURL ?? "")
                messageLabel.text = message.message
                senderLabel.text = message.sender
                messageImage.kf.setImage(with: url)
                if Auth.auth().currentUser?.email == message.sender {
                    containerView.backgroundColor = UIColor(red: CGFloat(185/255.0), green: CGFloat(205/255.0), blue: CGFloat(255/255.0), alpha: 1.0)
                    messageIconImageView?.tintColor = UIColor(red: CGFloat(185/255.0), green: CGFloat(205/255.0), blue: CGFloat(255/255.0), alpha: 1.0)
                    
                } else {
                    senderLabel.text = message.sender
                    containerView.backgroundColor = .systemGray4
                    messageIconImageView?.tintColor = .systemGray
                }
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageIconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        messageImage.layer.cornerRadius = 8
    }
}

extension MessageTableViewCell {
    public func configure(_ message: MessageEntity) {
        self.message = message
    }
    
    private func configureLayout(){
        selectionStyle = .none
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        messageImage.layer.cornerRadius = 8
    }
    
}
