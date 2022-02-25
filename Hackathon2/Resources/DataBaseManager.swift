//
//  DataBaseManager.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import Foundation
import Firebase

//database.child("foo").setValue(nil) delete the value if "foo" key exist

class DataBaseManager {
    
    static let shared = DataBaseManager()
    private let database = Database.database().reference()
    
    //MARK: - CREATE ACCOUNT
    //Key for user is his/her email adress
    //once it's done to writing to database we then want to upload the image
    public func insertUser(with user: User, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "score": 0
        ]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    //append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                } else {
                    //create that array
                    let newCollection:  [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
            } // end of observeSingleEvent()
        } //end of setValue()
    } //end of insertUser()
    
    
    //MARK: - UPDATE SCORE
    
    public func updateScore(extra: Int) {
        guard let email = Auth.auth().currentUser?.email else {return}
        let safeEmail = DataBaseManager.safeEmail(email: email)
        
        database.child("\(safeEmail)/score").observeSingleEvent(of: .value) { snapshot in
            guard var score = snapshot.value as? Int else {
                return
            }
            score = score + extra
            self.database.child("\(safeEmail)/score").setValue(score)
        }
    }
    
    
    //MARK: - LISTEN SCORE
    public func getScore(completion: @escaping (Int) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {return}
        let safeEmail = DataBaseManager.safeEmail(email: email)
        
        database.child("\(safeEmail)/score").observeSingleEvent(of: .value) { snapshot in
            guard let score = snapshot.value as? Int else {
                return
            }
            print(score)
            completion(score)
            
        }
    }
    
    //MARK: - Get Questions
    //https://stackoverflow.com/questions/47282796/value-of-tuple-type-key-string-value-anyobject-has-no-member-subscript
    public func getQuestions(completion: @escaping ([QuestionModel]) -> Void) {
        
        database.child("questions").observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String:Any] else {
                print("question hata")
                return
            }
            var questionModel = [QuestionModel]()
            

            for (key, value) in data {
                //key one, two
                guard let val = value as? [String: Any] else {
                    print("Son hata")
                    return
                }

                if let title = val["title"] as? String,
                   let detail = val["detail"] as? String,
                   let question = val["question"] as? String,
                   let answer_1 = val["answer_1"] as? String,
                   let answer_2 = val["answer_2"] as? String,
                   let correct = val["true"] as? Int  {
                    questionModel.append(QuestionModel(title: title, detail: detail, question: question, answer_1: answer_1, answer_2: answer_2, correct: correct))
                }
       
            }
            
            completion(questionModel)
        }
    }
    
    
    
    
    
    
    
    //'(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}


