//
//  ShareNoteVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 05/02/24.
//

import UIKit

class ShareNoteVC: UIViewController {
    
    @IBOutlet weak var shareTxtButton: UIButton!
    @IBOutlet weak var shareImgButton: UIButton!
    
    var delegate: ShowShareImageScreen?
    var noteText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .shareNoteAlertCloseButtonClick)
        self.dismiss(animated: false)
    }
    
    @IBAction func shareTextBNTtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .shareNoteTextButtonClick)
        let textToShare = [noteText] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareIMGBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .shareNoteImageButtonClick)
        self.dismiss(animated: false) {
            self.delegate?.showShareImageScreen()
        }
    }
}
