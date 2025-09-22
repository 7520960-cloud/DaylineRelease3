import SwiftUI

struct AuthView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            Text("Добро пожаловать, \(username)!")
                .font(.title)
                .padding()
        } else {
            VStack(spacing: 20) {
                Text("Вход в приложение")
                    .font(.largeTitle)
                    .bold()

                TextField("Логин", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Пароль", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    // Простая проверка (заглушка)
                    if !username.isEmpty && !password.isEmpty {
                        isLoggedIn = true
                    }
                }) {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
}
