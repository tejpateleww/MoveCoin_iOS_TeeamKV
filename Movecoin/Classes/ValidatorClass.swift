//
//  ValidatorClass.swift
//  Movecoins
//
//  Created by eww090 on 11/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


protocol ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String
}

enum ValidatorType {
    case email
    case password
    case username
    case mobileNumber
    case fullname
    case requiredField(field: String)
    case age
    
    case cardHolder
    case cardNumber
    case expDate
    case cvv
}


class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

class ValidatorClass {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .username: return UserNameValidator()
        case .mobileNumber: return MobileNumberValidator()
        case .fullname: return FullNameValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
        case .cardHolder: return CardHolderValidator()
        case .cardNumber: return CardNumberValidator()
        case .expDate: return ExpDateValidator()
        case .cvv: return CvvValidator()
        }
    }
}

struct EmailValidator: ValidatorConvertible {
    
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard value != "" else {
            
            if txtFieldName.contains("enter"){
                throw ValidationError("Please".localized + " \(txtFieldName)")
            }else{
                throw ValidationError("Please enter".localized + " \(txtFieldName)")
            }
        }
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                //throw ValidationError("Invalid".localized + " \(txtFieldName)")
                if txtFieldName.contains("enter"){
                    throw ValidationError("Please enter a valid email id".localized)
                }else {
                    throw ValidationError("Invalid".localized + " \(txtFieldName)")
                }
            }
        } catch {
//            throw ValidationError("Invalid".localized + " \(txtFieldName)")
            if txtFieldName.contains("enter"){
                throw ValidationError("Please enter a valid email id".localized)
            } else {
                 throw ValidationError("Invalid".localized + " \(txtFieldName)")
            }
        }
        return value
    }
}


struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard value != "" else {throw ValidationError("Please enter".localized + " \(txtFieldName)")}
        guard value.count >= 6 else { throw ValidationError("Password must have at least 6 characters".localized) }
        
//        do {
//            if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
//                throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
//            }
//        } catch {
//            throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
//        }
        return value
    }
}

struct FullNameValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
    
        guard value != "" else {throw ValidationError("Please enter".localized + " \(txtFieldName)")}

//        guard value.count < 50 else {
//            throw ValidationError("Full name shoudn't contain more than 50 characters" )
//        }

//        do {
//            if try NSRegularExpression(pattern: "^[a-z ]+$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
//                throw ValidationError("Full name should not contain numbers or special characters".localized)
//            }
//        } catch {
//            throw ValidationError("Full name should not contain numbers or special characters".localized)
//        }
        return value
    }
}


struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        
        guard value != "" else {throw ValidationError("Please enter".localized + " \(txtFieldName)")}
        
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters".localized )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't contain more than 18 characters".localized )
        }
        
        
//        do {
//            if try NSRegularExpression(pattern: "^[a-z]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
//                throw ValidationError("Username should not contain whitespaces, numbers or special characters".localized)
//            }
//        } catch {
//            throw ValidationError("Username should not contain whitespaces, numbers or special characters".localized)
//        }
        return value
    }
}

struct MobileNumberValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        
        guard value != "" else {throw ValidationError("Please enter".localized + " \(txtFieldName)")}
        guard value.count >= 10 && value.count < 11 else {
            
            if(Localize.currentLanguage() == Languages.Arabic.rawValue){
                throw ValidationError("الرجاء إدخال رقم جوال صحيح")
            } else {
                throw ValidationError("Please enter valid ".localized + txtFieldName)
            }
        }
        do {
            let numberOnly = NSCharacterSet.init(charactersIn: "+#*0123456789")
            let stringFromTextField = NSCharacterSet.init(charactersIn: value)
            let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
            if(!strValid)
            {
                throw ValidationError("Only english digits are allowed".localized)
            }
        } catch {
            throw ValidationError("Only english digits are allowed".localized)
        }
        return value
    }
}


struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            if txtFieldName.contains("enter"){
                throw ValidationError("Please".localized + " \(txtFieldName)")
            }else{
                if txtFieldName == "أسم النشاط التجاري " { // business name
                    throw ValidationError("الرجاء إدخال الإسم التجاري") // "Please enter the trade name"
                } else if txtFieldName == "اسم المتجر" { // Shope name
                    throw ValidationError("الرجاء إدخال إسم المتجر") // "Please enter the store name"
                } else {
                    throw ValidationError("Please enter".localized + " \(txtFieldName)")
                }
            }
        }
        return value
    }
}

class AgeValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Age is required".localized)}
        guard let age = Int(value) else {throw ValidationError("Age must be a number!".localized)}
        guard value.count < 3 else {throw ValidationError("Invalid age number!".localized)}
        guard age >= 18 else {throw ValidationError("You have to be over 18 years old to user our app".localized)}
        return value
    }
}

struct CardHolderValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {

        guard value != "" else {throw ValidationError("Please enter card holder name".localized)}

        //        guard value.count < 50 else {
        //            throw ValidationError("Full name shoudn't contain more than 50 characters" )
        //        }

//        do {
//            if try NSRegularExpression(pattern: "^[a-z ]+$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
//                throw ValidationError("Card holder should not contain numbers or special characters".localized)
//            }
//        } catch {
//            throw ValidationError("Card holder should not contain numbers or special characters".localized)
//        }
        return value
    }
}

struct CardNumberValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard value != "" else {throw ValidationError("Please enter".localized + " \(txtFieldName)")}
        guard value.count >= 17 else { throw ValidationError("Card number must have at least 14 characters".localized) }
        let v = CreditCardValidator()
        guard v.validate(string: value) else { throw ValidationError("Card number is invalid".localized) }

        return value
    }
}

struct CvvValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard value != "" else {throw ValidationError("Please enter".localized + " \(txtFieldName)")}
        guard value.count >= 3 && value.count < 5 else { throw ValidationError("Please enter valid CVV number".localized) }
        return value
    }
}

struct ExpDateValidator: ValidatorConvertible {
    func validated(_ value: String, _ txtFieldName: String) throws -> String {
        guard value != "" else {throw ValidationError("Please enter expiry date".localized)}
        guard expDateValidation(dateStr: value) else { throw ValidationError("Invalid expiry date".localized) }
        return value
    }
    
    func expDateValidation(dateStr:String) -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enterdYr = Int(dateStr.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user

        if enterdYr > currentYear{
            if (1 ... 12).contains(enterdMonth){
                return true
            } else{
                return false
            }
        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth{
                if (1 ... 12).contains(enterdMonth) {
                    return true
                } else{
                    return false
                }
            } else {
                return false
            }
        } else {
            return true
        }
    }
}
