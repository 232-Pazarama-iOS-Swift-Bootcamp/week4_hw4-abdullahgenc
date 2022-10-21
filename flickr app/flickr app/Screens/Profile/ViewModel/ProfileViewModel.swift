//
//  ProfileViewModel.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import Foundation

final class ProfileViewModel: FViewModel {
    private var photos = [Photo]()
    
    var numberOfRows: Int {
        photos.count
    }
    
    var username = String()
    
    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
    
    func fetchFavorites(_ completion: @escaping (Error?) -> Void) {
        photos = []
        guard let uid = uid else {
            return
        }
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else {
                return
            }
            let user = User(from: data)
            self.username = user.username!
            user.favorites?.forEach({ photoId in
                self.db.collection("photos").document(photoId).getDocument { (querySnapshot, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        completion(err)
                    } else {
                        
                        guard let data = querySnapshot?.data() else {
                            return
                        }
                        
                        let photo = Photo(from: data)
                        self.photos.append(photo)
                        completion(nil)
                    }
                }
            })
        }
    }
    
    func fetchBookmarks(_ completion: @escaping (Error?) -> Void) {
        
        photos = []
        
        guard let uid = uid else {
            return
        }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else {
                return
            }
            let user = User(from: data)
            self.username = user.username!
            user.bookmarks?.forEach({ photoId in
                self.db.collection("photos").document(photoId).getDocument { (querySnapshot, err) in
                    if let err = err {
                        completion(err)
                    } else {
                        
                        guard let data = querySnapshot?.data() else {
                            return
                        }
                        let photo = Photo(from: data)
                        self.photos.append(photo)
                        completion(nil)
                    }
                }
            })
        }
    }
}
