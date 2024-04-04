//
//  TextDeatilVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 31/08/23.
//

import UIKit

protocol ShowShareImageScreen {
    func showShareImageScreen()
}


class TextOpenVC : UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var textLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var noteLBL: UILabel!
    @IBOutlet weak var thameBGIMG: UIImageView!
    @IBOutlet weak var shareImageView: UIView!
    @IBOutlet weak var botttomCollectionCon: NSLayoutConstraint!
    @IBOutlet weak var secondThemeImageView: UIImageView!
    
    @IBOutlet weak var userNoteLBL: UILabel!
    // MARK: - Variable's : -
    
    var selectedData : UserEntity?
    var delegate: ShowShareImageScreen?
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        delegate = self
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        view.addGestureRecognizer(swipeGesture)
        textLBL.text = selectedData?.userThoughts ?? ""
        dateLBL.text = DatabaseManager.Shared.convertDateFormat(selectedData?.date ?? "")
        timeLBL.text = DatabaseManager.Shared.convertTo12HourFormat(selectedData?.time ?? "")!
        noteLBL.text = selectedData?.userThoughts ?? ""
        userNoteLBL.text = selectedData?.userThoughts ?? ""
        thameBGIMG.image = nil
        thameBGIMG.backgroundColor = hexStringToUIColor(hex: "#F9C780")
        noteLBL.textColor = .white
        botttomCollectionCon.constant = (WIDTH/2)-50

    }
    
    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .ended {
            // Check if the user swiped from left to right (positive x-translation)
            if translation.x > 50 {
                // Perform the pop action if the swipe was significant enough
                navigationController?.popViewController(animated: true)
            }
        }
    }

    // MARK: - Button Action's : -
    
    @IBAction func backBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shareBTNtapped(_ sender: Any) {
        let vc = SHARE_NOTE_VC
        vc.noteText = textLBL.text ?? ""
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @IBAction func viewMoreBTNtapped(_ sender: Any) {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func firstThemeShareBTNtapped(_ sender: Any) {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.fromTextOpenVC = true
        vc.selectedImage = thameBGIMG.image ?? UIImage()
        vc.textColor = .white
        vc.hexColor = "#F9C780"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func secondThemeShareBTNtapped(_ sender: Any) {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.fromTextOpenVC = true
        vc.selectedImage = secondThemeImageView.image ?? UIImage()
        vc.textColor = .black
        vc.hexColor = ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}


extension TextOpenVC : ShowShareImageScreen{
    func showShareImageScreen() {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}
