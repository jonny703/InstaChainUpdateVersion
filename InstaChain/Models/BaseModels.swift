//
//  BaseModels.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation
import ObjectMapper

// Data types....

class BaseData: Mappable{
    var id = 0
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
    
    func isReadyToSave() -> String {
        //preconditionFailure("overrider it")
        return ""
    }
    
    func getCombineString() -> String {
        return  String(id)
    }
    
    func update(_ data :BaseData , isForce :Bool = false){
        id = data.id != 0 || isForce ? data.id : id
    }
    
}


extension BaseData : Hashable {
    
    var hashValue: Int {
        return getCombineString().hashValue
    }
    
}

extension BaseData : Equatable {}

func == (lhs: BaseData, rhs: BaseData) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}

class LocalData: BaseData {
    
    var profile: ProfileData?
    var userBaseInfo: UserInfoData? = UserInfoData()
    var privWif: WifData? = WifData()
    var pubWif: WifData? = WifData()
    override func mapping(map: Map) {
        // shortListData <- map["shortListData"]
        profile <- map["profile"]
        userBaseInfo <- map["userBaseInfo"]
        privWif <- map["privWif"]
        pubWif <- map["pubWif"]
    }
    
}

class LanguageData: BaseData {
    var title = ""
    var code = ""
}

class UserData: BaseData{
    var userID = 0
    var social_id = ""
    
    var login_type = ""
    var full_name = ""
    var phone = ""
    var profession = ""
    var image = ""
    var device_id = ""
    var token = ""
    var device_type = ""
    var is_prod = ""
    var firstName: String! = ""
    var lastName: String! = ""
    var profileImage: String! = ""
    var username: String = ""
    var userType: String = ""
    var aboutMe: String! = ""
    var intersets: Array = [""]
    var isNotify: Bool! = false
    var contact: String! = ""
    var email: String! = ""
    var dob: String! = ""
    var graphQLId: String! = ""
    var gender: String! = ""
    var address: String! = ""
    var city: String! = ""
    var state: String! = ""
    var pincode: String! = ""
    var shortListData: [String]!
    var isPhoneVerified = false
    var isEmailVerified = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userID <- map["id"]
        social_id <- map["social_id"]
        phone <- map["phone"]
        full_name <- map["full_name"]
        
        
        login_type <- map["login_type"]
        profession <- map["profession"]
        image <- map["image"]
        device_id <- map["device_id"]
        is_prod <- map["is_prod"]
        token <- map["token"]
        device_type <- map["device_type"]
        
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        profileImage <- map["profile_image"]
        aboutMe <- map ["aboutMe"]
        intersets <- map["intersets"]
        username <- map["username"]
        shortListData <- map["shortlistData"]
        contact <- map["contact"]
        if contact == nil {
            contact = ""
        }
        email <- map["email"]
        dob <- map["dob"]
        gender <- map["gender"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        pincode <- map["pincode"]
        device_id <- map ["device_id"]
        profileImage <- map["profile_img"]
        graphQLId <- map["graphQLId"]
        
        var ip = ""
        var ie = ""
        var n = ""
        n <- map["is_notify"]
        ip <- map["phone_verified"]
        ie <- map["email_verified"]
        
        
        
        if let n = Int(n) {
            if n > 0 {
                isNotify = true
            }
            else {
                isNotify = false
            }
        }
        
        if let p = Int(ip) {
            if p > 0 {
                isPhoneVerified = true
            }
            else {
                isPhoneVerified = false
            }
        }
        
        if let e = Int(ie) {
            if e > 0 {
                isEmailVerified = true
            }
            else {
                isEmailVerified = false
            }
        }
        
    }
    
    override func getCombineString() -> String{
        return String(userID)
    }
    
}

class ProfileData: NSObject, NSCoding {
    
    @objc var id = ""
    @objc var email = ""
    @objc var firstName = "Hello"
    @objc var lastName = "User"
    @objc var aboutMe = ""
    @objc var intersets = [String]()
    @objc var profession = ""
    @objc var profileImage = ""
    @objc var userType = ""
    @objc var device_id = ""
    @objc var zip = ""
    @objc var phone = ""
    @objc var address = "Address"
    @objc var city = ""
    @objc var state = "State"
    @objc var country = ""
    @objc var gender = ""
    @objc var dob = ""
    
    
    @objc var isNotify: Bool = true
    @objc var socialId: String = ""
    @objc var isPhoneVerify: Bool = false
    
