//
//  TrackEvent.swift
//  Natomic
//
//  Created by Archit Navadiya on 09/04/24.
//

import Foundation
import Mixpanel


class TrackEvent {
    
    static let shared = TrackEvent()
    
    func track(eventName: EventName.Event) {
        Mixpanel.mainInstance().track(event: eventName.rawValue, properties: [
            "User Name": USER_NAME,
            "Email": USER_EMAIL,
            "User ID": UID
        ])
    }
    
    func resetUSer(){
        Mixpanel.mainInstance().reset()
    }
    
    func registerUser(userIID: String){
        Mixpanel.mainInstance().identify(distinctId: userIID)
    }
    
    func trackRemiderTime(reminderTime: String){
        Mixpanel.mainInstance().track(event: "Reminder Time", properties: [
            "Reminder Time": reminderTime,
            "User Name": USER_NAME,
            "Email": USER_EMAIL,
            "User ID": UID
        ])
    }
    
    func trackSelectionOfImage(selectedImage: String){
        Mixpanel.mainInstance().track(event: "Selection Of Images", properties: [
            "Selected Image": selectedImage,
            "User Name": USER_NAME,
            "Email": USER_EMAIL,
            "User ID": UID
        ])
    }
    
    func trackSharedImage(selectedImage: String){
        Mixpanel.mainInstance().track(event: "Shared Image", properties: [
            "Selected Image": selectedImage,
            "User Name": USER_NAME,
            "Email": USER_EMAIL,
            "User ID": UID
        ])
    }
    
    func trackSearchedText(SearchedText: String){
        Mixpanel.mainInstance().track(event: "Searched Text", properties: [
            "Searched Text": SearchedText,
            "User Name": USER_NAME,
            "Email": USER_EMAIL,
            "User ID": UID
        ])
    }
    
    func trackSearchBarCancelButtonClick(SearchedText: String){
        Mixpanel.mainInstance().track(event: "Search Bar Cancel Button Click", properties: [
            "Searched Text": SearchedText,
            "User Name": USER_NAME,
            "Email": USER_EMAIL,
            "User ID": UID
        ])
    }


    
}

struct EventName {
    
    enum Event : String {
        
        // MARK: - App Events:-
        
        case openApp = "Open App"
        
        case closeApp = "Close App"
        
        // MARK: - Welcome Screen Events:-
        
        case goForItButtonClick = "Go for it Button Click"
        
        // MARK: - Home Screen Events:-
        
        case writeNowButtonClick = "Home Write Now Button Click"
        
        case setReminderHomeButtonClick = "Home Set Reminder Button Click"
        
        case noteOpenButtonClick = "Open Note"

//        case profileButtonClick = "Home Profile Button Click"

        case profileButtonClick = "Home Profile Button Click"
        
        case editNoteButtonClick = "Home Edit Note Button Click"
                
        case deleteNoteButtonClick = "Home Delete Note Button Click"
        
        case deleteNoteSuccessfullyButtonClick = "Delete Note Successfully"
                
        // MARK: - Writing Screen Events:-

        case postNoteButtonClick = "Post Note Button Click"

        case noteAddedSuccessfullyButtonClick = "Note Added Successfully"
        
        case closeWritingScreeneButtonClick = "Close Writing Button Click"
        
        // MARK: - Open Note Screen Events:-
        
        case backButtonClickNoteDeatilScreen = "Note Detail back Button Click"
        
        case shareNoteButtonClickNoteDeatilScreen = "Note Detail Share Image Button Click"
        
        // MARK: - Edit Note Screen Events:-
        
        case editNoteCloseButtonClick = "Edit Note Close Button Click"
        
        case editNoteSuccessfullyButtonClick = "Edit Note Successfully"

        // MARK: - Remider Screen Events:-
                
        case closeRemiderButtonClick = "Close Reminder Button Click"

        case setReminderNowButtonClick = "Save Reminder Time Button Click"
        
        // MARK: - Writing Alert Screen Events:-
        
        case letsWriteButtonClick = "Let's Write Button Click"
        
        case writingAlertCloseButtonClick = "Writing Alert Close Button Click"

        
        // MARK: - Set Reminder Alert Screen Events:-
        
        case doItLaterButtonClick = "Do It Later Button Click (Set Reminder Alert Screen)"
        
        case setNowButtonClickReminderAlertScreen = "Set Now Button Click (Set Reminder Alert Screen)"
        
        // MARK: - Menu Screen Events:-
        
        case signupBackButtonClick = "Signup Back Button Click"
        
        case appleSignupButtonClick = "Apple Signup Button Click"
        
        case googleSignupButtonClick = "Google Signup Button Click"

        case signUpWithGoogle = "Google Signup"
        
        case signUpWithApple = "Apple Signup"
        
        
        // MARK: - Share Note Screen Events:-
        

        case shareNoteAlertCloseButtonClick = "Close Share Note Alert Button Click"
        
        case shareNoteTextButtonClick = "Share Note Text Button Click"
        
        case shareNoteImageButtonClick = "Share Note Image Button Click"

        // MARK: - Share Image Screen Events:-
        
        case closeShareImageScreenButtonTapped = "Close Share Image Screen Button Click"

        case shareImageButtonClick = "Share Image Button Click"
        
        // MARK: - Profile Screen Events:-
        
        case profileBackButtonClick = "Profile Back Button Click"

        case shareAppButtonClick = "Share App Button Click"
        
        case streakButtonClick = "Streak Button Click"
        
        case feedBackButtonClick = "Feedback Button Click"

        case deleteAccountButtonClick = "Delete Account Button Click"
        
        case logoutButtonClick = "Logout Button Click"
        
        case logoutCancelButtonClick = "Logout Cancel Button Click"
        
        case logout = "User Logout"

        // MARK: - Feedback Screen Events:-
        
        case feedbackBackButtonClick = "Feedback Back Button Click"

        case feedbackSubmitButtonClick = "Feedback Submit Button Click"
        
        // MARK: - Delete Account Alert Screen Events:-
        
        case deleteAppDataButtonClick = "Delete App Data Button Click"
        
        case deleteAppDataSuccessfullyButtonClick = "Delete App Data Successfully"
        
        case closeDeleteAlertButtonClick = "Close Delete Alert Button Click"
        
        
        // MARK: - Streak Screen Events:-

        case closeStreakScreenButtonClick = "close Streak Screen Button Click"
        
        case previousMonthButtonTapped = "Streak Screen previous Month Button Click"
        
        case nextMonthButtonTapped = "Streak Screen Next Month Button Click"
        
        case dateSelection = "Streak Screen Date Selection"
        
        // MARK: - Notifications and Widgets Events:-

        case reminderNotification = "reminder Notification Click"
        
        case sevenDayNotification = "Seven Day Notification Click"
        
        case widgetClick = "Widget Click"

//        case noteWidget = "Note Widget Click"
//        
//        case streakWidget = "Streak Widget Click"

    }
    
}
