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