    override init() {
        
    }
    
    func update(data : UserData) {
        self.email = data.email ?? ""
        self.firstName = data.firstName ?? ""
        self.lastName = data.lastName ?? ""
        self.profileImage = data.profileImage
        self.intersets = data.intersets
        self.profession = data.profession
        self.userType = data.userType
        self.device_id = data.device_id
        self.aboutMe = data.aboutMe
        
        
        if !MyUtils.isEmpty(string: String(data.userID)) {
            self.id = String(data.userID)
        }
        
        self.phone = data.contact ?? ""
        self.address = data.address ?? ""
        self.dob = data.dob ?? ""
        self.gender = data.gender ?? ""
        self.city = data.city ?? ""
        self.state = data.state ?? ""
        self.zip = data.pincode ?? ""
        self.socialId = data.graphQLId ?? ""
        self.isPhoneVerify = data.isPhoneVerified
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.id = (aDecoder.decodeObject(forKey: "id") as? String) ?? ""
        self.email = (aDecoder.decodeObject(forKey: "email") as? String) ?? ""
        self.firstName = (aDecoder.decodeObject(forKey: "fname") as? String) ?? ""
        self.lastName = (aDecoder.decodeObject(forKey: "lname") as? String) ?? ""
        self.profileImage = (aDecoder.decodeObject(forKey: "profileImage") as? String) ?? ""
        self.userType = (aDecoder.decodeObject(forKey: "userType") as? String) ?? ""
        self.aboutMe = (aDecoder.decodeObject(forKey: "aboutMe") as? String) ?? ""
        self.intersets = (aDecoder.decodeObject(forKey: "intersets") as? Array) ?? [""]
        self.profession = (aDecoder.decodeObject(forKey: "profession") as?String) ?? ""
        self.socialId = (aDecoder.decodeObject(forKey: "socialId") as?String) ?? ""
        self.isPhoneVerify = aDecoder.decodeBool(forKey: "isPhone")
        self.isNotify = aDecoder.decodeBool(forKey: "isNotify")
        
        self.gender = (aDecoder.decodeObject(forKey: "gender") as? String) ?? ""
        self.dob = (aDecoder.decodeObject(forKey: "dob") as? String) ?? ""
        self.zip = (aDecoder.decodeObject(forKey: "zip") as? String) ?? ""
        self.phone = (aDecoder.decodeObject(forKey: "phone") as? String) ?? ""
        self.address = (aDecoder.decodeObject(forKey: "address") as? String) ?? ""
        self.city = (aDecoder.decodeObject(forKey: "city") as? String) ?? ""
        self.country = (aDecoder.decodeObject(forKey: "country") as? String) ?? ""
        self.state = (aDecoder.decodeObject(forKey: "state") as? String) ?? ""
        //        self.password = (aDecoder.decodeObject(forKey: "password") as? String) ?? ""
        
    }
    
    required init?(map: Map) {
        //super.init(map: Map)
        fatalError("init(map:) has not been implemented")
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "fname")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(lastName, forKey: "lname")
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(intersets, forKey: "intersets")
        aCoder.encode(profession, forKey: "profession")
        aCoder.encode(userType, forKey: "userType")
        aCoder.encode(socialId, forKey: "socialId")
        aCoder.encode(isPhoneVerify, forKey: "isPhone")
        aCoder.encode(isNotify, forKey: "isNotify")
        
        // aCoder.encode(password, forKey: "password")
        
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(zip, forKey: "zip")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(country, forKey: "country")
    }
    
    @objc func getFullName() -> String {
        return firstName + " " + lastName
    }
    
}

class TitleDescriptionData: BaseData {
    var title:String = "" {
        didSet{
            let trimString =  MyUtils.makeStringTrimmed(title)
            if trimString != title {
                title = trimString
            }
        }
    }
    
    var description:String = ""{
        didSet{
            let trimString =  MyUtils.makeStringTrimmed(description)
            if trimString !=  description{
                description = trimString
            }
        }
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
        description <- map["description"]
    }
    
