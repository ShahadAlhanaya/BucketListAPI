//
//  TaskModel.swift
//  BucketList
//
//  Created by Shahad Nasser on 21/12/2021.
//

import Foundation
class TaskModel {
    static func getAllTasks(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "https://saudibucketlistapi.herokuapp.com/tasks/")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
    static func addTask(objective: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
            if let urlToReq = URL(string: "https://saudibucketlistapi.herokuapp.com/tasks/") {
                var request = URLRequest(url: urlToReq)
                request.httpMethod = "POST"
                let bodyData = "objective=\(objective)"
                request.httpBody = bodyData.data(using: .utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
                task.resume()
            }
    }
    
    static func editTask(objective: String, id: Int, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
            if let urlToReq = URL(string: "https://saudibucketlistapi.herokuapp.com/tasks/\(id)/") {
                var request = URLRequest(url: urlToReq)
                request.httpMethod = "PUT"
                request.allHTTPHeaderFields = [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
                let jsonDictionary: [String: String] = [
                    "objective": objective,
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
                request.httpBody = bodyData
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
                task.resume()
            }
    }
    
    static func deleteTask(id: Int, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
            if let urlToReq = URL(string: "https://saudibucketlistapi.herokuapp.com/tasks/\(id)/") {
                var request = URLRequest(url: urlToReq)
                request.httpMethod = "DELETE"
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
                task.resume()
            }
    }
}
