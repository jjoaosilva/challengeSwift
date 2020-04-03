import Foundation

// Try get a NewYorkTime API's key, either schema project or documents directory
func getApiKey() -> String? {
    
    if let apiKey = ProcessInfo.processInfo.environment["API"] {
       return apiKey
    }
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let dir = paths.first!
    let fileURL = dir.appendingPathComponent("apiKey.json")
    let fileExist = FileManager.default.fileExists(atPath: fileURL.path)
    
    if fileExist {
        do {
            let jsondata = try Data(contentsOf: fileURL)
            let apiKey = try JSONDecoder().decode(ApiKey.self, from: jsondata)

            return apiKey.key
        } catch {
            return nil
        }
    }
    return nil
}

func callNewYorkTimesAPI(text: String, date: String, handle: @escaping (ResponseContent) throws -> Void ) throws {

    guard let apiKey = getApiKey() else {
        throw ManageError.NotFoundApiKey
    }

    let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(text)&api-key=\(apiKey)&fq=pub_date:\(date)")

    let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

        if let error = error {
            print("Error with fetching: \(error)")
            exit(0)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(response!)")
            exit(0)
        }

        do {
            
            guard let data = data else {
                print("Error with data")
                exit(0)
            }
            
            let dataJson = try JSONDecoder().decode(ResponseContent.self, from: data)
            
            do{
                try handle(dataJson)
            }catch{
                print(error)
                exit(0)
            }
            
        } catch {
            print("Error with decode json data")
            exit(0)
        }
    })

    task.resume()
    RunLoop.main.run(until: .distantFuture)
}
