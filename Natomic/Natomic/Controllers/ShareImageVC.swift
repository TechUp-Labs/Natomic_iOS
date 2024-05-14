//
//  ShareImageVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 06/02/24.
//

import UIKit

class ShareImageVC: UIViewController, ThemeCollectionViewCellDelegate {
    

    @IBOutlet weak var imageThemeCollectionView: UICollectionView!
    @IBOutlet weak var noteLBL: UILabel!
    @IBOutlet weak var thameBGIMG: UIImageView!
    @IBOutlet weak var shareImageView: UIView!
    @IBOutlet weak var themeTableView: UITableView!
    
    var theameData = [ImageTheameModel]()
    var themeTableData = [ThemeTableData]()
    var noreText = ""
    var selectedTheame = 0
    var selectedLableColor = 0
    var fromTextOpenVC = false
    var selectedImage = UIImage()
    var textColor = UIColor()
    var hexColor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.themeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.themeTableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TrackEvent.shared.track(eventName: .closeShareImageScreenButtonTapped)
    }
    
    func setUI(){
        
        noteLBL.text = noreText
        noteLBL.adjustFontSizeToFitRect(rect: noteLBL.bounds)
        if fromTextOpenVC {
            self.thameBGIMG.image = selectedImage
            self.thameBGIMG.backgroundColor = hexStringToUIColor(hex: hexColor)
            self.noteLBL.textColor = textColor
        }else{
            self.thameBGIMG.image = nil
            self.thameBGIMG.backgroundColor = hexStringToUIColor(hex: "#FFFFFF")
            SHARED_IMAGE = "#FFFFFF"
            self.noteLBL.textColor = .black
        }
        
        themeTableView.registerCell(identifire: "ThemeTableViewCell")
        
        themeTableData.append(ThemeTableData.init(themeTitle: "Solid colours",themes: [
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#FFFFFF"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#F2EFE4"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#1C1C21"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#EED3C8"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#F9C780"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#CB9479"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#BDD3D0"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#F4D2B8"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#7DBEEE"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#C4ECD4"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#AB9274"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#7C6A91"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#D9B538"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#4E725B"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#FFE8C3"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#F9D15D"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#ED9A51"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#FAEEC4"),
            ImageTheameModel.init(imageName: "", textColor: .white, backgroundColor: "#4141B3"),
            ImageTheameModel.init(imageName: "", textColor: .black, backgroundColor: "#E890E4")

        ]))
        
        
        themeTableData.append(ThemeTableData.init(themeTitle: "Gradient",themes: [
            ImageTheameModel.init(imageName: "Image 18", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 19", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 20", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 21", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 22", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 23", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 24", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 25", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 26", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 27", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 28", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 29", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 30", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 68", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 67", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 69", textColor: .black, backgroundColor: "")

        ]))
        
        
        themeTableData.append(ThemeTableData.init(themeTitle: "Abstract",themes: [
            ImageTheameModel.init(imageName: "Image 37", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 38", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 39", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 40", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 41", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 42", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 31", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 32", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 33", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 34", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 35", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 36", textColor: .black, backgroundColor: "")
        ]))

        themeTableData.append(ThemeTableData.init(themeTitle: "Celebration",themes: [
            ImageTheameModel.init(imageName: "Image 49", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 50", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 51", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 52", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 53", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 54", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 61", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 71", textColor: .black, backgroundColor: "")

        ]))
        
        themeTableData.append(ThemeTableData.init(themeTitle: "Zen",themes: [
            ImageTheameModel.init(imageName: "Image 55", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 56", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 43", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 44", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 45", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 46", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 47", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 48", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 62", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 63", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 70", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 76", textColor: .black, backgroundColor: "")
        ]))

        themeTableData.append(ThemeTableData.init(themeTitle: "Travel",themes: [
            ImageTheameModel.init(imageName: "Image 57", textColor: .white, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 58", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 59", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 60", textColor: .black, backgroundColor: "")
        ]))
        
        themeTableData.append(ThemeTableData.init(themeTitle: "Notebook",themes: [
            ImageTheameModel.init(imageName: "Image 75", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 74", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 73", textColor: .black, backgroundColor: ""),
            ImageTheameModel.init(imageName: "Image 72", textColor: .black, backgroundColor: "")
        ]))
        
//        noteLBL.translatesAutoresizingMaskIntoConstraints = false
//        noteLBL.numberOfLines = 0  // Allow multiple lines
//        noteLBL.lineBreakMode = .byWordWrapping
//        adjustFontSizeToFitLabel()
        
        self.themeTableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    func adjustFontSizeToFitLabel() {
        guard let text = noteLBL.text else { return }
        
        let maxFontSize: CGFloat = 20  // Define maximum font size
        let minFontSize: CGFloat = 5  // Define minimum font size
        var currentFontSize: CGFloat = maxFontSize

        // Iteratively find the right font size
        while currentFontSize >= minFontSize {
            let potentialFont = UIFont.systemFont(ofSize: currentFontSize)
            let size = (text as NSString).size(withAttributes: [.font: potentialFont])
            
            if size.width <= noteLBL.bounds.width && size.height <= noteLBL.bounds.height {
                noteLBL.font = potentialFont
                break
            }
            
            currentFontSize -= 1
        }
    }
    
    func didSelectTheme(thameBGIMG: UIImage, backgroundColor: UIColor, textColor: UIColor) {
        self.thameBGIMG.image = thameBGIMG
        self.thameBGIMG.backgroundColor = backgroundColor
        self.noteLBL.textColor = textColor
    }

    
    @IBAction func backBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .closeShareImageScreenButtonTapped)
        self.dismiss(animated: true)
    }
    
    @IBAction func shareImgBTNTapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .shareImageButtonClick)
        TrackEvent.shared.trackSharedImage(selectedImage: SHARED_IMAGE)
        if let snapshotImage = shareImageView.snapshotWithTransparentRoundedCorners(cornerRadius: 0) {
            if let data = snapshotImage.pngData() {
                let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func downloadImageBTNTapped(_ sender: Any) {
    }
}

extension ShareImageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell", for: indexPath) as! ThemeTableViewCell
        cell.theameTitleLBL.text = self.themeTableData[indexPath.row].themeTitle ?? ""
        cell.delegate = self
        cell.theameData = self.themeTableData[indexPath.row].themes ?? []
        cell.imageThemeCollectionView.reloadData()
        cell.collectionHeight.constant = cell.imageThemeCollectionView.collectionViewLayout.collectionViewContentSize.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension UITableView {

    func reloadDataWithoutScroll() {
        let offset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }
}

extension UIViewController{
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

extension UILabel {
    func adjustFontSizeToFitRect(rect : CGRect) {
        if let unwrappedText = text {
            let maxFontSize: CGFloat = 20.0
            let minFontSize: CGFloat = 10.0  // You can adjust this minimum as needed
            let constraintRect = CGSize(width: rect.width, height: .greatestFiniteMagnitude)
            
            var fittingFontSize = maxFontSize
            for fontSize in stride(from: maxFontSize, through: minFontSize, by: -0.5) {
                let font = UIFont(name: self.font.fontName, size: fontSize)!
                let attributes = [NSAttributedString.Key.font: font]
                let stringRect = unwrappedText.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                if stringRect.height <= rect.height {
                    fittingFontSize = fontSize
                    break
                }
            }
            self.font = UIFont(name: self.font.fontName, size: fittingFontSize)
        }
    }
}
