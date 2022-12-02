//
//  TwilioController.swift
//  
//
//  Created by Myo Thura Zaw on 02/12/2022.
//

import Fluent
import Vapor
import Foundation

struct TwilioController: RouteCollection {
	func boot(routes: Vapor.RoutesBuilder) throws {
		let otp = routes.grouped("otp")
		otp.get(use: getOtp)
	}
	
	// SEND Twilio Verify Code
	// POST Request /otp route
	func getOtp(req: Request) async throws -> HTTPStatus {
		let serviceSid = "VA9fa71d8bbfdeb80051999148e7800473"
		let username = "AC1baccba68b1ae71f7e33f015a18137ec"
		let password = "f23808bff437e2685e2f6f4ec1f7e7e0"
		let phoneNumber = "+959448019652"
		let percentEncodedPhonNumber = phoneNumber.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
		
		let loginString = String(format: "%@:%@", username, password)
		let loginData = loginString.data(using: String.Encoding.utf8)!
		let base64LoginString = loginData.base64EncodedString()
		
		let urlString = "https://verify.twilio.com/v2/Services/" + serviceSid + "/Verifications"
		guard let url = URL(string: urlString) else {
			return .notFound
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		let parameters = "To=\(percentEncodedPhonNumber)&Channel=sms"
		let postData =  parameters.data(using: .utf8)
		request.httpBody = postData
		
		print("Going to send the request to the Twilio Server")
		print(parameters)
		
		let (_, response) = try await URLSession.shared.data(for: request)

		print(response)

		guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
			throw HttpError.badResponse
		}
		return .ok
	}
	
//https://verify.twilio.com/v2/Services/VA9fa71d8bbfdeb80051999148e7800473/Verifications
//	curl -X POST "https://verify.twilio.com/v2/Services/VAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Verifications" \
//	--data-urlencode "To=+15017122661" \
//	--data-urlencode "Channel=sms" \
//	-u $TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN
	
}
