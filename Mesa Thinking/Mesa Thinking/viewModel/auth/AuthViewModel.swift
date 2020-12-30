//
//  AuthViewModel.swift
//  Mesa Thinking
//
//  Created by Lucas De Assis on 28/12/20.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class AuthViewModel
{
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let logged = Variable<Bool>(false)
    let dataApp = UserDefaults.standard
    
    public func makeLogin(_ email: String, andPassword password: String)
    {
        self.loading.onNext(true)
        let urlApi = "\(APIManager.baseUrl)v1/client/auth/signin"
        let parameters: Parameters = [
               "email": "\(email)",
               "password": "\(password)"
               ]
        AF.request(urlApi, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON
        {
            response in
            switch response.result
            {
                case .success(let jsonResponse):
                    self.loading.onNext(false)
                    if(response.response?.statusCode == 200)
                    {
                        MessageView.sharedInstance.showOnView(message: "Olá!", theme: .success)
                        //deactivate loading message
                        let pagination = try! Token(data: JSON((jsonResponse as! NSDictionary)).rawData())
                        //we will save this token
                        self.dataApp.setValue(pagination!.token, forKey: "token")
                        self.dataApp.setValue(email, forKey: "email")
                        self.logged.value = true
                    }
                    else
                    {
                        MessageView.sharedInstance.showOnView(message: "E-mail ou senha inválidos", theme: .error)
                    }
                    
                case .failure(let error):
                    
                    self.loading.onNext(false)
                    //it's a very good idea show a message for user
                    MessageView.sharedInstance.showOnView(message: error.localizedDescription, theme: .error)
                                        
            }
            
        }
    }
    
    public func signUp(email : String, name: String, andPassword password :String,
                       dateOfBirth : String?)
    {
        self.loading.onNext(true)
        let urlApi = "\(APIManager.baseUrl)v1/client/auth/signup"
        let parameters: Parameters = [
               "email": "\(email)",
               "password": "\(password)",
               "name" : "\(name)"
               ]
            //PS: in documentation we haven't examples how we pass some fields to API!
            AF.request(urlApi, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON
            {
                response in
                switch response.result
                {
                    case .success(let jsonResponse):
                        //deactivate loading
                        self.loading.onNext(false)
                        if(response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            MessageView.sharedInstance.showOnView(message: "Tudo certo!", theme: .error)
                            let pagination = try! Token(data: JSON((jsonResponse as! NSDictionary)).rawData())
                            //we will save this token
                            self.dataApp.setValue(pagination!.token, forKey: "token")
                            self.dataApp.setValue(email, forKey: "email")
                            self.logged.value = true
                        }
                        else
                        {
                            //it's a very good idea show a message for user, but we dont know which type we receive
                            MessageView.sharedInstance.showOnView(message: "Cheque os seus dados", theme: .error)
                        }
                    case .failure(let error):
                        self.loading.onNext(false)
                        //it's a very good idea show a message for user
                        MessageView.sharedInstance.showOnView(message: error.localizedDescription, theme: .error)
                        print(error.localizedDescription)
                }
                
            }
        
    }
    
    public func signInWithFacebook(viewController : UIViewController)
    {
        LoginManager().logIn(permissions: ["email", "public_profile"], from: viewController)
        {
            (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err)
                return
            }
            self.getDataFromFacebook()
        }
    }
    
    func getDataFromFacebook()
    {
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil
            {
                MessageView.sharedInstance.showOnView(message: err!.localizedDescription, theme: .error)
                return
            }
            else
            {
                guard let dataInfo = result as? [String: Any] else { return }
                if let email = dataInfo["email"] as? String
                  {
                     print(email)
                    //what we gonna do after this?
                    //we haven't api route for sign in with facebook!
                    MessageView.sharedInstance.showOnView(message: "Qual a rota para o login com o facebook? \(email)", theme: .error)
                  }
            }
        }
    }
    
    public func validateFields(_ email : String, name: String, andPassword password :String, password2 : String,
                               dateOfBirth : String?) -> Bool
    {
        //... validate our fields
        return true
    }
    
    
}
