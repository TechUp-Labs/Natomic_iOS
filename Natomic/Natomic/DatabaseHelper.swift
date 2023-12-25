//
//  DatabaseHelper.swift
//  Demo_Natomic_API_Test
//
//  Created by Archit Navadiya on 12/10/23.
//

import Foundation
import Alamofire

class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    
    // MARK: - Resgister User API : -

    
    func registerUser(uid: String, name: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://52.13.22.47/Natomic-API/addUser.php"
        
        let parameters: [String: Any] = [
            "uid": uid,
            "name": name,
            "email": email
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let status = json["code"] as? Int,
                       let message = json["message"] as? String {
                        if status == 200 || status == 422 {
                            completion(.success(message))
                        } else {
                            // Handle other status codes or error scenarios here
                            let error = NSError(domain: "YourErrorDomain", code: status, userInfo: [NSLocalizedDescriptionKey: message])
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "YourErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    // MARK: - Get User Notes API : -
    
    func fetchUserData(completion: @escaping (Result<UserNoteModel, Error>) -> Void) {
        let url = "http://52.13.22.47/Natomic-API/fetchUserData.php?uid=\(UID)"
        
        AF.request(url, method: .get).responseDecodable(of: UserNoteModel.self) { response in
            switch response.result {
            case .success(let userNoteModel):
                completion(.success(userNoteModel))
            case .failure(let error):
                // Check if the response contains data
                if let data = response.data {
                    // Print the raw response data as a string
                    let responseString = String(data: data, encoding: .utf8)
                    print("Raw Response: \(responseString ?? "Unable to convert data to string")")
                }
                
                // Check the content type of the response
                if let contentType = response.response?.allHeaderFields["Content-Type"] as? String {
                    print("Content Type: \(contentType)")
                }
                

                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Post User Notes API : -

    func postUserNote(uid: String, note: String, date:String, time:String, completion: @escaping (Result<Data?, Error>) -> Void) {
        let url = "http://52.13.22.47/Natomic-API/addUserNotes.php"
        
        let parameters: [String: Any] = [
            "uid": uid,
            "note": note,
            "device_name": CURRENT_DEVICE_NAME,
            "note_date": date,
            "note_time": time
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate() // Optional: You can add validation if needed
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


    func postFeedback(response: Int, comment: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        let url = "https://api.feedspace.io/api/v1/open/features/OduZWpYrGLpIYi5V/feedback"
        
        let parameters: [String: Any] = [
            "response": response,
            "comment": comment,
            "app_URL": "https://feedspace.io/c/OduZWpYrGLpIYi5V",
            "extra_details": [
                "name": USER_NAME,
                "email": USER_EMAIL,
                "uid":UID
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate() // Optional: You can add validation if needed
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
}
