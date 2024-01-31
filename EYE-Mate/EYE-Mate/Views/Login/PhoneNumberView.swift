//
//  PhoneNumberView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/30.
//


import SwiftUI
import Combine
import FirebaseAuth

struct PhoneNumberView: View {
    @State var presentSheet = false
    @State var countryCode : String = "+1"
    @State var countryFlag : String = "🇺🇸"
    @State var countryPattern : String = "### ### ####"
    @State var countryLimit : Int = 17
    @State var mobPhoneNumber = ""
    @State private var searchCountry: String  = ""
    @State var verificationID: String = ""
    @State var openOTPView: Bool = false
    @State var phoneNumberFlag: Bool = false
    
    @FocusState private var keyIsFocused: Bool
    
    var foregroundColor: Color = Color(.black)
    var backgroundColor: Color = Color(.systemGray6)
    let counrties: [CPData] = Bundle.main.decode("CountryNumbers.json")
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("전화번호")
                    .font(.pretendardMedium_16)
                
                VStack {
                    HStack {
                        Button {
                            presentSheet = true
                            keyIsFocused = false
                        } label: {
                            Text("\(countryFlag) \(countryCode)")
                                .padding(10)
                                .frame(minWidth: 80, minHeight: 47)
                                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .foregroundColor(foregroundColor)
                        }
                        
                        TextField("", text: $mobPhoneNumber)
                            .placeholder(when: mobPhoneNumber.isEmpty) {
                                Text("Phone number")
                                    .foregroundColor(.warningGray)
                                    .font(.pretendardSemiBold_16)
                            }
                            .focused($keyIsFocused)
                            .keyboardType(.numberPad)
                            .onReceive(Just(mobPhoneNumber)) { _ in
                                applyPatternOnNumbers(&mobPhoneNumber, pattern: countryPattern, replacementCharacter: "#")
                            }
                            .padding(10)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(width: 300)
                    .padding(.bottom, 15)
                    
                    Button {
                        if mobPhoneNumber.count >= countryPattern.count{
                            self.phoneNumberFlag = true
                            self.openOTPView = true
                        }
                        
                        sendVerificationCode()
                    } label: {
                        Text(openOTPView ? "인증번호 재요청" : "인증번호 요청")
                            .foregroundStyle(.white)
                            .font(.pretendardSemiBold_14)
                            .background(RoundedRectangle(cornerRadius: 20.0)
                                .foregroundStyle(Color.customGreen)
                                .frame(width: 120, height: 30))
                    }
                    .padding(.bottom, 10)
                    .disableWithOpacity(mobPhoneNumber.count != countryPattern.count )
                    
                    // MARK: - OTP View
                    if openOTPView {
                        OTPVerificationView(verificationID: $verificationID, mobileNumber: "\(countryCode)\(mobPhoneNumber)")
                    }
                    
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
            }
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $presentSheet) {
            NavigationView {
                List(filteredResorts) { country in
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                            .font(.headline)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        self.countryFlag = country.flag
                        self.countryCode = country.dial_code
                        self.countryPattern = country.pattern
                        self.countryLimit = country.limit
                        presentSheet = false
                        searchCountry = ""
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchCountry, prompt: "Your country")
            }
            .presentationDetents([.medium, .large])
        }
        .presentationDetents([.medium, .large])
        .ignoresSafeArea(.keyboard)
    }
    
    var filteredResorts: [CPData] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.contains(searchCountry) }
        }
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
    }
    
    func sendVerificationCode() {
        let phoneNumber = "\(countryCode)\(mobPhoneNumber)"
        print(phoneNumber)
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let verificationID = verificationID {
                    print("verificationID:", verificationID)
                    self.verificationID =  verificationID
                }
            }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}

