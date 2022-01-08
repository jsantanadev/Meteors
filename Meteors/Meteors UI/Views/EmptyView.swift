import UIKit

class EmptyView: UIView {
    
    // MARK: - UI Properties
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 24
        return stackView
    }()
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = Theme.current.subtitleColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    // MARK: - Lifecycle
    init(image: UIImage, message: String) {
        super.init(frame: .zero)
        
        imageView.image = image
        label.text = message
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension EmptyView {
    private func setupUI() {
        isUserInteractionEnabled = false
        
        addSubview(containerView, constraints: [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        containerView.addArrangedSubview(imageView)
        containerView.addArrangedSubview(label)
    }
}
