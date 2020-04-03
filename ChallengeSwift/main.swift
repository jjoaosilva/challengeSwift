import Foundation

// Creates a date with format sended
func createDate(format: String) -> String {
    let formatter = DateFormatter()

    formatter.dateFormat = format
    return formatter.string(from: Date())
}


func startAplication() throws {
    let interface: ManageInterface = ManageInterface()
    var inputUser: (inputUser: String, inputFiltered: String)?
    
    interface.welcome()
    inputUser = interface.manageInputUser()
    
    guard let input = inputUser else {
        throw ManageError.CharactersInvalids
    }
    
    let date = createDate(format: "yyyy-MM-dd")
    
    try callNewYorkTimesAPI(text: input.inputFiltered, date: date) { (articles) throws -> Void in

        if articles.response?.docs?.count != 0 {
            if let abstract = articles.response?.docs?[0].abstract,
               let snippet  = articles.response?.docs?[0].snippet,
               let webUrl   = articles.response?.docs?[0].web_url, abstract != "", snippet != "" {

                interface.formatResponse(date: date, abstract: abstract, snippet: snippet, webUrl: webUrl)
            } 
        } else { throw ManageError.NotFoundAbout(text: input.inputUser) }
        exit(0)
    }
}

do{
    try startAplication()
}
catch{
    print(error)
    exit(0)
}
