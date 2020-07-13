//
//  VideoPostsModel.swift
//  My_Moment
//
//  Created by Shashikant's_Macmini on 10/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import Firebase
import Foundation


typealias VideoPostObj = [String: VideoPostModel]

struct VideoPostModel: Codable {
    
    var url: String
    var user: User?
    var rating: Int?
    var referID: String?
    var isPublic: Bool?
    var createdOn: String?
    var reportRating: Int?
    var description: String?
    
    struct User: Codable {
        var name: String?
        var email: String?
    }//struct
    
    static func getListing(_ onComplection: @escaping((VideoPostObj)->())) {
        let ref = VideoPostModel.getDatabaseReferance()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let fbdata = snapshot.data else {
                onComplection([:])
                return
            }
            do {
                let dict = try JSONDecoder().decode(VideoPostObj.self, from: fbdata)
                onComplection(dict)
            } catch {
                debugPrint("Function: \(#function), line: \(#line), Error: \(error.localizedDescription)")
            }
        }) { error in
            onComplection([:])
            debugPrint("Function: \(#function), line: \(#line), Error: \(error.localizedDescription)")
        }
    }
    
    static func newVideoAdded(_ onComplection: @escaping((String, VideoPostModel?)->())) {
        let ref = VideoPostModel.getDatabaseReferance()
        ref.observe(.childAdded, with: { (snapshot) in
            guard let fbdata = snapshot.data else {
                onComplection(snapshot.key, nil)
                return
            }
            do {
                let obj = try JSONDecoder().decode(VideoPostModel.self, from: fbdata)
                onComplection(snapshot.key, obj)
            } catch {
                debugPrint("Function: \(#function), line: \(#line), Error: \(error.localizedDescription)")
            }
        }) { error in
            onComplection("", nil)
            debugPrint("Function: \(#function), line: \(#line), Error: \(error.localizedDescription)")
        }
    }
        
    static func getSingleObj(_ key: String, _ onComplection: @escaping(([String: Any]?)->())) {
        let ref = VideoPostModel.getDatabaseReferance()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {
                onComplection(nil)
                return
            }
            onComplection(dict)
        }) { error in
            onComplection(nil)
            debugPrint("Function: \(#function), line: \(#line), Error: \(error.localizedDescription)")
        }
    }
    
    static func updateData(_ key: String, _ onComplection: @escaping((Bool)->())) {
        
        VideoPostModel.getSingleObj(key) { (dict) in
            guard let dict = dict else {
                onComplection(false)
                debugPrint("Function: \(#function), line: \(#line), Error: Fail to get Object")
                return
            }
            var parameter = dict
            let rating = dict["rating"] as? Int ?? 0
            parameter["rating"] = rating + 1
            let ref = VideoPostModel.getDatabaseReferance().child(key)
            ref.setValue(parameter, andPriority: nil)
            onComplection(true)
        }
    }
    
    static func addData(description: String, url: String) {
        let currentUser =  Auth.auth().currentUser
        let user = ["name": currentUser?.displayName ?? "", "email": currentUser?.email ?? ""]

        var parameter = [String: Any]()
        parameter["url"] = ""
        parameter["user"] = user
        parameter["rating"] = 0
        parameter["referID"] = ""
        parameter["isPublic"] = true
        parameter["createdOn"] = String.getStringFromDate(formate: "MMM d, h:mm a", date: Date())
        parameter["reportRating"] = 0
        parameter["description"] = description
        parameter["url"] = url
        
        let ref = VideoPostModel.getDatabaseReferance().child("\(Int(Date().timeIntervalSince1970))")
        ref.setValue(parameter, andPriority: nil)
    }
    
    static private func getDatabaseReferance()->DatabaseReference {
        return Database.database().reference()
    }
    
    static private func getStoregeReferance()->StorageReference {
        let fbStorage = Storage.storage()
        return fbStorage.reference().child("/Videos")
    }
    
    static private func getStoregeForStoreReferance()->StorageReference {
        let fbStorage = Storage.storage()
        return fbStorage.reference().child("/Videos/\(Int(Date().timeIntervalSince1970)).mov")
    }
    static func uploadVideo(_ videoPath: URL, _ complection: ((URL?)->())?) {
        guard Auth.auth().currentUser != nil else {
            debugPrint("Function: \(#function), line: \(#line), Error: \("Login Required")")
            complection?(nil)
            return
        }
        
        let uploadTask = VideoPostModel.getStoregeForStoreReferance().putFile(from: videoPath, metadata: nil) { (metadata, error) in
            guard let metadata = metadata, let fileName = metadata.name else {
                debugPrint("Function: \(#function), line: \(#line), Error: \(error?.localizedDescription ?? "")")
                complection?(nil)
                return
            }
            
            VideoPostModel.getStoregeReferance().child(fileName).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    debugPrint("Function: \(#function), line: \(#line), Error: \(error?.localizedDescription ?? "")")
                    complection?(nil)
                    return
                }
                complection?(downloadURL)
            }
        }
        uploadTask.resume()
    }
    
} //struct
