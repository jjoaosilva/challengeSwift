import Foundation

enum ManageError: Error {
    case NotFoundAbout(text: String)
    case CharactersInvalids
    case NotFoundApiKey
}
