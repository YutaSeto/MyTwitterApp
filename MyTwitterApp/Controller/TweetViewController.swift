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
    var tweetIndexPath: Optional<Int> = nil
    
    @IBOutlet weak var tweetLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    var delegate: TweetViewControllerDelegate?
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButton(_ sender: UIButton) {
        tapAddButton()
    }
    @IBOutlet weak var maxLengthLabel: UILabel!
    @IBOutlet weak var nowLengthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarButton()
        maxLengthLabel.text = String(maxLength)
        nowLength = tweetLabel.text!.count
        nowLengthLabel.text = String(maxLength - nowLength)
        tweetLabel.delegate = self
        configure(deta:tweetData)
        displayData()
        self.TweetList = realm.objects(TweetModel.self)
    }
    
    var TweetList: Results<TweetModel>!
    var tweetData = TweetModel()
    let realm = try! Realm()
    
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
        tweetLabel.text = tweetData.tweet
    }
    
    func setNavigationBarButton(){
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func tapAddButton(){
        if maxLength - nowLength >= 0 {
            if tweetIndexPath != nil{
                try! realm.write{
                    TweetList[Int(tweetIndexPath!)].name = nameLabel.text!
                    TweetList[Int(tweetIndexPath!)].tweet = tweetLabel.text!
                    TweetList[Int(tweetIndexPath!)].date = Date()
                }
            }else{
                
                try! realm.write{
                    tweetData.name = nameLabel.text!
                    tweetData.tweet = tweetLabel.text!
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

extension TweetViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField){
        nowLength = tweetLabel.text!.count
        nowLengthLabel.text = String(maxLength - nowLength)
    }
}
