import SnapKit
import UIKit

final class CRListVCCell: UITableViewCell {
    private let containerView = UIView()
    private let previewImageView = UIImageView()
    private let lineView = UIView()
    private let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }

    private func createUI() {
        let endOffset: CGFloat = 36
        let lineWidth: CGFloat = 202
        let lineHeight: CGFloat = 2

        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(132)
            make.centerY.equalToSuperview()
        }

        previewImageView.contentMode = .scaleAspectFit
        containerView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(42)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(310)
            make.height.equalTo(90)
        }

        lineView.backgroundColor = colorMaster
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.width.equalTo(lineWidth)
            make.height.equalTo(lineHeight)
            make.right.equalToSuperview().offset(-endOffset)
            make.bottom.equalToSuperview().offset(-35)
        }

        let lineFrame = CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight)
        let maskPath = UIBezierPath(
            roundedRect: lineFrame,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: lineHeight / 2, height: lineHeight / 2)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = lineFrame
        maskLayer.path = maskPath.cgPath
        lineView.layer.mask = maskLayer

        nameLabel.textColor = colorMaster
        nameLabel.font = .systemFont(ofSize: 14)
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-endOffset)
            make.bottom.equalToSuperview().offset(-9)
        }
    }

    func loadData(with model: CRBoxInputModel) {
        nameLabel.text = model.name
        previewImageView.image = UIImage(named: model.imageName)
    }
}
