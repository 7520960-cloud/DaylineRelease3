import SwiftUI

struct AuthView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Добро пожаловать в Dayline")
                    .font(.title)
                    .fontWeight(.bold)

                TextField("Логин", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Пароль", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    // Временная логика входа
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
                }
                .padding(.horizontal)

                NavigationLink(destination: MainView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

struct MainView: View {
    var body: some View {
        Text("Главный экран Dayline ✅")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding()
    }
}
