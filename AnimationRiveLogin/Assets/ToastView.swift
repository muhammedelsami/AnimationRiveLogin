//
//  ToastView.swift
//  AnimationRiveLogin
//
//  Created by Muhammed Elşami on 17.08.2024.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        Text(message)
            .padding()
            .background(type.backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}

enum ToastType {
    case success
    case error
    
    var backgroundColor: Color {
        switch self {
        case .success: return Color.green
        case .error: return Color.red
        }
    }
}

#Preview {
    ToastView(message: "Test Success", type: .success)
}
