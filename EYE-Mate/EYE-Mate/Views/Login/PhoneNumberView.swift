//
//  PhoneNumberView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/30.
//


import SwiftUI
import Combine
import FirebaseAuth
import UIKit

struct PhoneNumberView: View {
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @State var presentSheet = false
    @State var countryFlag : String = "🇰🇷"
    @State var countryPattern : String = "## #### ####"
    @State var countryLimit : Int = 17
    @State var searchCountry: String  = ""
    @State var previousPhoneNumber: String = ""

    @Binding var openOTPView: Bool
    @Binding var signUpFlag: Bool
    @FocusState.Binding var keyFocused: Bool
    @Binding var countryCode : String
    @Binding var mobPhoneNumber: String
    
    var foregroundColor: Color = Color(.black)
    var backgroundColor: Color = Color(.systemGray6)
    let counrties: [CPData] = Bundle.main.decode("CountryNumbers.json")
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("전화번호")
                .font(.pretendardMedium_16)
            
            VStack(alignment: .trailing) {
                HStack {
                    Button {
                        presentSheet = true
                        keyFocused = false
                    } label: {
                        Text("\(countryFlag) \(countryCode)")
                            .font(.pretendardMedium_16)
                            .padding(10)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .foregroundColor(foregroundColor)
                    }
                    
                    TextField("", text: $mobPhoneNumber)
                        .font(.pretendardMedium_16)
                        .placeholder(when: mobPhoneNumber.isEmpty) {
                            Text("Phone number")
                                .foregroundColor(.warningGray)
                                .font(.pretendardSemiBold_16)
                        }
                        .focused($keyFocused)
                        .keyboardType(.numberPad)
                        .onReceive(Just(mobPhoneNumber)) { _ in
                            applyPatternOnNumbers(&mobPhoneNumber, pattern: countryPattern, replacementCharacter: "#")
                        }
                        .padding(10)
                        .frame(minWidth: 80, minHeight: 47)
                        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .onChange(of: mobPhoneNumber) { newValue in
                            // 이전 번호와 달라지는 경우
                            if previousPhoneNumber != newValue {
                                self.openOTPView = false
                            }
                        }
                    
                }
                .frame(width: 300)
                .padding(.bottom, 15)
                
                // MARK: - 인증요청 버튼
                HStack {
                    Button {
                        if mobPhoneNumber.count >= countryPattern.count{
                            self.previousPhoneNumber = mobPhoneNumber
                            self.openOTPView = true
                        }
                        
                        loginViewModel.sendVerificationCode(phoneNumber: "\(countryCode)\(mobPhoneNumber)")
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .foregroundStyle(Color.customGreen)
                                .frame(width: 120, height: 30)
                            Text(openOTPView ? "인증번호 재요청" : "인증번호 요청")
                                .foregroundStyle(.white)
                                .font(.pretendardSemiBold_14)
                        }
                        .disableWithOpacity(mobPhoneNumber.count < countryPattern.count )
                    }
                    .disabled(mobPhoneNumber.count < countryPattern.count)
                }
            }
            .animation(.easeInOut(duration: 0.6), value: keyFocused)
        }
        .sheet(isPresented: $presentSheet) {
            NavigationView {
                VStack{
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
                    .searchable(text: $searchCountry, placement: .navigationBarDrawer(displayMode: .always))
                }
            }
            .presentationDetents([.medium, .large])
        }
        .presentationDetents([.medium, .large])
        
    }
    
    var filteredResorts: [CPData] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            let lowercaseSearchText = searchCountry.lowercased()
            return counrties.filter { $0.name.lowercased().contains(lowercaseSearchText) }
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
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}

//#Preview {
//    PhoneNumberView(signUpFlag: .constant(true), keyFocused: .constant(true))
//}
