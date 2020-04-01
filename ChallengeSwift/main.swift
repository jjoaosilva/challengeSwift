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

// Creates a date with format sended
func createDate(format: String) -> String {
    let formatter = DateFormatter()

    formatter.dateFormat = format
    return formatter.string(from: Date())
}

// Returns only matched text based on the regex
func matches(for regex: String, in text: String) -> [String] {

    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

// Removes all charecters invalids and swap the spaces for %20
func removeCharactersInvalids(text: String) -> String {
    let withoutCharactersInvalids = matches(for: "[0-9A-Za-z ]", in: text).joined(separator: "")
    
    return withoutCharactersInvalids.replacingOccurrences(of: " ", with: "%20")
}

func callNewYorkTimesAPI(text: String, date: String, handle: @escaping (ResponseContent) -> Void ) {

    guard let apiKey = getApiKey() else {
        print("Not Found api key")
        exit(0)
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
            handle(dataJson)

        } catch {
            print("Error with decode json data")
            exit(0)
        }
    })

    task.resume()
    RunLoop.main.run(until: .distantFuture)
}

func startAplication(){
    print("Welcome to BashNews!\n")
    print("Enter your search: ", terminator: "")
    let userInput: String? = readLine()
    print("\n")

    let filteredText: String! = removeCharactersInvalids(text: userInput!)

    if filteredText == "" {
        print("Not found about: \(userInput!)\n")
        exit(0)
    }

    let date = createDate(format: "yyyy-MM-dd")

    callNewYorkTimesAPI(text: filteredText, date: date) { articles in

        if articles.response?.docs?.count != 0 {
            if let abstract = articles.response?.docs?[0].abstract,
               let snippet  = articles.response?.docs?[0].snippet,
               let webUrl   = articles.response?.docs?[0].web_url, abstract != "", snippet != "" {

                    print("Today's news: \(date)\n")
                    print("Article: \(abstract) \n")
                    print("Stretch: \(snippet)  \n")
                    print("Font:  \(webUrl)  \n")
            }
        } else { print("Not found about: \(userInput!)\n") }
        exit(0)
    }
}

startAplication ()

