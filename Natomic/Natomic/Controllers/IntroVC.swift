//
//  IntroVC.swift
//  Natomic
//
//  Created by Archit's Mac on 20/07/23.
//

import UIKit
import CHIPageControl

class IntroVC: UIViewController, UIScrollViewDelegate {
    internal let numberOfPages = 3

    @IBOutlet weak var introScrollView: UIScrollView!
    @IBOutlet weak var pageControls: CHIPageControlJalapeno!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        introScrollView.delegate = self
        pageControls.numberOfPages = self.numberOfPages

       
    }

    @IBAction func skipBTNtapped(_ sender: Any) {
        print("Skip")
    }
    
    @IBAction func rightBTNtapped(_ sender: Any) {
        if selectedIndex == 0 {
            let rightOffset = CGPoint(x: WIDTH, y: 0)
            introScrollView.setContentOffset(rightOffset, animated: true)
        }else if selectedIndex == 1 {
            let rightOffset = CGPoint(x: WIDTH+WIDTH, y: 0)
            introScrollView.setContentOffset(rightOffset, animated: true)
        }
        if selectedIndex < 2 {
            selectedIndex += 1
        }else{
            selectedIndex = 0
        }
        pageControls.progress = Double(Int(selectedIndex))

    }
    
    @IBAction func leftBTNtapped(_ sender: Any) {
        let rightOffset = CGPoint(x: 0, y: 0)
        introScrollView.setContentOffset(rightOffset, animated: true)
        selectedIndex = 0
        pageControls.progress = Double(Int(selectedIndex))

    }
    
    @IBAction func getStartedBTNtapped(_ sender: Any) {
        self.navigationController?.pushViewController(HOME_VC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        
        let progress = percent * Double(self.numberOfPages - 1)
        pageControls.progress = progress
        print(progress)
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        let boundsWidth = scrollView.bounds.width
        let pageIndex = round(contentOffset.x / boundsWidth)
        selectedIndex = Int(pageIndex)

    }



}
