//
//  ViewController.swift
//  Marcando la ruta
//
//  Created by Fredy Cervantes Téllez on 29/03/16.
//  Copyright © 2016 CursoTecHardware. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    private let manejadorMapa = CLLocationManager()
    private var posicionInicial: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejadorMapa.delegate = self
        manejadorMapa.desiredAccuracy = kCLLocationAccuracyBest
        manejadorMapa.distanceFilter = 50
        manejadorMapa.requestWhenInUseAuthorization()
        posicionInicial = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejadorMapa.startUpdatingLocation()
            manejadorMapa.startUpdatingHeading()
            mapa.showsUserLocation = true
        } else {
            manejadorMapa.stopUpdatingLocation()
            manejadorMapa.startUpdatingHeading()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if posicionInicial == nil {
                posicionInicial = locations.first

                let l_Region = MKCoordinateRegionMakeWithDistance(posicionInicial.coordinate, 1000.0, 1000.0)
                mapa.setRegion(l_Region, animated: false)
            }
            
            var l_Coordenada = CLLocationCoordinate2D()
            l_Coordenada.latitude = (locations.first!.coordinate.latitude)
            l_Coordenada.longitude = (locations.first!.coordinate.longitude)
            mapa.setCenterCoordinate(l_Coordenada, animated: true)
            
            let l_Pin = MKPointAnnotation()
            l_Pin.title = "(" + "\(Int(locations.first!.coordinate.latitude))" + "," + "\(Int(locations.first!.coordinate.longitude))" + ")"
            let l_DistanciaAcumulada = (locations.first!.distanceFromLocation(posicionInicial)) as CLLocationDistance
            l_Pin.subtitle = "\(Int(l_DistanciaAcumulada))"
            l_Pin.coordinate = l_Coordenada
            mapa.addAnnotation(l_Pin)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let li_Alerta = UIAlertController(title: "Aviso", message: "Error: \(error.code)", preferredStyle: .Alert)
        
        let li_AccionOK = UIAlertAction(title: "Bien", style: .Default, handler: {
            accion in
        })
        li_Alerta.addAction(li_AccionOK)
        self.presentViewController(li_Alerta, animated: true, completion: nil)
    }

    @IBAction func seleccionaTipoMapa(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapa.mapType = .Standard
            break
        case 1:
            mapa.mapType = .Satellite
            break
        case 2:
            mapa.mapType = .Hybrid
            break
        default:
            break
        }
    }

}

