import MapKit
import UIKit

final class SearchBookstoresViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties

    var locationManager = CLLocationManager()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        requestLocationAuthorization()
    }

    // MARK: - Private Methods

    private func setupProperties() {
        searchBar.delegate = self
        mapView.delegate = self

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    private func requestLocationAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Search Bar delegate

extension SearchBookstoresViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        fetchMapRequest(searchBar.text)
    }

    private func fetchMapRequest(_ searchText: String?) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard error == nil,
                  let self = self,
                  let response = response
            else { return }

            self.mapView.removeAnnotations(self.mapView.annotations)

            for item in response.mapItems {
                self.createMapAnnotation(for: item)
            }
        }
    }

    private func createMapAnnotation(for item: MKMapItem) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = item.placemark.coordinate
        annotation.title = item.name
        annotation.subtitle = item.phoneNumber
        mapView.addAnnotation(annotation)
    }
}

// MARK: - Map View delegate

extension SearchBookstoresViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        drawRoute(to: annotation.coordinate)
    }

    private func drawRoute(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = createItem(for: mapView.userLocation.coordinate)
        request.destination = createItem(for: destination)

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard error == nil,
                  let self = self,
                  let response = response,
                  let route = response.routes.first
            else { return }

            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlays([route.polyline], level: .aboveRoads)
        }
    }

    private func createItem(for coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 6.0
            renderer.strokeColor = UIColor(named: "AccentColor")
            return renderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
