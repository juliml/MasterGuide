//
//  LocaisViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SingletonManager.h"
#import "MBProgressHUD.h"

@interface LocaisViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, MBProgressHUDDelegate>
{
    MKMapView *mapView;
    
    CLLocationCoordinate2D location;
    CLLocationManager *locationManager;
    
    UIButton *filtroSeleted;
    SingletonManager *singleton;
    
    NSMutableArray *locais;
    NSMutableArray *locaisCoordinates;
    
    MBProgressHUD *HUD;
    
    Boolean carregou;
    NSNumber *filtro;
    NSMutableArray *filtros;
    
    NSMutableArray *botoes;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) UIButton *filtroSeleted;
@property (strong, nonatomic) SingletonManager *singleton;

@property (strong, nonatomic) NSMutableArray *locais;
@property (strong, nonatomic) NSMutableArray *locaisCoordinates;
@property (strong, nonatomic) NSMutableArray *filtros;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageBarra;

- (CLLocationCoordinate2D) addressLocation:(NSString *)_address;

- (void)getTodosEnderecos;

- (void)locationFail;
- (void)connectionFail;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

@end