    override func isReadyToSave() -> String {
        if title.isEmpty {
            return MyStrings.messageTitleEmpty
        }
        else if description.isEmpty {
            return MyStrings.messageDescriptionIsEmpty
        }
        return ""
    }
    
    override func getCombineString() -> String {
        return (super.getCombineString() + title + description)
    }
    
    override func update(_ data :BaseData , isForce :Bool = false){
        super.update(data, isForce: isForce)
        guard let d = data as? TitleDescriptionData else {
            return
        }
        title = !d.title.isEmpty || isForce ? d.title : title
        description = !d.description.isEmpty || isForce ? d.description: description
    }
}

class TitleDesDateData :TitleDescriptionData{
    internal var date:String! = ""
    var disPlayDate:String {
        get {
            if !date.isEmpty {
                if date.contains("-"){
                    return TimeDateUtils.getClientStyleDateFromServerString(date)
                }
            }
            return TimeDateUtils.getShortDateInString(Date())
            
        }
        
        set (newValue) {
            if !newValue.isEmpty {
                if newValue.contains(","){
                    date = TimeDateUtils.getServerStyleDateInString(newValue)
                    return
                }
            }
            date = newValue
        }
    }
    
    func getNSDate() -> Date {
        if !date.isEmpty {
            if date.contains("-"){
                return TimeDateUtils.getDateFromServerString(date)
            }
        }
        return Date()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        date <- map["date"]
    }
    
}



class ImageUrlData : TitleDesDateData{
    var imagesUrls = [String]()
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        imagesUrls <- map["imgurls"]
        
        var singleUrl:String = ""
        singleUrl <- map["imgurl"]
        
        if !singleUrl.isEmpty && imagesUrls.count == 0 {
            imagesUrls.append(singleUrl)
        }
        
    }
    
    
    
    override func update(_ data :BaseData , isForce :Bool = false){
        super.update(data, isForce: isForce)
        guard let d = data as? ImageUrlData else {
            return
        }
        if (d.imagesUrls.count > imagesUrls.count || isForce ){
            self.imagesUrls.removeAll();
            self.imagesUrls.append(contentsOf: d.imagesUrls);
        }
    }
    
}


