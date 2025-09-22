import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedLanguage: String = "Русский"
    @State private var isSecure: Bool = true
    
    let languages = ["Русский", "Українська", "English"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Заголовок
                Text("Dayline")
                    .font(.system(size: 34, weight: .bold))
                
                // Выбор языка
                Picker("Язык", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { lang in
                        Text(lang)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Поле e-mail
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Поле пароль
                Group {
                    if isSecure {
                        SecureField("Пароль", text: $password)
                    } else {
                        TextField("Пароль", text: $password)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                .overlay(
                    HStack {
                        Spacer()
                        Button(action: { isSecure.toggle() }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 30)
                    }
                )
                
                // Кнопка входа
                Button(action: {
                    // TODO: добавить логику авторизации
                }) {
                    Text("Войти")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Разделитель
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray)
                    Text("или")
                    Rectangle().frame(height: 1).foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Кнопки соцсетей
                HStack(spacing: 20) {
                    Button(action: { /* Google auth */ }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Google")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    Button(action: { /* Apple ID auth */ }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Apple")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AuthView()
}
