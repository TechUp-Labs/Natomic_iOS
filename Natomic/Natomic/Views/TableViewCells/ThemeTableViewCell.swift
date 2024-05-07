//
//  ThemeTableViewCell.swift
//  Natomic
//
//  Created by Archit Navadiya on 01/03/24.
//

import UIKit



protocol ThemeCollectionViewCellDelegate: AnyObject {
    func didSelectTheme(thameBGIMG:UIImage,backgroundColor:UIColor,textColor:UIColor)
}

class ThemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageThemeCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var theameTitleLBL: UILabel!
    @IBOutlet weak var BGView: UIView!
    var theameData = [ImageTheameModel]()
    var selectedTheame = -1
    weak var delegate: ThemeCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageThemeCollectionView.delegate = self
        imageThemeCollectionView.dataSource = self
        imageThemeCollectionView.registerCell(identifire: "ImageThemeCollectionViewCell")
        imageThemeCollectionView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension ThemeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theameData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageThemeCollectionViewCell", for: indexPath) as! ImageThemeCollectionViewCell
        if theameData[indexPath.row].imageName == "" {
            cell.theameIMG.image = nil
        }else{
            cell.theameIMG.image = UIImage.init(named: theameData[indexPath.row].imageName)
        }
        cell.theameIMG.backgroundColor = hexStringToUIColor(hex: theameData[indexPath.row].backgroundColor)
        if indexPath.row == selectedTheame {
            cell.theameIMG.borderWidth = 4
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
        let width = imageThemeCollectionView.frame.width / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTheame = indexPath.row
        self.imageThemeCollectionView.reloadData()
        if theameData[indexPath.row].imageName == "" {
            SHARED_IMAGE = theameData[indexPath.row].backgroundColor
            TrackEvent.shared.trackSelectionOfImage(selectedImage: theameData[indexPath.row].backgroundColor)
            let backgroundColor : UIColor = hexStringToUIColor(hex: theameData[indexPath.row].backgroundColor)
            let themeImage: UIImage? = theameData[indexPath.row].imageName.isEmpty ? nil : UIImage(named: theameData[indexPath.row].imageName)
            delegate?.didSelectTheme(thameBGIMG: themeImage ?? UIImage(), backgroundColor: backgroundColor, textColor: theameData[indexPath.row].textColor)
        }else{
            SHARED_IMAGE = theameData[indexPath.row].imageName
            let backgroundColor : UIColor = .clear
            TrackEvent.shared.trackSelectionOfImage(selectedImage: theameData[indexPath.row].imageName)
            let themeImage: UIImage? = theameData[indexPath.row].imageName.isEmpty ? nil : UIImage(named: theameData[indexPath.row].imageName)
            delegate?.didSelectTheme(thameBGIMG: themeImage ?? UIImage(), backgroundColor: backgroundColor, textColor: theameData[indexPath.row].textColor)
        }

    }
    
}