class UserInfoData: FollowersFollowingData {
    var name = ""
    var owner = KeyData()
    var active = KeyData()
    var posting = KeyData()
    var memoKey = ""
    var jsonMetadata: UserInfoJsonMetaData?
    var proxy = ""
    var lastOwnerUpdate = ""
    var lastAccountUpdate = ""
    var created = ""
    var mined = false
    var ownerChallenged = false
    var activeChallenged = false
    var lastOwnerProved = ""
    var lastActiveProved = ""
    var recoveryAccount = ""
    var lastAccountRecovery = ""
    var resetAccount = ""
    var commentCount = ""
    var lifetimeVoteCount = ""
    var postCount = 0
    var canVote = true
    var votingPower = 0000
    var lastVoteTime = ""
    var balance = ""
    var savingsBalance = ""
    var sbdBalance =  ""
    var sbdSeconds = ""
    var sbdSecondsLastUpdate = ""
    var sbdLastInterestPayment = ""
    var savingsSbdBalance = ""
    var savingsSbdSeconds =  ""
    var savingsSbdSecondsLastUpdate =  ""
    var savingsSbdLastInterestPayment =  ""
    var savingsWithdrawRequests =  0
    var rewardSbdBalance = ""
    var rewardSteemBalance =  ""
    var rewardVestingBalance =  ""
    var rewardVestingSteem =  ""
    var vestingShares =  ""
    var delegatedVestingShares = ""
    var receivedVestingShares = ""
    var vestingWithdrawRate = ""
    var nextVestingWithdrawal = "1969-12-31T23:59:59"
    var withdrawn = 0
    var toWithdraw = 0
    var withdrawRoutes = 0
    var curationRewards = 0
    var postingRewards =  0
    var proxiedVsfVotes = [Int]()
    var witnessesVotedFor = 0
    var average_bandwidth = 728731899
    var lifetime_bandwidth = 931000000
    var last_bandwidth_update = "2017-12-18T21:16:24"
    var average_market_bandwidth = 0
    var lifetime_market_bandwidth = 0
    var last_market_bandwidth_update = "1970-01-01T00:00:00"
    var last_post = "2017-12-18T21:16:24"
    var last_root_post = "2017-12-18T21:15:45"
    var vesting_balance = "0.000 INSTA"
    var reputation = 0
    var transfer_history = [String]()
    var market_history = [String]()
    var post_history = [String]()
    var vote_history = [String]()
    var other_history = [String]()
    var witness_votes = [String]()
    var tags_usage = [String]()
    var guest_bloggers = [String]()
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        owner <- map["owner"]
        active <- map["active"]
        posting <- map["posting"]
        memoKey <- map["memo_key"]
        jsonMetadata <- map["json_metadata"]
        proxy <- map["proxy"]
        lastOwnerUpdate <- map["last_owner_update"]
        lastAccountUpdate <- map["last_account_update"]
        created <- map["created"]
        mined <- map["mined"]
        ownerChallenged <- map["owner_challenged"]
        activeChallenged <- map["active_challenged"]
        lastOwnerUpdate <- map["last_owner_proved"]
        lastActiveProved <- map["last_active_proved"]
        recoveryAccount <- map["recovery_account"]
        lastAccountRecovery <- map["last_account_recovery"]
        resetAccount <- map["reset_account"]
        commentCount <- map["comment_count"]
        lifetimeVoteCount <- map["lifetime_vote_count"]
        postCount <- map["post_count"]
        canVote <- map["can_vote"]
        votingPower <- map["voting_power"]
        lastVoteTime <- map["last_vote_time"]
        balance <- map["balance"]
        savingsBalance <- map["savings_balance"]
        sbdBalance <- map["sbd_balance"]
        sbdSeconds <- map["sbd_seconds"]
        sbdSecondsLastUpdate <- map["sbd_seconds_last_update"]
        sbdLastInterestPayment <- map["sbd_last_interest_payment"]
        savingsSbdBalance <- map["savings_sbd_balance"]
        savingsSbdBalance <- map["savings_sbd_balance"]
        savingsSbdSeconds <- map["savings_sbd_seconds"]
        savingsSbdSecondsLastUpdate <- map["savings_sbd_seconds_last_update"]
        savingsSbdLastInterestPayment <- map["savings_sbd_last_interest_payment"]
        savingsWithdrawRequests <- map["savings_withdraw_requests"]
        rewardSbdBalance <- map["reward_sbd_balance"]
        rewardSteemBalance <- map["reward_steem_balance"]
        rewardVestingBalance <- map["reward_vesting_balance"]
        rewardVestingSteem <- map["reward_vesting_steem"]
        vestingShares <- map["vesting_shares"]
        delegatedVestingShares <- map["delegated_vesting_shares"]
        receivedVestingShares <- map["received_vesting_shares"]
        vestingWithdrawRate <- map["vesting_withdraw_rate"]
        nextVestingWithdrawal <- map["next_vesting_withdrawal"]
        withdrawn <- map["withdrawn"]
        toWithdraw <- map["to_withdraw"]
        withdrawRoutes <- map["withdraw_routes"]
        curationRewards <- map["curation_rewards"]
        postingRewards <- map["posting_rewards"]
        proxiedVsfVotes <- map["proxied_vsf_votes"]
        witnessesVotedFor <- map["witnesses_voted_for"]
        average_bandwidth <- map["average_bandwidth"]
        lifetime_bandwidth <- map["lifetime_bandwidth"]
        last_bandwidth_update <- map["last_bandwidth_update"]
        average_market_bandwidth <- map["average_market_bandwidth"]
        lifetime_market_bandwidth <- map["lifetime_market_bandwidth"]
        last_market_bandwidth_update <- map["last_market_bandwidth_update"]
        last_post <- map["last_post"]
        last_root_post <- map["last_root_post"]
        vesting_balance <- map["vesting_balance"]
        reputation <- map["reputation"]
        transfer_history <- map["transfer_history"]
        market_history <- map["market_history"]
        post_history <- map["post_history"]
        vote_history <- map["vote_history"]
        other_history <- map["other_history"]
        witness_votes <- map["witness_votes"]
        tags_usage <- map["tags_usage"]
        guest_bloggers <- map["guest_bloggers"]
        
    }
    
}



