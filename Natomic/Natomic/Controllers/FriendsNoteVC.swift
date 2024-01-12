//
//  FriendsNoteVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 06/01/24.
//

import UIKit

class FriendsNoteVC: UIViewController {

    @IBOutlet weak var historyTBV: UITableView!
    
    var userData : UserNoteModel?
    var selectedCell = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTBV.registerCell(identifire: "HistoryTableCell")

    }
    
//    func getUserData(){
//        DatabaseHelper.shared.fetchUserData { result in
//            switch result {
//            case .success(let NoteModel):
//                self.userData = NoteModel.response?.reversed()
//                self.historyTBV.reloadData()
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }

    
    @IBAction func backBTNtapped(_ sender: Any) {
    }
    
}

extension FriendsNoteVC: SetTableViewDelegateAndDataSorce {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData?.response?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        if selectedCell == indexPath.row {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.8941176471, blue: 0.8196078431, alpha: 1)
        }else{
            cell.contentView.backgroundColor = .clear
        }
        cell.usersTextLBL.text = userData?.response?[indexPath.row].note ?? ""
        cell.dateLBL.text = userData?.response?[indexPath.row].notedate ?? ""
        cell.timeLBL.text = userData?.response?[indexPath.row].notetime ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCell = indexPath.row
//        self.historyTBV.reloadData()
//        
//        let vc = TEXT_OPEN_VC
//        vc.selectedData = userData?[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let viewControllerToPresent = TEXT_DETAIL_VC
        //        viewControllerToPresent.selectedData = userData?[indexPath.row]
        //        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        //        self.present(viewControllerToPresent, animated: false, completion: nil)
    }
    
}
