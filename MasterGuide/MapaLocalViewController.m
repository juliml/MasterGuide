//
//  MapaLocalViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "MapaLocalViewController.h"
#import "Language.h"

#import "MKMapView+Additions.h"

#import "PinAnnotationView.h"
#import "PinAnnotation.h"

#import "SBJsonParser.h"

@interface MapaLocalViewController ()

@end

@implementation MapaLocalViewController
@synthesize titulo, endereco, categoria, mapView, singleton, endCorrida, nomeCorrida;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        endCorrida = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy =
        kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
    
    //BOTAO BACK
    UIButton *btnBack =[[UIButton alloc] init];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Btn_Voltar.png"] forState:UIControlStateNormal];
    [btnBack setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];
    [[btnBack titleLabel] setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    btnBack.frame = CGRectMake(100, 100, 58, 31);
    UIBarButtonItem *barBtnBack =[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [btnBack addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnBack;
    
    //BOTAO LOCATION
    UIButton *btnLocal =[[UIButton alloc] init];
    [btnLocal setBackgroundImage:[UIImage imageNamed:@"Btn_TracarRota.png"] forState:UIControlStateNormal];
    [btnLocal setTitle:[Language get:@"btnRota" alter:nil] forState:UIControlStateNormal];
    [[btnLocal titleLabel] setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    btnLocal.contentEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    
    btnLocal.frame = CGRectMake(100, 100, 84, 31);
    UIBarButtonItem *barBtnLocal =[[UIBarButtonItem alloc] initWithCustomView:btnLocal];
    [btnLocal addTarget:self action:@selector(tracarRota) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = barBtnLocal;
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 120, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = titulo;
    
    self.navigationItem.titleView = label;
    
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    region.span = span;
    [self.mapView setRegion:region animated:NO];
    
    [self adicionaPino];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", @"Core location has a position.");
    
    NSString *latitude = [[NSNumber numberWithDouble:newLocation.coordinate.latitude] stringValue];
    NSString *longitude = [[NSNumber numberWithDouble:newLocation.coordinate.longitude] stringValue];
    
    [singleton setLocalizacaoATUAL:[NSString stringWithFormat:@"%@,%@", latitude, longitude]];
}
- (void) locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"Core location can't get a fix.");
}

- (void) backView
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void)adicionaPino {
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSString *endText = [NSString stringWithFormat:@"%@, %@, %@, %@", [endereco endereco], [endereco numero], [endereco bairro], [endereco cidade]];
    
    if (![endCorrida isEqualToString:@""]) endText = endCorrida;
    
    CLLocationCoordinate2D coordinate = [self geoCodeUsingAddress:endText];
    
    NSMutableArray *fones = [endereco telefones];
    telefone = [[NSString alloc] init];
    if ([fones count] > 0) telefone = [fones objectAtIndex:0];

    PinAnnotation *item;
    if (![endCorrida isEqualToString:@""]){
    
         item = [[PinAnnotation alloc] initWithName:nomeCorrida subtitle:endText filtro:categoria idlocal:@"" coordinate:coordinate];
        [mapView addAnnotation:item];
        
    } else {
        
        item = [[PinAnnotation alloc] initWithName:[Language get:@"mapaTelefone" alter:nil] subtitle:telefone filtro:categoria idlocal:@"" coordinate:coordinate];
        [mapView addAnnotation:item];
    }

    [mapView setCenterCoordinate:coordinate animated:YES];
    [mapView setSelectedAnnotations:[[NSArray alloc] initWithObjects:item,nil]];
    
}

- (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address
{
    CLLocationCoordinate2D myLocation;
    
    NSString *esc_addr = [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *responseString = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString: req]  encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *googleResponse = [parser objectWithString: responseString];
    
    NSDictionary *resultsDict = [googleResponse valueForKey:  @"results"];
    NSDictionary *geometryDict = [resultsDict valueForKey: @"geometry"];
    NSDictionary *locationDict = [geometryDict valueForKey: @"location"];
    NSArray *latArray = [locationDict valueForKey: @"lat"]; NSString *latString = [latArray lastObject];
    NSArray *lngArray = [locationDict valueForKey: @"lng"]; NSString *lngString = [lngArray lastObject];
    
    myLocation.latitude = [latString doubleValue];
    myLocation.longitude = [lngString doubleValue];
    
    //NSLog(@"lat: %f\tlon:%f", myLocation.latitude, myLocation.longitude);
    return myLocation;
}


- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == map.userLocation) {
        return nil;
    }
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    PinAnnotationView *annotationView =
    (PinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[PinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setImage:[UIImage imageNamed:@"Locais_Seta.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"Locais_Seta.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(ligarLocal) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}

- (void) ligarLocal
{
    if (![endCorrida isEqualToString:@""]){
        
        [self tracarRota];
        
    } else {
        
        if (![telefone isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaLigarTitulo" alter:nil] message:[Language get:@"alertaLigarTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
            [alert setTag:1];
            [alert show];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaLigarTitulo" alter:nil] message:[Language get:@"alertaSemTelefone" alter:nil] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert setTag:1];
            [alert show];
        }
    }
}

- (void) tracarRota
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaRotaTitulo" alter:nil] message:[Language get:@"alertaRotaTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
    [alert setTag:2];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ([alertView tag] == 1) {
        
        if (buttonIndex == 0) {
            NSLog(@"Cancel Tapped.");
        }
        else if (buttonIndex == 1)
        {
            
            NSString *telefoneSelecionado = [telefone stringByReplacingOccurrencesOfString:@" " withString:@""];

            NSString *numero = [NSString stringWithFormat:@"tel:%@", telefoneSelecionado];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numero]];
        }
        
    } else if ([alertView tag] == 2) {
        
        if (buttonIndex == 0) {
            NSLog(@"Cancel Tapped.");
        }
        else if (buttonIndex == 1) {

            
            NSString *link;
            
            float version = [[[UIDevice currentDevice] systemVersion] floatValue];
            if (version < 6.0){
                link = @"http://maps.google.com/maps?q=";
            } else {
                link = @"http://maps.apple.com/maps?daddr=";
            }
            
            NSString *from = [singleton localizacaoATUAL];
            NSString *to = [NSString stringWithFormat:@"%@%@+%@+%@+%@", link, [endereco endereco], [endereco numero], [endereco bairro], [endereco cidade]];
            
            if (![endCorrida isEqualToString:@""]) to = [NSString stringWithFormat:@"%@%@", link, endCorrida];
            
            NSString *rota = [NSString stringWithFormat:@"%@&saddr=%@", to, from];
            
            NSString *encodedAddress = [rota stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
            
            NSLog(@"ENDERECO %@", encodedAddress);
            
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:[NSURL URLWithString:encodedAddress]];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
