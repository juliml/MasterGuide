//
//  MapaLocalViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Endereco.h"
#import "SingletonManager.h"
#import <CoreLocation/CoreLocation.h>

@interface MapaLocalViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    MKMapView *mapView;
    
    NSString *titulo;
    Endereco *endereco;
    NSNumber *categoria;
    
    NSString *endCorrida;
    NSString *nomeCorrida;
    
    NSString *telefone;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *titulo;
@property (strong, nonatomic) SingletonManager *singleton;
@property (strong, nonatomic) Endereco *endereco;
@property (strong, nonatomic) NSNumber *categoria;
@property (strong, nonatomic) NSString *endCorrida;
@property (strong, nonatomic) NSString *nomeCorrida;

- (void)adicionaPino;


@end
