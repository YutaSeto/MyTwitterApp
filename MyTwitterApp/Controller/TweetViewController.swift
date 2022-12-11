//
//  TweetViewController.swift
//  MyTwitterApp
//
//  Created by setoon on 2022/12/03.
//

import Foundation
import UIKit
import RealmSwift

protocol TweetViewControllerDelegate {
    func updateTweet()
}

class TweetViewController: UIViewController{
    
    var maxLength: Int = 140
    var nowLength: Int = 0
    var tweet: TweetModel?
    
    var tweetList: Results<TweetModel>!
    private var tweetData = TweetModel()
    
    let realm = try! Realm()
    
    var delegate: TweetViewControllerDelegate?
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var maxLengthLabel: UILabel!
    @IBOutlet weak var nowLengthLabel: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
        tapAddButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarButton()
        maxLengthLabel.text = String(maxLength)
        nowLength = tweetTextView.text!.count
        nowLengthLabel.text = String(maxLength - nowLength)
        tweetTextView.delegate = self
        configure(deta:tweetData)
        configureTextView()
        displayData()
        self.tweetList = realm.objects(TweetModel.self)
        
    }

    
    var dateFormatter: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日HH時mm分"
        dateFormatter.locale = Locale(identifier: "ja-JP")
        return dateFormatter
    }
    
    func configure(deta: TweetModel){
        tweetData.name = deta.name
        tweetData.tweet = deta.tweet
        tweetData.date = deta.date
    }
    
    func displayData(){
        nameLabel.text = tweetData.name
        tweetTextView.text = tweetData.tweet
    }
    
    func configureTextView(){
        tweetTextView.layer.borderWidth = 0.8
        tweetTextView.layer.borderColor = UIColor.lightGray.cgColor
        tweetTextView.layer.opacity = 0.3
        tweetTextView.layer.cornerRadius = 5
        tweetTextView.textColor = UIColor.black
    }
    
    func setNavigationBarButton(){
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func tapAddButton(){
        if maxLength - nowLength >= 0 {
            if tweet != nil{
                try! realm.write{
                    tweet!.name = nameLabel.text!
                    tweet!.tweet = tweetTextView.text!
                    tweet!.date = Date()
                }
            }else{
                
                try! realm.write{
                    tweetData.name = nameLabel.text!
                    tweetData.tweet = tweetTextView.text!
                    tweetData.date = Date()
                    realm.add(tweetData)
                }
            }
            delegate?.updateTweet()
            dismiss(animated: true)
        } else {
            let alertController:UIAlertController = UIAlertController(title: "文字数が140文字を超えています", message: "文字数を減らして再度入力してください", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:"やり直す",style: .cancel){action in
                return
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
        }
    }
    
}

extension TweetViewController: UITextViewDelegate{
    func textViewDidChangeSelection(_ tweetTextView: UITextView) {
        nowLength = tweetTextView.text!.count
        nowLengthLabel.text = String(maxLength - nowLength)
    }
}
