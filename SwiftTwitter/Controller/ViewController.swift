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
    
    // htmlタグのキーを全部見ていく
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = nil
        
        // <data>タグがあれば中身を取得
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
        <#code#>
    }
    
    @IBAction func share(_ sender: Any) {
        
    }
    
    
    @IBAction func sendData(_ sender: Any) {
        // Firestoreで値を保存する
        if let quote = meigenLabel.text, let userName = Auth.auth()
    }
    
}

