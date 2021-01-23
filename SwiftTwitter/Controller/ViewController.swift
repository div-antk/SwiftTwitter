//
//  ViewController.swift
//  SwiftTwitter
//
//  Created by Takuya Ando on 2021/01/19.
//

import UIKit
import BubbleTransition
import Firebase

class FeedItem {
    var meigen:String!
    var auther:String!
}

class ViewController: UIViewController, XMLParserDelegate, UIViewControllerTransitioningDelegate {
    
    var userName = String()
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    // プラスボタン
    @IBOutlet weak var toFeedButton: UIButton!
    
    let db = Firestore.firestore()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    var parser = XMLParser()
    var feedItem = [FeedItem]()
    
    var currentElementName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ボタンを丸くする
        toFeedButton.layer.cornerRadius = toFeedButton.frame.width/2
        
        // ナビゲーションバーを消す
        self.navigationController?.isNavigationBarHidden = true
        
        // XML解析を行う
        let url = "http://meigen.doodlenote.net/api?c=1"
        let urlToSend = URL(string: url)
        parser = XMLParser(contentsOf: urlToSend!)!
        parser.delegate = self
        parser.parse()
    }
    
    // htmlタグのキーを順番に見ていく
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = nil
        
        // <data>タグにあたったら中身を取得
        if elementName == "data" {
            self.feedItem.append(FeedItem())
        } else {
            currentElementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.feedItem.count > 0 {
            // meigenとautherを処理していく
            let lastItem = self.feedItem[self.feedItem.count - 1]
            print(lastItem)
            
            switch self.currentElementName {
            
            case "meigen":
                lastItem.meigen = string
                
            case "auther":
                lastItem.auther = string
                meigenLabel.text = lastItem.meigen + "\n" + lastItem.auther
                
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    // twitterでシェア
    @IBAction func share(_ sender: Any) {
        
        // アクティビティVCを出す
        var postString = String()
        postString = "\(userName)さんを表す名言:\n\(meigenLabel.text!)\n#あなたの名言"
        let shareItems = [postString] as [String]
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func sendData(_ sender: Any) {
        // Firestoreで値を保存する
        if let quote = meigenLabel.text,let userName = Auth.auth().currentUser?.uid {
            db.collection("feed").addDocument(data:
                                                [
                                                    "userName":Auth.auth().currentUser?.displayName,
                                                    "quote":meigenLabel.text,
                                                    "photoURL":Auth.auth().currentUser?.photoURL?.absoluteString,
                                                    "createdAt":Date().timeIntervalSince1970
                                                ])
            { (error) in
                if error != nil {
                    print(error.debugDescription)
                }
            }
        }
    }
    
    @IBAction func toFeedVC(_ sender: Any) {
        
        performSegue(withIdentifier: "feedVD", sender: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    // 以下ライブラリで必要な記述

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? FeedViewController
        controller!.transitioningDelegate = self
        controller!.modalPresentationStyle = .custom
        controller!.modalPresentationCapturesStatusBarAppearance = true
        
        controller.interactiveTransition = interactiveTransition
        interactiveTransition.attach(to: controller!)
    }
        
    // 表示する際の設定
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = toFeedButton.center
        transition.bubbleColor = toFeedButton.backgroundColor!
        return transition
    }
    
    // 戻るとき
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = toFeedButton.center
        transition.bubbleColor = toFeedButton.backgroundColor!
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

