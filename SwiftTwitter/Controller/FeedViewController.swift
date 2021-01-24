//
//  FeedViewController.swift
//  SwiftTwitter
//
//  Created by Takuya Ando on 2021/01/22.
//

import UIKit
import BubbleTransition
import Firebase
import SDWebImage
import ViewAnimator
import FirebaseFirestore

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var interactiveTransition:BubbleInteractiveTransition?
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    
    var feeds:[Feeds] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセル
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        
        // TODO:これがあることでどうなるのか後ほど確認
        tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
        // 投稿されたものを受信する
        db.collection("feed").order(by: "createAt").addSnapshotListener { (snapShot, error) in
            
            self.feeds = []
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            // documentをすべて取得してsnapShotの中に入れる
            if let snapShotDoc = snapShot?.documents {
                
                // documentのidの数だけforを回す
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    
                    // 中身が完全にある場合
                    if let userName = data["userName"] as? String,
                       let quote = data["quote"] as? String,
                       let photoURL = data["photoURL"] as? String {
                        
                        let newFeeds = Feeds(userName: userName, quate: quote, profileUrl: photoURL)
                        self.feeds.append(newFeeds)
                        // 新しいものから順番に表示したいためreverse
                        self.feeds.reverse()
                        
                        // メインスレッドであるUIの処理が終わってから
                        DispatchQueue.main.async {
                            self.tableView.tableFooterView = nil
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
