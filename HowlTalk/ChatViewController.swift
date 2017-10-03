//
//  ChatViewController.swift
//  HowlTalk
//
//  Created by 유명식 on 2017. 9. 26..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    
    
    @IBOutlet weak var textfield_message: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var uid : String?
    var chatRoomUid : String?
    
    
    public var destinationUid :String? // 나중에 내가 채팅할 대상의 uid
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRoom(){
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [
            uid!: true,
            destinationUid! :true
            ]
        ]
        
        
        if(chatRoomUid == nil){
            // 방 생성 코드
            Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo)
        }else{
            let value :Dictionary<String,Any> = [
                "comments":[
                    "uid" : uid!,
                    "message" : textfield_message.text!
                ]
            ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
        
        
        
        
        
    }
    func checkChatRoom(){
        
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value,with: { (datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
               self.chatRoomUid = item.key
                
            }
        })
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