class KeyData: BaseData {
    var weightThreshold = 0
    var accountAuths = [""]
    var keyAuths: AnyObject?
    var key = [""]
    override func mapping(map: Map) {
        super.mapping(map: map)
        weightThreshold <- map["weight_threshold"]
        accountAuths <- map["account_auths"]
        keyAuths <- map["key_auths"]
        key.removeAll()
        if let ownerData = keyAuths as? Array<Any> {
            for items in ownerData{
                if let item = items as? Array<Any>{
                    for keyValue in item{
                        key.append("\(keyValue)")
                    }
                }
            }
        }
    }
    
}

class WifKeyData: BaseData {
    var result: AnyObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        result <- map["result"]
    }
}

class FollowersFollowingData: BaseData {
    
    var account: String = ""
    var followerCount: Int = 0
    var followingCount: Int = 0
    override func mapping(map: Map) {
        
        account <- map["account"]
        followerCount <- map["follower_count"]
        followingCount <- map["following_count"]
        
    }
    
    
}


class WifData: BaseData{
    var posting = ""
    var active = ""
    var memo = ""
    var owner = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        posting <- map["posting"]
        active <- map["active"]
        memo <- map["memo"]
        owner <- map["owner"]
    }
}

class TagData: BaseData{
    var tags = [""]
    override func mapping(map: Map) {
        super.mapping(map: map)
        tags <- map["tags"]
    }
}

//For post data

class PostData: BaseData {
    var author: String = ""
    var permlink: String = ""
    var category: String = ""
    var parentAuthor: String = ""
    var parentPermlink: String = ""
    var title: String = ""
    var body: String = ""
    var jsonMetadata: Json_metadata? = Json_metadata()
    var lastUpdate: String = ""
    var created: String = ""
    var active: String = ""
    var lastPayout: String = ""
    var depth: Int = 0
    var children: Int = 0
    var netRshares: String = ""
    var absRshares: String = ""
    var voteRshares: String = ""
    var childrenAbsRshares: String = ""
    var cashoutTime: String = ""
    var maxCashoutTime: String = ""
    var totalVoteWeight: Int = 0
    var rewardWeight: Int = 0
    var totalPayoutValue: String = ""
    var curatorPayoutValue: String = ""
    var authorRewards: Int = 0
    var netVotes: Int = 0
    var rootComment: Int = 0
    var maxAcceptedPayout: String = ""
    var percentSteemDollars: Int = 0
    var allowReplies: Bool = false
    var allowVotes: Bool = false
    var allowCurationRewards: Bool = false
    var beneficiaries: [String] = [""]
    var url: String = ""
    var rootTitle: String = ""
    var pendingPayoutValue: String = ""
    var totalPendingPayoutValue: String = ""
    var activeVotes: [ActiveVoterData] = [ActiveVoterData()]
    var replies: [String] = [String()]
    var authorReputation: String = ""
    var promoted: String = ""
    var bodyLength: Int? = 0
    var rebloggedBy: [String] = [""]
    var authorProfileImage: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        author <- map["author"]
        permlink <- map["permlink"]
        category <- map["category"]
        parentAuthor <- map["parent_author"]
        parentPermlink <- map["parent_permlink"]
        title <- map["title"]
        body <- map["body"]
        jsonMetadata <- map["json_metadata"]
        lastUpdate <- map["last_update"]
        created <- map["created"]
        active <- map[ "active"]
        lastPayout <- map["last_payout"]
        depth <- map["depth"]
        children <- map["children"]
        netRshares <- map["net_rshares"]
        absRshares <- map["abs_rshares"]
        voteRshares <- map["vote_rshares"]
        childrenAbsRshares <- map["children_abs_rshares"]
        cashoutTime <- map["cashout_time"]
        maxCashoutTime <- map["max_cashout_time"]
        totalVoteWeight <- map["total_vote_weight"]
        rewardWeight <- map["reward_weight"]
        totalPayoutValue <- map["total_payout_value"]
        curatorPayoutValue <- map["curator_payout_value"]
        authorRewards <- map["author_rewards"]
        netVotes <- map["net_votes"]
        rootComment <- map["root_comment"]
        maxAcceptedPayout <- map["max_accepted_payout"]
        percentSteemDollars <- map["percent_steem_dollars"]
        allowReplies <- map["allow_replies"]
        allowVotes <- map["allow_votes"]
        allowCurationRewards <- map["allow_curation_rewards"]
        beneficiaries <- map["beneficiaries"]
        url <- map["url"]
        rootTitle <- map["root_title"]
        pendingPayoutValue <- map["pending_payout_value"]
        totalPendingPayoutValue <- map["total_pending_payout_value"]
        activeVotes <- map["active_votes"]
        replies <- map["replies"]
        authorReputation <- map["author_reputation"]
        promoted <- map["promoted"]
        bodyLength <- map["body_length"]
        rebloggedBy <- map["reblogged_by"]
        authorProfileImage <- map["author_profile_image"]
    }
    
}

