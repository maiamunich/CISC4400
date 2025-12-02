import SwiftUI

struct ContentView: View {
  @State private var companyName = ""
  @State private var address = ""
  @State private var city = ""
  @State private var state = ""
  @State private var zipCode = ""
  @State private var phone = ""
  @State private var email = ""
  @State private var mPhone = ""
  @State private var mCarrier = ""
  @State private var username = ""
  @State private var password1 = ""
  @State private var password2 = ""

  @State private var resultMessage = ""
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        Text("New Customer Registration Form")
          .font(.title2).bold()
          .padding(.vertical, 8)

        Group {
          TextField("Enter Company Name", text: $companyName)
            .textFieldStyle(.roundedBorder)
          TextField("Enter Address", text: $address)
            .textFieldStyle(.roundedBorder)
          TextField("Enter City", text: $city)
            .textFieldStyle(.roundedBorder)
          TextField("Enter State (2 letters)", text: $state)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.characters)
          TextField("Enter Zip Code (5 digits)", text: $zipCode)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
          TextField("Enter Phone (10 digits)", text: $phone)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
          TextField("Enter Email", text: $email)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
        }

        Group {
          TextField("Enter Mobile Phone (10 digits)", text: $mPhone)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
          TextField("Enter Mobile Carrier", text: $mCarrier)
            .textFieldStyle(.roundedBorder)
          TextField("Enter Username", text: $username)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
          SecureField("Enter Password", text: $password1)
            .textFieldStyle(.roundedBorder)
          SecureField("Re-Enter Password", text: $password2)
            .textFieldStyle(.roundedBorder)
        }

        Button {
          Task { await sendNewCustomerData() }
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "star.fill")
            Text("SUBMIT BUTTON")
              .bold()
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.yellow)
          .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 5))
          .cornerRadius(8)
        }
        .padding(.top, 8)

        VStack(alignment: .leading, spacing: 6) {
          Text("Status:")
            .font(.headline)
          Text(resultMessage.isEmpty ? "—" : resultMessage)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .padding(8)
            .background(Color.cyan.opacity(0.25))
            .cornerRadius(8)
        }
        .padding(.top, 4)

        Spacer(minLength: 12)
      }
      .padding()
    }
    .alert(alertTitle, isPresented: $showAlert) {
      Button("OK", role: .cancel) { }
    } message: {
      Text(alertMessage)
    }
  }

  // MARK: - Validation + Networking

  private func fail(_ title: String, _ message: String) {
    alertTitle = title
    alertMessage = message
    showAlert = true
  }

  private func validate() -> Bool {
    // Trim
    companyName = companyName.trimmingCharacters(in: .whitespacesAndNewlines)
    address     = address.trimmingCharacters(in: .whitespacesAndNewlines)
    city        = city.trimmingCharacters(in: .whitespacesAndNewlines)
    state       = state.trimmingCharacters(in: .whitespacesAndNewlines)
    zipCode     = zipCode.trimmingCharacters(in: .whitespacesAndNewlines)
    phone       = phone.trimmingCharacters(in: .whitespacesAndNewlines)
    email       = email.trimmingCharacters(in: .whitespacesAndNewlines)
    mPhone      = mPhone.trimmingCharacters(in: .whitespacesAndNewlines)
    mCarrier    = mCarrier.trimmingCharacters(in: .whitespacesAndNewlines)
    username    = username.trimmingCharacters(in: .whitespacesAndNewlines)
    password1   = password1.trimmingCharacters(in: .whitespacesAndNewlines)
    password2   = password2.trimmingCharacters(in: .whitespacesAndNewlines)

    if companyName.count < 5   { fail("Data Error!", "Company name is invalid!"); return false }
    if address.count < 5       { fail("Data Error!", "Address is invalid!"); return false }
    if city.count < 2          { fail("Data Error!", "City is invalid!"); return false }
    if state.count != 2        { fail("Data Error!", "State abbreviation is invalid!"); return false }
    if zipCode.count != 5      { fail("Data Error!", "Zip code needs to be 5 digits!"); return false }
    if phone.count != 10       { fail("Data Error!", "Phone number needs to be 10 digits!"); return false }
    if email.count < 5         { fail("Data Error!", "Email address is invalid!"); return false }
    if mPhone.count != 10      { fail("Data Error!", "Mobile Phone number needs to be 10 digits!"); return false }
    if mCarrier.isEmpty        { fail("Data Error!", "Mobile Carrier name is invalid!"); return false }
    if username.isEmpty        { fail("Data Error!", "User name is invalid!"); return false }
    if password1.isEmpty       { fail("Data Error!", "Password is invalid!"); return false }
    if password1 != password2  { fail("Data Error!", "Passwords do not match!"); return false }

    return true
  }

  private func sendNewCustomerData() async {
    guard validate() else { return }

    // Build URL with proper percent-encoding
    let base = "https://storm.cis.fordham.edu/~kounavelis/cgi-bin/insertCustomers.cgi"
    var components = URLComponents(string: base)!
    components.queryItems = [
      URLQueryItem(name: "name",     value: companyName),
      URLQueryItem(name: "address",  value: address),
      URLQueryItem(name: "city",     value: city),
      URLQueryItem(name: "state",    value: state),
      URLQueryItem(name: "zip",      value: zipCode),
      URLQueryItem(name: "phone",    value: phone),
      URLQueryItem(name: "email",    value: email),
      URLQueryItem(name: "mphone",   value: mPhone),
      URLQueryItem(name: "mcarrier", value: mCarrier),
      URLQueryItem(name: "username", value: username),
      URLQueryItem(name: "password", value: password1)
    ]

    guard let requestURL = components.url else {
      resultMessage = "Failed to build request URL."
      return
    }

    // POST with empty body (matches the instructor’s expectation)
    var request = URLRequest(url: requestURL)
    request.httpMethod = "POST"
    request.httpBody = Data()

    await MainActor.run { resultMessage = "Processing, one moment..." }

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        DispatchQueue.main.async {
          self.resultMessage = "Error: \(error.localizedDescription)"
        }
        return
      }

      if let data = data, let text = String(data: data, encoding: .utf8) {
        DispatchQueue.main.async {
          self.resultMessage = "Resp: \(text)"
        }
      } else {
        DispatchQueue.main.async {
          self.resultMessage = "No response body."
        }
      }
    }.resume()
  }
}

#Preview {
  ContentView()
}

