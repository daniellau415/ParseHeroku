//
//  Message.swift
//  ParseHeroku
//
//  Created by Daniel Lau on 8/17/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import Foundation
import Parse

class Message: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Message"
    }
    
    @NSManaged var message : String
    @NSManaged var username : String

}
