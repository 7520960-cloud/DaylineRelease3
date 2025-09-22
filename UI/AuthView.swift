import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Добро пожаловать в Dayline")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Пароль", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                Button(action: {
                    // пока делаем заглушку
                    if !email.isEmpty && !password.isEmpty {
                        isLoggedIn = true
                    }
                }) {
                    Text("Войти")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                NavigationLink(
                    destination: Text("Главный экран (заглушка)"),
                    isActive: $isLoggedIn
                ) { EmptyView() }
                
                Spacer()
            }
            .padding()
        }
    }
}
