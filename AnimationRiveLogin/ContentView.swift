//
//  ContentView.swift
//  AnimationRiveLogin
//
//  Created by Muhammed Elşami on 17.08.2024.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    
    @StateObject var riveViewModel = RiveViewModel(fileName: "teddy_login_screen", fit: .contain)
    @State var userName: String = ""
    @State var password: String = ""
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var toastType: ToastType = .success
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            riveViewModel.view()
                .padding(0)
                .aspectRatio(contentMode: .fit)
            
            
            VStack {
                
                ReusableText(text: "Hi There!",
                             font: .system(size: 16, weight: .semibold, design: .default))
                
                ReusableText(text: "Let's Get Started",
                             font: .system(size: 24, weight: .bold, design: .default))
                
                UserNameView(rive: riveViewModel, userName: $userName)
                
                PasswordView(rive: riveViewModel, password: $password)
                
                LoginButtonView(rive: riveViewModel) {
                    if userName == "admin" && password == "admin" {
                        riveViewModel.triggerInput("success")
                        showToast(message: "Login Successful!", type: .success)
                    }
                    else {
                        riveViewModel.triggerInput("fail")
                        showToast(message: "Login Failed!", type: .error)
                    }
                    
                }
                
            }
            .padding(20)
            .cornerRadius(10)
            .background(Color.black.opacity(0.2))
            .cornerRadius(20)
            Spacer()
        }
        .padding()
        .background(LinearGradient(colors: [Color("9D92DF"), Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear {
            riveViewModel.stop()
        }
        .overlay(
            Group {
                if showToast {
                    VStack {
                        Spacer()
                        ToastView(message: toastMessage, type: toastType)
                            .padding(.bottom, 20)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut, value: showToast)
                    }
                }
            }
        )
    }
    
    private func showToast(message: String, type: ToastType) {
        toastMessage = message
        toastType = type
        showToast = true
        
        // Hide the toast after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
}

struct ReusableText: View {
    var text: String
    var font: Font
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(.white)
            .padding(.zero)
    }
}

struct UserNameView: View {
    @State var rive: RiveViewModel
    @Binding var userName: String
    var body: some View {
        TextField("Username", text: $userName, onEditingChanged: { status in
            if status {
                rive.setInput("Check", value: true)
            }
            else {
                rive.setInput("Check", value: false)
            }
        })
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(30.0)
        .padding(.bottom ,5)
        .onChange(of: userName) { newValue in
            print("onChange called \(newValue)")
            rive.setInput("Look", value: Double(newValue.count) * 3)
        }
    }
}

struct PasswordView: View {
    @State var rive: RiveViewModel
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isPasswordFieldFocused: Bool
    var body: some View {
        
        HStack {
            if isPasswordVisible {
                TextField("Password", text: $password, onEditingChanged: { status in
                    if status {
                        print("==")
                    }
                    else {
                        rive.setInput("hands_up", value: false)
                    }
                })
                .padding()
            } else {
                SecureField("Password", text: $password)
                    .focused($isPasswordFieldFocused)
                    .padding()
                    .onChange(of: isPasswordFieldFocused) { isFocused in
                        if isFocused {
                            print("Password field focused")
                        } else {
                            rive.setInput("hands_up", value: false)
                        }
                    }
                    .onChange(of: password) { newValue in
                        rive.setInput("hands_up", value: true)
                    }
            }
            
            Button(action: {
                isPasswordVisible.toggle()
                if isPasswordVisible {
                    rive.setInput("hands_up", value: false)
                }
                else {
                    rive.setInput("hands_up", value: true)
                }
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
        }
        .background(Color.white.opacity(0.8))
        .cornerRadius(30.0)
    }
}

struct LoginButtonView: View {
    var rive: RiveViewModel
    let verifyLogin: () -> Void
    
    var body : some View {
        Button{
            verifyLogin()
        } label: {
            Text("Login")
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(colors: [Color("A02D62"), Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(30.0)
                .padding(.top, 20)
        }
        .shadow(color: Color.black.opacity(0.7), radius: 2, x: 2, y: 2)
    }
}


#Preview {
    ContentView()
}
