import Foundation


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

func convert_from_date(amount: Double, from: String, to: String, date: String) -> Double
{
    let semaphore = DispatchSemaphore (value: 0)
    var answer = 0.0000

    let url = "https://api.apilayer.com/fixer/\(date)?symbols=\(from)&base=\(to)"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    request.addValue("v3V01N9HHslbAmD5tMLIzaNlGGlwwmXO", forHTTPHeaderField: "apikey")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
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
                    print("Error parsing JSON or retrieving rate.")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        } else {
            print("Invalid JSON string.")
        }
        
      // convert
        
        
      semaphore.signal()
    }


    task.resume()
    semaphore.wait()
    return answer
    
}



