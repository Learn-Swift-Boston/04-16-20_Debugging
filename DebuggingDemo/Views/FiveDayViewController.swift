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

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
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
    
}

extension FiveDayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWeathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
