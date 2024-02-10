//
//  ShareImageVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 06/02/24.
//

import UIKit

class ShareImageVC: UIViewController {

    @IBOutlet weak var imageThemeCollectionView: UICollectionView!
    @IBOutlet weak var noteLBL: UILabel!
    @IBOutlet weak var thameBGIMG: UIImageView!
    @IBOutlet weak var shareImageView: UIView!
    
    var theameData = [ImageTheameModel]()
    var noreText = ""
    var selectedTheame = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    func setUI(){
        
        imageThemeCollectionView.delegate = self
        imageThemeCollectionView.dataSource = self
        imageThemeCollectionView.register(UINib(nibName: "ImageThemeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageThemeCollectionViewCell")
        noteLBL.text = noreText

        theameData.append(ImageTheameModel.init(imageName: "theam_1", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_2", textColor: .black))
        theameData.append(ImageTheameModel.init(imageName: "theam_3", textColor: .black))
        theameData.append(ImageTheameModel.init(imageName: "theam_4", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_5", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_6", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_7", textColor: .black))
        theameData.append(ImageTheameModel.init(imageName: "theam_8", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_9", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_10", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_11", textColor: .white))
        theameData.append(ImageTheameModel.init(imageName: "theam_12", textColor: .white))
        self.imageThemeCollectionView.reloadData()
    }
    
    @IBAction func backBTNtapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareImgBTNTapped(_ sender: Any) {
        
        if let snapshotImage = shareImageView.snapshotWithTransparentRoundedCorners(cornerRadius: 0) {
            
            
            if let data = snapshotImage.pngData() {
                
                let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
            }

        }

    }
    
}

extension ShareImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theameData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageThemeCollectionViewCell", for: indexPath) as! ImageThemeCollectionViewCell
        cell.theameIMG.image = UIImage.init(named: theameData[indexPath.row].imageName)
        if indexPath.row == selectedTheame {
            cell.theameIMG.borderWidth = 4
            self.thameBGIMG.image = UIImage.init(named: theameData[indexPath.row].imageName)
            self.noteLBL.textColor = theameData[indexPath.row].textColor
        }else{
            cell.theameIMG.borderWidth = 2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTheame = indexPath.row
        self.imageThemeCollectionView.reloadData()
    }
}

extension UIView {
    func snapshotWithTransparentRoundedCorners(cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(bounds)
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            context.addPath(path.cgPath)
            context.clip()
            layer.render(in: context)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                return image.withRenderingMode(.alwaysOriginal)
            }
        }
        return nil
    }
}
