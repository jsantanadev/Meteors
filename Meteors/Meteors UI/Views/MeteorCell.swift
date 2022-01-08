import UIKit

class MeteorCell: UITableViewCell {
    
    // MARK: - Properties
    private(set) lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 6
        return stackView
    }()
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.current.titleColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private(set) lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.current.subtitleColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    private(set) lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrowRight")
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension MeteorCell {
    private func setupUI() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        addSubview(arrowImageView, constraints: [
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(containerView, constraints: [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        containerView.addArrangedSubview(nameLabel)
        containerView.addArrangedSubview(infoLabel)
    }
}
