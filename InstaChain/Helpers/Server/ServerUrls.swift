//
//  ServerUrls.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

class ServerUrls {

    static let baseUrl = "http://api.instachain.io:3000/"
    
    static let loginUrl = ServerUrls.baseUrl + "getAccounts"
    static let newLoginUrl = ServerUrls.baseUrl + "auth/login"
    static let authUserUrl = ServerUrls.baseUrl + "auth/to_wif"
    static let postComment = ServerUrls.baseUrl + "broadcast/comment"
    static let wifValid = ServerUrls.baseUrl + "auth/wif_is_valid"
    static let followFollowersUrl = ServerUrls.baseUrl + "get_follow_count"
    static let discussions = ServerUrls.baseUrl + "get_discussions_by_feed"
    static let detailDiscussion = ServerUrls.baseUrl + "get_content"
    static let vote = ServerUrls.baseUrl + "broadcast/vote"
    static let imageOnly = ServerUrls.baseUrl + "get_discussions_by_blog"
    static let following = ServerUrls.baseUrl + "get_following"
    static let followers = ServerUrls.baseUrl + "get_followers"
    static let comments = ServerUrls.baseUrl + "get_content_replies"
    static let startAndStopFollow = ServerUrls.baseUrl + "broadcast/follow"
    static let editProfile = ServerUrls.baseUrl + "broadcast/account_update"
    static let discussionByHot = ServerUrls.baseUrl + "get_discussions_by_hot"
    static let discussionByTrending = ServerUrls.baseUrl + "get_discussions_by_trending"
    static let discussionCreatedBy = ServerUrls.baseUrl + "get_discussions_by_created"
    static let getLookupAccounts = ServerUrls.baseUrl + "lookup_accounts?lowerBoundName=%@&limit=50"
    static let getState = ServerUrls.baseUrl + "get_state?p_path=%@/@%@/%@"
    static let sendPrivateMessage = ServerUrls.baseUrl + "broadcast/private_message"
    static let getPrivateMessageHistory = ServerUrls.baseUrl + "auth/chat_history"

}
