import SnapKit
import UIKit

@objc(CRListViewController)
final class CRListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let mainTableView = UITableView()
    private let titleLabel = UILabel()
    private var dataArr: [CRBoxInputModel] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        generateDataArr()
        createUI()
    }

    private func generateDataArr() {
        let values: [(String, String, CRBoxInputModelType)] = [
            ("Normal", "demoImg_Normal", .normal),
            ("Placeholder", "demoImg_Placeholder", .placeholder),
            ("Custom Box", "demoImg_CustomBox", .customBox),
            ("Line", "demoImg_Line", .line),
            ("Secret Symbol", "demoImg_SecretSymbol", .secretSymbol),
            ("Secret Image", "demoImg_SecretImage", .secretImage),
            ("Secret View", "demoImg_SecretView", .secretView),
        ]
        dataArr = values.map { name, imageName, type in
            let model = CRBoxInputModel()
            model.name = name
            model.imageName = imageName
            model.type = type
            return model
        }
    }

    private func createUI() {
        titleLabel.text = "CRBoxInputView"
        titleLabel.textColor = colorMaster
        titleLabel.font = .systemFont(ofSize: 24)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(yy6(30) + statusHeight)
            make.left.equalToSuperview().offset(xx6(35))
        }

        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(yy6(22))
            make.left.right.bottom.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        yy6(157)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? CRListVCCell
            ?? CRListVCCell(style: .default, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        cell.loadData(with: dataArr[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = CRDetailViewController()
        destination.boxInputModel = dataArr[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }
}
