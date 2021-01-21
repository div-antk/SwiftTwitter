//
//  ViewController.swift
//  SwiftTwitter
//
//  Created by Takuya Ando on 2021/01/19.
//

import UIKit
import BubbleTransition
import Firebase

class ViewController: UIViewController, XMLParserDelegate, UIViewControllerTransitioningDelegate {
    
    var userName = String()
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    // プラスボタン
    @IBOutlet weak var toFeedButton: UIButton!
    
    let db = Firestore.firestore()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    var parser = XMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

