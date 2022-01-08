import UIKit
import MapKit

public final class MeteorAnnotationView: MKMarkerAnnotationView {
    public func setup(viewModel: MeteorDetailViewModel) {
        canShowCallout = true
        
        let verticalContainerView = UIStackView()
        verticalContainerView.axis = .vertical
        verticalContainerView.spacing = 8
        
        let horizontalView = UIStackView()
        horizontalView.axis = .horizontal
        horizontalView.distribution = .fillProportionally
        horizontalView.alignment = .fill
        horizontalView.spacing = 8
        
        let detailsViews = viewModel.details.map { setupInfoView($0) }
        detailsViews.forEach { horizontalView.addArrangedSubview($0) }
        
        let arrangedSubviews = [
            setupInfoView(viewModel.coordinatesInfo),
            setupInfoView(viewModel.yearInfo),
            horizontalView
        ]
        arrangedSubviews.forEach { verticalContainerView.addArrangedSubview($0) }
        
        detailCalloutAccessoryView = verticalContainerView
    }
    
    private func setupInfoView(_ info: MeteorDeailInfoViewModel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        
        let title = setupLabel(font: .systemFont(ofSize: 11, weight: .light),
                               color: Theme.current.mainColor, text: info.title)
        let info = setupLabel(text: info.info)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(info)
        
        return stackView
    }
    
    private func setupLabel(font: UIFont = .systemFont(ofSize: 15, weight: .regular),
                    color: UIColor = Theme.current.titleColor, text: String) -> UILabel {
        let textLabel = UILabel()
        textLabel.font = font
        textLabel.text = text
        textLabel.textColor = color
        textLabel.numberOfLines = 0
        return textLabel
    }
}
