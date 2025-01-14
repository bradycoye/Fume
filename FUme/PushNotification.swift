import Foundation

class PushNotication {
    
    class func parsePushUserAssign() {
        let installation = PFInstallation.currentInstallation()
        installation[PF_INSTALLATION_USER] = PFUser.currentUser()
        installation.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                print("parsePushUserAssign save error.")
            }
        }
    }
    
    class func parsePushUserResign() {
        let installation = PFInstallation.currentInstallation()
        installation.removeObjectForKey(PF_INSTALLATION_USER)
        installation.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                print("parsePushUserResign save error")
            }
        }
    }
    
    class func sendPushNotification(groupId: String, text: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.currentUser())
        query.includeKey(PF_MESSAGES_USER)
        query.limit = 1000
        
        let installationQuery = PFInstallation.query()
        installationQuery.whereKey(PF_INSTALLATION_USER, matchesKey: PF_MESSAGES_USER, inQuery: query)
        
        let push = PFPush()
        push.setQuery(installationQuery)
        push.setMessage(text)
        push.sendPushInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                print("sendPushNotification error")
            }
        }
    }
    
}