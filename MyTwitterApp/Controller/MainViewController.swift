//
//  MainViewController.swift
//  MyTwitterApp
//
//  Created by setoon on 2022/12/03.
//

import Foundation
import UIKit
import RealmSwift

class MainViewController: UIViewController{
    
    var tweetList:[TweetModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBAction func tweetButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TweetViewController", bundle: nil)
        guard let tweetViewController = storyboard.instantiateInitialViewController() as? TweetViewController else {return}
        tweetViewController.delegate = self
        present(tweetViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"MainTableViewCell",bundle: nil), forCellReuseIdentifier: "customCell")
        configureTweetButton()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTweet()
        tableView.reloadData()
    }
    
    var dateFormatter: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy年MM月dd日HH時mm分"
        return dateFormatter
    }
    
    func configureTweetButton(){
        tweetButton.layer.cornerRadius = tweetButton.bounds.width / 2
    }
    
    func setTweet(){
        let realm = try! Realm()
        let result = realm.objects(TweetModel.self)
        tweetList = Array(result)
        tableView.reloadData()
    }
}


extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let tweetModel: TweetModel = tweetList[indexPath.row]
        cell.nameLabel.text = tweetModel.name
        cell.tweetLabel.text = tweetModel.tweet
        cell.dateLabel.text = dateFormatter.string(from: tweetModel.date)
        return cell
    }
    
    
}

extension MainViewController: TweetViewControllerDelegate{
    func updateTweet() {
        setTweet()
    }
}
