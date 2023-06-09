import Foundation
import UIKit


/**
 A function using currency converter API to convert between a currency to another.
 
 amount: amount to convert
 from: the currency from which to convert
 to: the currency to which to convert
 */
func convert(amount: Double, from: Currency, to: Currency)
{
    var semaphore = DispatchSemaphore (value: 0)
    
    let url = "https://api.apilayer.com/fixer/convert?to=\(to.stringValue)&from=\(from.stringValue)&amount=\(String(amount))"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    request.addValue("v3V01N9HHslbAmD5tMLIzaNlGGlwwmXO", forHTTPHeaderField: "apikey")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
        }
        print(String(data: data, encoding: .utf8)!)
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    return
}

/**
 The error enum that describes any error regarding doing API calls
 */
enum MyError: Error {
    case error(message: String)
}

/**
 The function for converting an amount from a currency to another using the conversion rate of a specific date
 Args:
    controller: the controller that calls this function. Useful for displaying error messages
    amount: the amount to convert
    from: currency to convert from
    to: currency to convert to
    date: the date of the the exchange rate to be used
 Return:
    The amount converted
    
 */
func convert_from_date(controller: CallsConvertCurrencyProtocol, amount: Double, from: String, to: String, date: String) -> Double?
{
    let semaphore = DispatchSemaphore (value: 0)
    var answer = 0.0000
    
    // verify date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // if date is not inputted to the right format, display error
    guard dateFormatter.date(from: date) != nil else {
        controller.displayError(error: MyError.error(message: "Date is inputted incorrectly"))
        return nil
    }
    
    // perform api requests to get the exchange rate
    let url = "https://api.apilayer.com/fixer/\(date)?symbols=\(from)&base=\(to)"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    request.addValue("v3V01N9HHslbAmD5tMLIzaNlGGlwwmXO", forHTTPHeaderField: "apikey")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
          if error != nil
          {
              // if error then, stop operation and display the error
              DispatchQueue.main.async {
                  controller.displayError(error: MyError.error(message: "Device or API Network Error! Please check your internet connection. Otherwise, try again later!"))
              }
              semaphore.signal()
              return
          }

        return
      }
        
    // perform mathematical conversion based on the exchange rate gathered
      let reponse = String(data: data, encoding: .utf8)!
        
        if let jsonData = reponse.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let rates = json["rates"] as? [String: Double],
                   let rate = rates[from] {
                    answer = amount * rate
                    print(jsonData)
                    print(rate)
                    print(answer)
                } else {
                    return
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        } else {
            print("Invalid JSON string.")
        }
        
        
        
      semaphore.signal()
    }

    // end task
    task.resume()
    semaphore.wait()
    

    // return
    return answer
    
}



