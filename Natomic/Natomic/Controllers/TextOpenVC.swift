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
    
}


extension TextOpenVC : ShowShareImageScreen{
    func showShareImageScreen() {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}