//an post data
class DiscussionsData: BaseData {
    var author: String = ""
    var permlink: String = ""
    var image: String = ""
    var created: String = ""
    var netVotes: Int = 0
    var tags: [String] = [""]
    var title: String = ""
    var body: String = ""
    var pendingPayoutValue = ""
    var totalPayoutValue = ""
    var voters: [ActiveVoterData] = []
    var authorImage: String?
    
    override func mapping(map: Map) {
        author <- map["author"]
        permlink <- map["permlink"]
        image <- map["image"]
        created <- map["created"]
        netVotes <- map["net_votes"]
        tags <- map["tags"]
        title <- map["title"]
        body <- map["body"]
        voters <- map["active_votes"]
        pendingPayoutValue <- map["pending_payout_value"]
        totalPayoutValue <- map["total_payout_value"]
        authorImage <- map["author_profile_image"]
        
    }
}

class ActiveVoterData: BaseData {
    var voter: String = ""
    var weight: Int = 0
    var rshares: Int = 0
    var percent: Int = 0
    var reputation: String = ""
    var time: String = ""
   
    override func mapping(map: Map) {
        voter <- map["voter"]
        weight <- map["weight"]
        var weights: Any?
       weights <- map["weight"]
        if let data = weights as? String{
            weight = Int(data)!
        }
        
        rshares <- map["rshares"]
        percent <- map["percent"]
        reputation <- map["reputation"]
        time <- map["time"]
    }
}


class CommentsMetaData: BaseData {
    var tags: [String] = []
    var user: [String] = []
    var links: [String] = []
    var image: [String] = []
    var format = ""
    var app  = ""
}

class CommentData: BaseData {
    var parentAuthor = ""
    var parentPermlink = ""
    var author = ""
    var permlink = ""
    var title = ""
    var body = ""
    var json_metadata = TagData()
    override func mapping(map: Map) {
        super.mapping(map: map)
        parentAuthor <- map["parent_author"]
        parentPermlink <- map["parent_permlink"]
        author <- map["author"]
        permlink <- map["permlink"]
        title <- map["title"]
        body <- map["body"]
        json_metadata <- map["json_metadata"]
    }
}

class CommentResponseData: BaseData {
    var blockNum = 0
    var trxNum = 0
    var expired =  false
    var ref_block_num = 0
    var ref_block_prefix = 0
    var expiration = ""
    var operations: [String] = []
    var operationData: AnyObject?
    var extensions: [String] = []
    var signatures: [String] = []
    override func mapping(map: Map) {
        super.mapping(map: map)
        blockNum <-  map["block_num"]
        trxNum <- map["trx_num"]
        expired <- map["exired"]
        ref_block_num <- map["ref_block_num"]
        ref_block_prefix <- map["ref_block_prefix"]
        expiration <- map["expiration"]
        operationData <- map["operations"]
        extensions <- map["extensions"]
        signatures <- map["signatures"]
        
        
    }
    
}


class SuccessResponseData: BaseData{
    var blockNum = 0
    var trxNum = 0
    var expired =  false
    var ref_block_num = 0
    var ref_block_prefix = 0
    var expiration = ""
    var extensions: [String] = []
    var signatures: [String] = []
    override func mapping(map: Map) {
        super.mapping(map: map)
        blockNum <-  map["block_num"]
        trxNum <- map["trx_num"]
        expired <- map["exired"]
        ref_block_num <- map["ref_block_num"]
        ref_block_prefix <- map["ref_block_prefix"]
        expiration <- map["expiration"]
        extensions <- map["extensions"]
        signatures <- map["signatures"]
    }
}


