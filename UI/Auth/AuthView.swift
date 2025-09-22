
import SwiftUI
import FirebaseAuth
import AuthenticationServices

struct AuthView: View {
    @State private var email = ""
    @State private var pass = ""
    @State private var errorText: String? = nil
    @State private var isLoading = false
    @State private var apple = AppleSignInManager()

    var body: some View {
        VStack(spacing: 14) {
            Text("Dayline").font(.largeTitle).bold().padding(.bottom, 8)

            TextField("Email", text: $email).textFieldStyle(.roundedBorder).keyboardType(.emailAddress).textInputAutocapitalization(.never)
            SecureField("Password", text: $pass).textFieldStyle(.roundedBorder)

            if let e = errorText { Text(e).foregroundStyle(.red).font(.footnote) }

            Button { Task { await signIn() } } label: { if isLoading { ProgressView() } else { Text("Sign In") } }
                .buttonStyle(.borderedProminent).disabled(!isValid())

            Button("Create Account") { Task { await signUp() } }.buttonStyle(.bordered)

            SignInWithAppleButton(.signIn) { req in
                // configured in manager
            } onCompletion: { _ in
                Task {
                    do { try await apple.startSignInWithApple(); errorText = nil }
                    catch { errorText = error.localizedDescription }
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 44)
            .padding(.top, 8)

            Spacer()
        }.padding()
    }

    func isValid() -> Bool {
        let okEmail = email.contains("@")
        let okPass = pass.count >= AppConfig.minPasswordLength
        return okEmail && okPass
    }
    func signIn() async {
        isLoading = true
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: pass)
            await UserService.ensureUserDoc()
            errorText = nil
        } catch { errorText = error.localizedDescription }
        isLoading = false
    }
    func signUp() async {
        isLoading = true
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: pass)
            await UserService.ensureUserDoc()
            errorText = nil
        } catch { errorText = error.localizedDescription }
        isLoading = false
    }
}
