import Foundation

protocol SearchBarViewDelegate {
    func searchBarViewDidPressReturnKey()
    func searchBarViewDidTypeText(_ text: String)
}
