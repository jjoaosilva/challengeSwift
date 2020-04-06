import Foundation

enum Messages : String {
    case welcome = "Welcome to BashNews!\n"
    case enterSearch = "Enter your search: "
}

struct ManageInterface{
    
    func welcome(){
        print(Messages.welcome.rawValue)
    }
    
    func formatResponse(date: String, abstract: String, snippet: String, webUrl: String){
        print("Today's news: \(date)\n")
        print("Article: \(abstract) \n")
        print("Stretch: \(snippet)  \n")
        print("Font:  \(webUrl)  \n")
    }
    
    func manageInputUser() -> (inputUser: String, inputFiltered: String)? {
        print(Messages.enterSearch.rawValue, terminator: "")
        let inputUser: String? = readLine()
        print("\n")

        guard let filteredText = removeCharactersInvalids(text: inputUser!),
            filteredText != "" else {
            return nil
        }
        
        return (inputUser!, filteredText)
    }
    
    // Removes all charecters invalids and swap the spaces for %20
    func removeCharactersInvalids(text: String) -> String? {
       let withoutCharactersInvalids = matches(for: "[0-9A-Za-z ]", in: text).joined(separator: "")
       
       return withoutCharactersInvalids.replacingOccurrences(of: " ", with: "%20")
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
}
