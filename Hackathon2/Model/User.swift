//
//  User.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let emailAdress: String
    
    //'(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
