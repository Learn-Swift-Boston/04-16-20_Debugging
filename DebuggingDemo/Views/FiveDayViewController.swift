import UIKit

class FiveDayViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dayWeathers = [DayWeather]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

}

extension FiveDayViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, let zipcode = Int(text) else { return }
        NetworkingController().getFiveDay(for: zipcode) { (result) in
            switch result {
            case .success(let dayWeathers):
                self.dayWeathers = dayWeathers
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FiveDayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < dayWeathers.count else { return }
        guard let conditionViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Current Weather") as? CurrentViewController else { return }
        
        conditionViewController.shouldFetchLocation = false
        conditionViewController.currentWeather = dayWeathers[indexPath.row].condition
        
        navigationController?.pushViewController(conditionViewController, animated: true)
    }
}

extension FiveDayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWeathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        guard indexPath.row < dayWeathers.count else {
            return cell
        }
        
        cell.textLabel?.text = dayWeathers[indexPath.row].date
        cell.detailTextLabel?.text = dayWeathers[indexPath.row].condition.condition
        
        return cell
    }
}
