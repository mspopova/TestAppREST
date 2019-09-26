//
//  NetworkManager.swift
//  TestApp
//
//  Created by Марина Попова on 26/09/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//
import Foundation
import UIKit

class NetworkManager {
    
    let userSession = UserSession.shared
    
    func checkUserSession() {
        if userSession.session == "" {
            createSession()
        }
        else {return}
    }
    
    func createSession() {
        var request = URLRequest(url: createURL())
        request.httpMethod = "POST"
        request.addValue(userSession.token, forHTTPHeaderField: "token")
        let postString = "a=new_session"
        request.httpBody = postString.data(using: .utf8)
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let userJson = json as? [String: Any],
                    let data = userJson["data"] as? [String: Any],
                    let session = data["session"] as? String else { preconditionFailure("Bad JSON") }
                print(session)
                self.userSession.session = session
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getEntries(completion: (([Entry]?) -> Void)? = nil){
        var request = URLRequest(url: createURL())
        request.httpMethod = "POST"
        request.addValue(userSession.token, forHTTPHeaderField: "token")
        let postString = "a=get_entries&session=\(userSession.session)"
        request.httpBody = postString.data(using: .utf8)
        
        var entries = [Entry]()
        
        let task2 = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let userJson = json as? [String: Any],
                    let dataArray = userJson["data"] as? [Any] else { preconditionFailure("Bad JSON") }
                for elementData in dataArray {
                    guard let array = elementData as? [Any] else { preconditionFailure("Bad JSON") }
                    for element in array {
                        guard let data = element as? [String: Any],
                            let body = data["body"] as? String,
                            let da = data["da"] as? String,
                            let dm = data["dm"] as? String else { preconditionFailure("Bad JSON") }
                        if let dataA = Double(da),
                            let dataM = Double(dm) {
                            let dataUpdate = Date(timeIntervalSince1970: Double(dataM))
                            let dataCreate = Date(timeIntervalSince1970: Double(dataA))
                            let entry = Entry(body: body, da: dataCreate, dm: dataUpdate)
                            entries.append(entry)
                        }
                    }
                }
                completion?(entries)

            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion?(nil)
            }
        }
        task2.resume()

    }
    
    func makeEntry(text: String?) {
        let sem = DispatchSemaphore(value: 0)
        var request = URLRequest(url: createURL())
        request.httpMethod = "POST"
        request.addValue(userSession.token, forHTTPHeaderField: "token")
        if let text = text {
            let postString = "a=add_entry&session=\(userSession.session)&body=\(text)"
            request.httpBody = postString.data(using: .utf8)
        } else {
            preconditionFailure("Bad text in TextView")
        }
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            sem.signal()
        }
        task.resume()
        sem.wait()
    }
    
    func createURL() -> URL{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "bnet.i-partner.ru"
        urlComponents.path = "/testAPI/"

        guard let url = urlComponents.url else { preconditionFailure("Bad url for bnet.i-partner.ru") }
        return url
    }
    
    
}
