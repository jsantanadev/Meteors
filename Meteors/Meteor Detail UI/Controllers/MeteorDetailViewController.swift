import UIKit
import MapKit

public protocol MeteorDetailDelegate {
    func addMeteorToFavorites(id: String)
    func removeMeteorFromFavorites(id: String)
}

public final class MeteorDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: MeteorDetailViewModel!
    private var delegate: MeteorDetailDelegate!
    
    // MARK: - UI Properties
    private(set) lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.backgroundColor = Theme.current.backgroundColor
        mapView.isHidden = true
        mapView.delegate = self
        return mapView
    }()
    private(set) lazy var favoriteBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "favorites"), for: .normal)
        button.setImage(UIImage(named: "favoritesFilled"), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    public static func make(viewModel: MeteorDetailViewModel, delegate: MeteorDetailDelegate) -> MeteorDetailViewController {
        let meteorDetailViewController = MeteorDetailViewController()
        meteorDetailViewController.viewModel = viewModel
        meteorDetailViewController.delegate = delegate
        meteorDetailViewController.hidesBottomBarWhenPushed = true
        return meteorDetailViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMeteorOnMap()
    }
}

// MARK: - UI Setup
extension MeteorDetailViewController {
    private func setupUI() {
        view.backgroundColor = Theme.current.backgroundColor
        
        title = viewModel.name
        
        let favoriteBarButtonItem = UIBarButtonItem(customView: favoriteBarButton)
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
        
        favoriteBarButton.isSelected = viewModel.isFavorite
        
        view.addSubviewConstraintToEdges(mapView)
    }
}

// MARK: - Setup Meteor Coordinates on Map
extension MeteorDetailViewController {
    private func setupMeteorOnMap() {
        let offset: Double = 0.0009
        let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * offset,
                                    longitudeDelta: mapView.region.span.longitudeDelta * offset)
        
        let coordinate = viewModel.geoLocation
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
        mapView.isHidden = false
        
        let annotation = MKPointAnnotation()
        annotation.title = viewModel.name
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

// MARK: - Actions
extension MeteorDetailViewController {
    @objc public func favoriteButtonTapped() {
        let isFavorite = !favoriteBarButton.isSelected
        favoriteBarButton.isSelected = isFavorite
        
        if isFavorite {
            delegate.addMeteorToFavorites(id: viewModel.id)
        } else {
            delegate.removeMeteorFromFavorites(id: viewModel.id)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MeteorDetailViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = String(describing: MeteorAnnotationView.self)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MeteorAnnotationView
        
        if annotationView == nil {
            annotationView = MeteorAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.setup(viewModel: viewModel)
        return annotationView
    }
}
