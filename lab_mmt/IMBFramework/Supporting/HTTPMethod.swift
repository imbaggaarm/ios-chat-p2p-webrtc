////
////  Method.swift
////  appECONVEETEMP
////
////  Created by Tai Duong on 1/3/17.
////  Copyright © 2017 Tai Duong. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//fileprivate enum HTTPMethod: String{
//    case GET = "GET"
//    case POST = "POST"
//    case PUT = "PUT"
//    case DELETE = "DELETE"
//    case HEAD = "HEAD"
//    var toString: String{
//        return self.rawValue
//    }
//}
//
////enum HTTPHeaderField: String{
////    case Authorization = "Authorization"
////}
//
//class HTTPWebService {
//
////    func loadDataWebService(linkAPI: API, method: String = "GET", keyAndValue: Dictionary<String, Any> = [:], completion: @escaping (Data?) -> Void)
////    {
////        var tempURLString = linkAPI.fullLink
////        let param = keyAndValue.convertDicToParamType()
////        if method == "GET"
////        {
////            if param != ""
////            {
////                tempURLString += "?\(param)"
////            }
////        }
////        let url = URL(string: tempURLString)
////        //print(url!)
////        var urlRequest = URLRequest(url: url!)
////
////        if method == "POST"
////        {
////            urlRequest.httpBody = param.data(using: .utf8)!
////            urlRequest.httpMethod = method
////        }
////
////        let session = URLSession.shared
////        session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
////            if error == nil
////            {
////                completion(data)
////            }
////            else
////            {
////                completion(nil)
////            }
////        }).resume()
////    }
////
////    func loadDataWebService(linkAPI: API, method: HTTPMethod, keyAndValue: Dictionary<String, Any> = [:], completion: @escaping (Data?) -> Void)
////    {
////        var tempURLString = linkAPI.fullLink
////        let param = keyAndValue.convertDicToParamType()
////        if method.rawValue == "GET"
////        {
////            if param != ""
////            {
////                tempURLString += "?\(param)"
////            }
////        }
////        let url = URL(string: tempURLString)
////        //print(url!)
////        var urlRequest = URLRequest(url: url!)
////
////        if method.rawValue == "POST"
////        {
////            urlRequest.httpBody = param.data(using: .utf8)!
////            urlRequest.httpMethod = method.rawValue
////        }
////
////        let session = URLSession.shared
////        session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
////            if error == nil
////            {
////                completion(data)
////            }
////            else
////            {
////                completion(nil)
////            }
////        }).resume()
////    }
////
////
////    func loadDataWebService(urlString: String, method: HTTPMethod = .GET, keyAndValue: Dictionary<String, Any> = [:], completion: @escaping (Data?) -> Void)
////    {
////        var tempURLString = urlString
////        let param = keyAndValue.convertDicToParamType()
////        if method.rawValue == "GET"
////        {
////            if param != ""
////            {
////                tempURLString += "?\(param)"
////            }
////        }
////        let url = URL(string: tempURLString)
////        //print(url!)
////        var urlRequest = URLRequest(url: url!)
////
////        if method.rawValue == "POST"
////        {
////            urlRequest.httpBody = param.data(using: .utf8)!
////            urlRequest.httpMethod = method.rawValue
////        }
////
////        let session = URLSession.shared
////        session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
////            if error == nil
////            {
////                completion(data)
////            }
////            else
////            {
////                completion(nil)
////            }
////        }).resume()
////    }
////
////
////
////
////    func loadJSON(linkAPI: API, method: HTTPMethod = .GET, keyAndValue: Dictionary<String, Any> = [:], completion: @escaping  (Any?) -> (Void))
////    {
////        var tempURLString = linkAPI.fullLink
////        let param = keyAndValue.convertDicToParamType()
////
////        if method == .GET
////        {
////            if param != ""
////            {
////                tempURLString += "?\(param)"
////            }
////        }
////        let url = URL(string: tempURLString)
////        //print(url!)
////        var urlRequest = URLRequest(url: url!)
////
////        if method == .POST
////        {
////            urlRequest.httpBody = param.data(using: .utf8)!
////            urlRequest.httpMethod = method.toString
////        }
////
////        let session = URLSession.shared
////        session.dataTask(with: urlRequest, completionHandler: {(data, response, err) in
////            if err == nil
////            {
////                do{
////                    let temp = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
////                    //print("check if")
////                    completion(temp)
////                }
////                catch
////                {
////                    //print("check if")
////                    completion(nil)
////                }
////            }
////            else
////            {
////                completion(nil)
////            }
////        }).resume()
////    }
//
//    func loadJSON(urlString: String, method: HTTPMethod = .GET, keyAndValue: Dictionary<String, Any> = [:], idToken: String, completion: @escaping  (Any?) -> (Void))
//    {
//        var tempURLString = urlString
//        let param = keyAndValue.convertDicToParamType()
//
//        if method == .GET
//        {
//            if param != ""
//            {
//                tempURLString += "?\(param)"
//            }
//        }
//        let url = URL(string: tempURLString)
//        //print(url!)
//        var urlRequest = URLRequest(url: url!)
//
//        if method == .POST
//        {
//            urlRequest.httpBody = param.data(using: .utf8)!
//            urlRequest.httpMethod = method.toString
//            urlRequest.setValue(idToken, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
//        }
//        //print(urlRequest.httpBody)
//
//        let session = URLSession.shared
//        session.dataTask(with: urlRequest, completionHandler: {(data, response, err) in
//            if err == nil
//            {
//                do{
//                    let temp = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                    //print("check if")
//                    completion(temp)
//                }
//                catch
//                {
//                    //print("check if")
//                    completion(nil)
//                }
//            }
//            else
//            {
//                completion(nil)
//            }
//        }).resume()
//    }
//
////    func postAndLoadDifferentData(urlString: API, keyAndValue: Dictionary<String,Any> = [:], method: HTTPMethod, completionHandler: @escaping (Any?)->()){
////        var urlStringGet: String = urlString.fullLink
////        var index: Int = 0
////        switch method {
////        case .POST:
////            index = 1
////        default:
////            do
////            {
////                let param = keyAndValue.convertDicToParamType()
////                if param != ""
////                {
////                    urlStringGet += "?\(param)"
////                }
////            }
////        }
////        //print("////////\(index)")
////        let url:URL = URL(string: urlStringGet)!
////        var request:URLRequest = URLRequest(url: url)
////        if index == 1{
////            let boundary = generateBoundaryString()
////            let body = NSMutableData()
////            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
////            for pr in keyAndValue{
////                if let image:UIImage = pr.value as? UIImage
////                {
////                    let data = UIImageJPEGRepresentation(image, 0.5)
////                    let fname:String = "\(getTime()).jpeg"
////                    let mimetype = "image/png"
////                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("Content-Disposition:form-data; name=\"\(pr.key)\"; FileName=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
////                    body.append(data!)
////                    body.append("\r\n".data(using: String.Encoding.utf8)!)
////                }else{
////                    //----------upload them param
////                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("Content-Disposition: form-data; name=\"\(pr.key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("\(pr.value)\r\n".data(using: String.Encoding.utf8)!)
////                }
////                //    body.append("&ten=datnguyen".data(using: String.Encoding.utf8)!)
////                request.httpMethod = "POST"
////                request.httpBody = body as Data
////            }
////        }
////        let session:URLSession = URLSession.shared
////        session.dataTask(with: request, completionHandler: {
////            (data,res,err) in
////            //print(data ?? <#default value#>)
////            if err == nil {
////                do{
////                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
////
////                    //print(result)
////                    DispatchQueue.main.async {
////                        completionHandler(result)
////                    }
////                }catch{
////                    completionHandler(false)
////                }
////            }else{
////                DispatchQueue.main.async {
////                    print("///khong lay duoc du lieu!")
////                    completionHandler(false)
////                }
////            }
////        }).resume()
////    }
////
////
////
////    //DICTIONARY: vua load vua post data, neu post image: su dung ["key": img, "sa": "sa"]
////
////    func postAndLoadDifferentData(urlString: String, param:Dictionary<String,Any> = [:], method: HTTPMethod = .GET,completionHandler:@escaping (Any?)->()){
////        var urlStringGet:String = urlString
////        //print(urlStringGet)
////        var index:Int = 0
////        switch method {
////        case .POST:
////            index = 1
////        default:
////            //if let param = param{
////            urlStringGet += "?\(param.convertDicToParamType())"
////            //}
////        }
////        //print("////////\(index)")
////        let url:URL = URL(string: urlStringGet)!
////        var request:URLRequest = URLRequest(url: url)
////        if index == 1{
////            let boundary = generateBoundaryString()
////            let body = NSMutableData()
////            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
////            for pr in param{
////                if let image:UIImage = pr.value as? UIImage
////                {
////                    //print("check image")
////                    let data = UIImageJPEGRepresentation(image, 0.5)
////                    let fname:String = "\(getTime()).jpeg"
////                    let mimetype = "image/png"
////                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("Content-Disposition:form-data; name=\"\(pr.key)\"; FileName=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
////                    body.append(data!)
////                    body.append("\r\n".data(using: String.Encoding.utf8)!)
////                }else{
////                    //----------upload them param
////                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("Content-Disposition: form-data; name=\"\(pr.key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
////                    body.append("\(pr.value)\r\n".data(using: String.Encoding.utf8)!)
////                }
////                //    body.append("&ten=datnguyen".data(using: String.Encoding.utf8)!)
////                request.httpMethod = "POST"
////                request.httpBody = body as Data
////            }
////        }
////        let session:URLSession = URLSession.shared
////        session.dataTask(with: request, completionHandler: {
////            (data,res,err) in
////            //print(data ?? <#default value#>)
////            if err == nil {
////                do{
////                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
////                    //print(result)
////                    DispatchQueue.main.async {
////                        completionHandler(result)
////                    }
////                }catch{
////                    completionHandler(false)
////                }
////            }else{
////                DispatchQueue.main.async {
////                    //print("///khong lay duoc du lieu!")
////                    completionHandler(false)
////                }
////            }
////        }).resume()
////    }
//
//
//    func generateBoundaryString() -> String
//    {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
//    func getTime() -> String{
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let second = calendar.component(.second, from: date)
//        let nano = calendar.component(.nanosecond, from: date)
//        return "\(hour)-\(minutes)-\(second)-\(nano)"
//    }
//    func getDate()->String{
//        let date = Date()
//        let calendar = Calendar.current
//        let day = calendar.component(.day, from: date)
//        let month = calendar.component(.month, from: date)
//        let year = calendar.component(.year, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        return "\(day)/\(month)/\(year) \(hour):\(minutes)"
//    }
//}
