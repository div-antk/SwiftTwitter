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
        
        loadData()
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
    
    // ×ボタン
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        // TODO:これがあるとないとでどうなるか検証
        interactiveTransition?.finish()
    }
    
    // 構造体の数だけ返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    // セルの構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        cell.userNameLabel.text =  "\(feeds[indexPath.row].userName)さんの名言"
        
        cell.quoteLabel.text = feeds[indexPath.row].quate
        
        cell.profileImageView.sd_setImage(with: URL(string: feeds[indexPath.row].profileUrl), completed: nil)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TODO:以下3つのメソッドがない場合も確認する
    
    // セルとセルの間の余白
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return view.frame.size.height/10
    }
    
    // 背景色を透明
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    // フッターを完全に表示させないようにする
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return .leastNonzeroMagnitude
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