class StartStopFollowingData: SuccessResponseData{
    var operations : [[StartStopFollowingDataJson]] = [[]]
    override func mapping(map: Map) {
        super.mapping(map: map)
        operations <- map["operations"]
    }
}

class StartStopFollowingDataJson: BaseData {
    var requiredAuths: [String] = []
    var requiredPostingAauths: [String] = []
    var type: String?
    var json: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        requiredAuths <- map["required_authszs"]
        requiredPostingAauths <- map["required_posting_auths"]
        type <- map["id"]
        json <- map["json"]
        
        
        
    }
}


class PostCommentResponseData: BaseData {
    var parent_author : String?
    var parent_permlink : String?
    var author : String?
    var permlink : String?
    var title : String?
    var body : String?
    var jsonMetadata : Json_metadata?
    var wif : String?
    
    override func mapping(map: Map) {
        
        parent_author <- map["parent_author"]
        parent_permlink <- map["parent_permlink"]
        author <- map["author"]
        permlink <- map["permlink"]
        title <- map["title"]
        body <- map["body"]
        jsonMetadata <- map["json_metadata"]
        wif <- map["wif"]
    }
    
}

class Json_metadata: BaseData {
    var tags : [String]?
    var users : [String]?
    var links : [String]?
    var images : [String]?
    var image : String?
    var format : String?
    var app : String?
    
    
    override func mapping(map: Map) {
        
        tags <- map["tags"]
        users <- map["users"]
        links <-  map["links"]
        images <- map["image"]
        image <- map["image"]
        format <- map["format"]
        app <- map["app"]
    }
    
    class ErrorData: BaseData{
        var error = ""
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            error <- map["error"]
            
        }
    }
    
    
    
}

// Detail Discussion Type

class DetailDiscussionData: BaseData {
    var author: String?
    var permlink: String?
    var category: String?
    var parentAuthor: String?
    var parentPermlink: String?
    var title: String?
    var body: String?
    var jsonMetadata: Json_metadata?
    var lastUpdate: String?
    var created: String?
    var active: String?
    var lastPayout: String?
    var depth: Int?
    var children: Int?
    var netRshares: Int?
    var absRshares: Int?
    var voteRshares: Int?
    var childrenAbsRshares: Int?
    var cashoutTime: String?
    var maxCashoutTime: String?
    var totalVoteWeight: Int?
    var rewardWeight: Int?
    var totalPayoutValue: String?
    var curatorPayoutValue: String?
    var authorRewards: Int?
    var netVotes: Int?
    var rootComment: Int?
    var maxAcceptedPayout: String?
    var percentSteemDollars: Int?
    var allowReplies: Bool?
    var allowVotes: Bool?
    var allowCurationRewards: Bool?
    var beneficiaries: [String] = []
    var url: String?
    var rootTitle: String?
    var pendingPayoutValue: String?
    var totalPendingPayoutValue: String?
    var activeVotes: [ActiveVoterData] = []
    var replies: [String] = []
    var authorReputation: Int?
    var promoted: String?
    var bodyLength: Int?
    var rebloggedBy: [String] = []
    var authorImageUrl: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        author <- map["author"]
        permlink <- map["permlink"]
        category <- map["category"]
        parentAuthor <- map["parent_author"]
        parentPermlink <- map["parent_permlink"]
        title <- map["title"]
        body <- map["body"]
        jsonMetadata <- map["json_metadata"]
        lastUpdate <- map["last_update"]
        created <- map["created"]
        active <- map["active"]
        lastPayout <- map["last_payout"]
        depth <- map["depth"]
        children <- map["children"]
        netRshares <- map["net_rshares"]
        absRshares <- map["abs_rshares"]
        voteRshares <- map["vote_rshares"]
        childrenAbsRshares <- map["children_abs_rshares"]
        cashoutTime <- map["cashout_time"]
        maxCashoutTime <- map["max_cashout_time"]
        totalVoteWeight <- map["total_vote_weight"]
        rewardWeight <- map["reward_weight"]
        totalPayoutValue <- map["total_payout_value"]
        curatorPayoutValue <- map["curator_payout_value"]
        authorRewards <- map["author_rewards"]
        netVotes <- map["net_votes"]
        rootComment <- map["root_comment"]
        maxAcceptedPayout <- map["max_accepted_payout"]
        percentSteemDollars <- map["percent_steem_dollars"]
        allowReplies <- map["allow_replies"]
        allowVotes <- map["allow_votes"]
        allowCurationRewards <- map["allow_curation_rewards"]
        beneficiaries <- map["beneficiaries"]
        url <- map["url"]
        rootTitle <- map["root_title"]
        pendingPayoutValue <- map["pending_payout_value"]
        totalPendingPayoutValue <- map["total_pending_payout_value"]
        activeVotes <- map["active_votes"]
        replies <- map["replies"]
        authorReputation <- map["author_reputation"]
        promoted <- map["promoted"]
        bodyLength <- map["body_length"]
        rebloggedBy <- map["reblogged_by"]
        authorImageUrl <- map["author_profile_image"]
    }
    
}

