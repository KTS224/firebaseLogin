//
//  ContentView.swift
//  SwiftUIFirebaseAuth
//
//  Created by 김태성 on 2022/07/31.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
//    @State var showing = false
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self]result, error in
            guard result != nil, error == nil else {
//                self?.showing = true
                return
            }
            
            DispatchQueue.main.async {
                // Success
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email,
                        password: password) { [weak self] result, error in
                guard result != nil, error == nil else {
//                    self?.showing = true
                    return
                }

            DispatchQueue.main.async {
                // Success
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                VStack {
                    Image(systemName: "person.fill.checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Text("로그인 되셨습니다.")
                    
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .foregroundColor(.blue)
                            .padding()
                    })
                    
                    Spacer()
                }
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

// MARK: - 로그인 창
struct SignInView: View {
    @State var email = ""
    @State var password = ""
    @State private var showing = false
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                SecureField("Password (6자 이상)", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        showing = true
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {
                    Text("로그인")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                })
                .alert("입력되지 않았거나 회원이 아닙니다.", isPresented: $showing) {
                    Button("OK", role: .cancel) {}
                }
                
                NavigationLink("회원가입", destination: SignUpView())
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("로그인")
    }
}

// MARK: - 회원가입 창
struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State private var showing = false
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                SecureField("Password (6자 이상)", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        showing = true
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("가입하기")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                })
                .alert("입력되지 않았거나 회원이 아닙니다.", isPresented: $showing) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("회원가입")
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
