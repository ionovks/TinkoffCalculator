//  Created by ionovks on 06.07.24.


import UIKit

class CalculationsListViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    var calculations: [Calculation] = []


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        modalPresentationStyle = .fullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")


    }

    private func expressionToString(_ expression: [CalculationHistoryItem]) -> String {
        var result = ""

        for operand in expression {
            switch operand {
            case let .number(value):
                result += String(value) + " "
            case let .operation(value):
                result += value.rawValue + " "
            }
        }
        return result
    }

    private func currentDateToString(_ date: Date ) -> String? {
//        let date = Date()
//        let onehourInSeconds: TimeInterval = 360
//        let nextDay = date + (onehourInSeconds * 24)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formatedDate = dateFormatter.string(for: date)

        return formatedDate
    }
}


extension CalculationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = UIView(frame: CGRect(x: 10, y: -10, width: view.frame.size.width, height: 50))
        header.backgroundColor = .lightGray
        let textLabel = UILabel(frame: header.frame)
        textLabel.textAlignment = .left
        let date = calculations[section].date
        textLabel.text = currentDateToString(date)

        header.addSubview(textLabel)

        return header

    }

    private func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}


extension CalculationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return calculations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let historyItem = calculations[indexPath.section]
        cell.configure(with: expressionToString(historyItem.expression), result: String(historyItem.result))

        return cell
    }
}