//Vote data

class VoteResponseData: BaseData {
    var idString: String?
    var blockNum: Int?
    var trxNum: Int?
    var expired: Bool?
    var refBlockNum: Int?
    var refBlockPrefix: Int?
    var expiration: String?
    var operations: [[VoteRawData?]] = [[]]
    var extensions: [String?] = []
    var signatures: [String?] = []
    override func mapping(map: Map) {
        id <- map["id"]
        blockNum <- map["block_num"]
        trxNum <- map["trx_num"]
        expired <- map["expired"]
        refBlockNum <- map["ref_block_num"]
        refBlockPrefix <- map["ref_block_prefix"]
        expiration <- map["expiration"]
        operations <- map["operations"]
        extensions <- map["extensions"]
        signatures <- map["signatures"]
    }
}

//posted image data
class PostedImageData: BaseData{
    var author: String?
    var permlink: String?
    var image: String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        author <- map["author"]
        permlink <- map["permlink"]
        image <- map["image"]
    }
    
}

// get followers

class FollowersData: BaseData {
    var follower: String?
    var following: String?
    var what: [String?] = []
    var authorProfileImage: String?
    var authorDisplayName: String?
    
    override func mapping(map: Map) {
        follower <- map["follower"]
        following <- map["following"]
        what <- map["what"]
        authorProfileImage <- map["author_profile_image"]
        authorDisplayName <- map["author_display_name"]
    }
}

class ProfileMetaData: BaseData {
    var profileImage, coverImage, name, about: String?
    var location, website: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        profileImage <- map["profile_image"]
        coverImage <- map["cover_image"]
        name <- map["name"]
        about <- map["about"]
        location <- map["location"]
        website <- map["website"]
    }
}


class UserInfoJsonMetaData: BaseData {
    var profile: ProfileMetaData?
    override func mapping(map: Map) {
        super.mapping(map: map)
        profile <- map["profile"]
    }
    
}

class FollowersJsonMetaData: BaseData {
    
    var follower: String?
    var following: String?
    var onWhat:  [String]?
    override func mapping(map: Map) {
        super.mapping(map: map)
        following <- map["following"]
        follower <- map["follower"]
        onWhat <- map["what"]
    }
}

class BaseResponseData: BaseData{
    var idString: String?
    var blockNum: Int?
    var trxNum: Int?
    var expired: Bool?
    var refBlockNum: Int?
    var refBlockPrefix: Int?
    var expiration: String?
    var extensions: [String?] = []
    var signatures: [String?] = []
    override func mapping(map: Map) {
        blockNum <- map["block_num"]
        trxNum <- map["trx_num"]
        expired <- map["expired"]
        refBlockNum <- map["ref_block_num"]
        refBlockPrefix <- map["ref_block_prefix"]
        expiration <- map["expiration"]
        extensions <- map["extensions"]
        signatures <- map["signatures"]
    }
}

class ProfileUpdateResponseData: BaseResponseData{
    var operation: [Any]?
    override func mapping(map: Map) {
        operation <- map["operations"]
    }
}
