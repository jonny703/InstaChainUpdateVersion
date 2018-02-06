//
//  File.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//


import Foundation


class MyStrings {

   
    //Drawer Items
    static let loginError = "Invalid Credential"
    static let invalid_credentail = "Invalid Credentail"
    static let logout_description  = "Are you sure you want to logout?"


    // static let  = ""
    // static let  = ""


    // general
    static let from = "FROM".localized
    static let to = "to"
    static let TO = "TO".localized
    static let yes = "Yes"
    static let no = "No"


    static let ok = "Ok".localized
    static let cancel = "Cancel".localized
    static let tryAgain = "Try Again".localized
    static let by = "By"
    static let search = "Search"


    static let description = "Description"
    static let mark_to = "Mark To"



    static let messageTitleEmpty = "Title is empty"
    static let messageDescriptionIsEmpty = "Description is empty"
    static let messageNameEmpty = "Name is empty"
    static let messageStartDateEmpty = "Start Date is empty"
    static let messageEndDateEmpty = "End Date is empty"
    static let messageDobEmpty = "Date of birth is empty"
    static let messageEmpty = "Message is empty"
    static let messageIsTooShort = "Message is short"

    //Navigation Title
    static let profile = "Profile"
    static let home = "Dashboard"
    static let followers = "Followers"
    static let startFollow = "Followed successfully"


    static func getText(key:String) -> String {
        return ""
        //return text[key] ?? key
    }


    //    static let single = "Single"
    //    static let married = "Married"
    //    static let male = "Male"
    //    static let female = "Female"
    //
    //    static let totalFunds = "Total Funds"
    //
    //    //
    //    static let event = "Event"
    //    static let work = "Work".localized
    //    static let issue = "Issue"
    //
    //    static let events = "Events"
    //    static let works = "Works".localized
    //    static let issues = "Issues"
    //    static let views = "Views"
    //    static let replies = "Replies"
    //
    //    static let newPost = "New Post"
    //    static let newPoll = "New Poll"
    //    static let newEvent = "New Event"
    //
    //
    //
    //    static let saving = "Saving"
    //    static let errorWhileSaving = "Some error occur during saving"
    //
    //
    //
    //
    //    // Brielf Bar
    //    static let issueRaised = "Issue Raised"
    //    static let amountDonated = "Amount Donated"
    //
    //    // community tabs
    //    static let myCommunity = "My Community"
    //    static let communities = "Communities"
    //    static let topResident = "Top Resident"
    //    static let topCommunity = "Top Communities"
    //    static let topCommunityMember = "Top Community Members"
    //    static let fetchingTag = "Getting Tags"
    //    static let myNeighbourhood = "My Neighborhood"
    //    static let nearbyNeighbourhood = "Nearby Neighborhood"
    //
    //
    //    // home
    //    static let ugrentAlerts = "Urgent Alerts"
    //    static let posts = "Posts"
    //    static let post = "Post "
    //    static let community_issue = "Community Issue"
    //    static let community_issues = "Community Issues"
    //    static let active_community_issue = "Active Community Issues"
    //    static let HOA_issues = "HOA Issues"
    //    static let HOA_issue = "HOA Issue"
    //    static let polls = "Polls"
    //    static let poll = "Poll"
    //    static let contact = "Contact"
    //
    //    //
    //    static let open = "Open"
    //    static let closed = "Closed"
    //
    //    //
    //    static let active = "Active"
    //    static let relevant = "Relevent"
    //    static let subscribed = "Subscribed"
    //    static let resolved = "Resolved"
    //    static let popular = "Popular"
    //    static let own = "Own"
    //
    //
    //    static let reviews = "Reviews"
    //    static let write_review = "Write review"
    //
    //    //
    //    static let filters = "Filters"
    //    static let categories = "Categories"
    //
    //
    //    static let postComment = "Post Comment"
    //    static let postResponse = "Post Response"
    //
    //
    //    static let unableToSubscribe = "Unable to subscribe"
    //    static let unableToUnsubscribe = "Unable to unsubcribe"
    //
    //    static let unableToFlag = "Unable to flag"
    //    static let unableToUnFlag = "Unable to un flag"
    //
    //    static let unableToPostResponse = "Unable to post reponse"
    //    static let unableToPostComment = "Unable to post comment"
    //
    //
    //    static let unableToVoteUp = "Unable to vote up"
    //    static let unableToVoteDown = "Unable to vote down"
    //
    //    static let last7days = "Last 7 Days"
    //    static let last30days = "Last 30 Days"
    //    static let last90days = "Last 90 Days"
    //    static let lastMonth = "Last Month"
    //    static let last3Month = "Last 3 Months"
    //    static let last6Month = "Last 6 Months"
    //    static let lastYear = "Last Year"
    //    static let allTime = "All time"
    //
    //
    //    static let sentimentTimeline = "Sentiment Timeline"
    //    static let sentimentMap = "Sentiment Map"
    //    static let reviewAnalysis = "Review Analysis"
    //
    //
    //    static let info = "Info"
    //    static let video = "Video"
    //    static let activity = "Activity"
    //    static let analytics = "Analytics"
    //
    //    static let cityPusle = "City Pulse"
    //    static let web = "Web"
    //
    //    static let extremelyPositive = "Extremely Positive"
    //    static let positive = "Positive"
    //    static let neutral = "Neutral"
    //    static let negative = "Negative"
    //    static let extreamlyNegative = "Extremely Negative"
    //
    //    static let analysingTone = "Analyzing Tone"
    //
    //
    //    static let detail = "Detail"
    //
    //    static let clearDescrption = "This will clear the description"
    //
    //    static let neighbourhood = "Neighborhood"
    //    static let state = "State"
    //
    //    static let designation = "Designation"
    //    static let workPlace = "Workplace"
    //
    //    static let credits = "Credits"
    //    static let badges = "Badges"
    //    static let pageViews = "Page Views"
    //    static let donationReceived = "Donations Received"
    //    static let donationMade = "Donations Made"
    //
    //    static let earned = "Earned"
    //    static let toBeEarned = "To be Earned"
    //
    //    static let activeIssues = active + " " + issues
    //    static let resolvedIssues = resolved + " " + issues
    //
    //
    //    static let comment = "Comment"
    //    static let response = "Response"
    //
    //    static let alreadyVoteUp = "You already voted up"
    //    static let alreadyVoteDown = "You already voted down"
    //
    //    static let editResponse = "Edit Response"
    //
    //
    //    static let characters = "Characters"
    //    static let character = "Character"
    //    static let remains = "remains"
    //    static let limitReached = "limit reached"
}
