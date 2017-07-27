//
//  LocaisViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "LocaisViewController.h"
#import "IIViewDeckController.h"
#import "MKMapView+Additions.h"

#import "PinAnnotationView.h"
#import "PinAnnotation.h"

#import "DetalheLugaresViewController.h"
#import "Language.h"
#import "SBJsonParser.h"

#import "Endereco.h"
#import "Estabelecimento.h"

@interface LocaisViewController ()

@end

@implementation LocaisViewController
@synthesize mapView, location, locationManager, filtroSeleted, singleton, locais, locaisCoordinates, filtros;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self relocateGoogleLogo];
    
    UILabel *label = (UILabel *) self.navigationItem.titleView;
    label.text = [Language get:@"titLocais" alter:nil];
    
    //if (carregou) [self adicionaPinos];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    locais = [singleton estabelecimentos];
    
    carregou = FALSE;
    filtro = 0;
    
    filtros = [[NSMutableArray alloc] init];
    botoes = [[NSMutableArray alloc] init];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        [self.imageBarra setImage:[UIImage imageNamed:@"LocaisBackGround_Barra.png"]];
    }
    if(result.height == 568)
    {
        [self.imageBarra setImage:[UIImage imageNamed:@"LocaisBackGround_Barra_568.png"]];
    }
    
    //BOTAO MENU
    UIButton *btnMenu =[[UIButton alloc] init];
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"NavBar_MenuBtn.png"] forState:UIControlStateNormal];
    
    btnMenu.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnMenu =[[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    [btnMenu addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnMenu;
    [[self.tabBarController viewDeckController] setEnabled:FALSE];
    
    //BOTAO LOCATION
    UIButton *btnLocal =[[UIButton alloc] init];
    [btnLocal setBackgroundImage:[UIImage imageNamed:@"BtnLocal.png"] forState:UIControlStateNormal];
    
    btnLocal.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnLocal =[[UIBarButtonItem alloc] initWithCustomView:btnLocal];
    [btnLocal addTarget:self action:@selector(searchUsuario) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = barBtnLocal;
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 220, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"titLocais" alter:nil];
    
    self.navigationItem.titleView = label;
    
    [self addButtons];
    
    self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
    
    //MKCoordinateRegion region;
    
    /*MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;*/
    
    self.location = self.mapView.userLocation.coordinate;
    
    //region.span = span;
    //region.center = location;
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(location, 15000, 15000);
    
    [self.mapView setRegion:region animated:NO];
	[self.locationManager startUpdatingLocation];
    
    if (!carregou)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        [self performSelector:@selector(getTodosEnderecos) withObject:nil afterDelay:2.0];
    }
    
}

- (void)getTodosEnderecos {
    
    locaisCoordinates = [[NSMutableArray alloc] init];
    
    for (int i=0; i< [locais count]; i++)
    {
        Estabelecimento *local = [locais objectAtIndex:i];
        NSString *categoria = [local categoriaId];
        
        NSInteger numCat = [categoria intValue];
        if ([[local anuncioPago] isEqualToString:@"1"]) numCat = numCat + 8;
        
        NSMutableArray *enderecos = [local endereco];
        for (int y=0; y<[enderecos count]; y++) {
            
            Endereco *endereco = [enderecos objectAtIndex:y];
            
            NSString *endText = [NSString stringWithFormat:@"%@, %@, %@, %@", [endereco endereco], [endereco numero], [endereco bairro], [endereco cidade]];
            CLLocationCoordinate2D coordinate = [self geoCodeUsingAddress:endText];
            
            
            NSString *texto = [NSString stringWithFormat:@"%@, %@, %@", [endereco endereco], [endereco numero], [endereco bairro]];
            //GET COODINATE 
            NSString * latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
            NSString * longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
            
            NSDictionary *coordenada = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [local estabelecimentoId], @"ID",
                                        [local nome],  @"nome",
                                        texto, @"endereco",
                                        [NSString stringWithFormat:@"%d", numCat], @"categoria",
                                        latitude, @"lat",
                                        longitude, @"lon", nil];
            
            [locaisCoordinates addObject:coordenada];

        }
        
        if (i == [locais count] -1)
        {
            [HUD hide:YES];
        }
        
    }
    
    [self adicionaPinos:filtros];
    carregou = TRUE;
    
}

- (void) adicionaPinos:(NSMutableArray *)tipos
{
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    for (int i=0; i < [locaisCoordinates count]; i++) {
        
        NSDictionary *dados = [locaisCoordinates objectAtIndex:i];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[dados objectForKey:@"lat"] doubleValue];
        coordinate.longitude = [[dados objectForKey:@"lon"] doubleValue];
        
        NSInteger categoria = [[dados objectForKey:@"categoria"] intValue];
        
        for (int y=0; y < [tipos count]; y++)
        {
            NSInteger filt = [[tipos objectAtIndex:y] intValue];
            
            NSInteger cat;
            if (categoria > 8) cat = categoria - 8;
            else cat = categoria;
            
            if (filt == 9 && categoria > 8)
            {
                PinAnnotation *item = [[PinAnnotation alloc] initWithName:[dados objectForKey:@"nome"] subtitle:[dados objectForKey:@"endereco"] filtro: [NSNumber numberWithInt:categoria] idlocal:[dados objectForKey:@"ID"] coordinate:coordinate];
                
                [mapView addAnnotation:item];
                break;
                
            }
            
            NSLog(@"FILTRO %d", filt);
            
            if (cat == filt || filt == 0)
            {
                PinAnnotation *item = [[PinAnnotation alloc] initWithName:[dados objectForKey:@"nome"] subtitle:[dados objectForKey:@"endereco"] filtro: [NSNumber numberWithInt:categoria] idlocal:[dados objectForKey:@"ID"] coordinate:coordinate];
            
                [mapView addAnnotation:item];
                break;
            }
        }
        
        if ([tipos count] == 0)
        {
            PinAnnotation *item = [[PinAnnotation alloc] initWithName:[dados objectForKey:@"nome"] subtitle:[dados objectForKey:@"endereco"] filtro: [NSNumber numberWithInt:categoria] idlocal:[dados objectForKey:@"ID"] coordinate:coordinate];
            
            [mapView addAnnotation:item];
        }

    }
    
    
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
    
    PinAnnotation *annt = annotation;
    
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;

    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTag:[[annt idLocal] intValue]];
    [rightButton setImage:[UIImage imageNamed:@"Locais_Seta.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"Locais_Seta.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(detalheLocal:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}


- (void) addButtons
{
    UIButton *btnTodos = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 59.0, 37.0)];
    [btnTodos setImage:[UIImage imageNamed:@"BtnLateral_01TodosNormal.png"] forState:UIControlStateNormal];
    [btnTodos setImage:[UIImage imageNamed:@"BtnLateral_01TodosSelecionado.png"] forState:UIControlStateSelected];
    [btnTodos addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnTodos setSelected:TRUE];
    
    UIButton *btnPagos = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 37.0, 59.0, 37.0)];
    [btnPagos setImage:[UIImage imageNamed:@"BtnLateral_02PagosNormal.png"] forState:UIControlStateNormal];
    [btnPagos setImage:[UIImage imageNamed:@"BtnLateral_02PagosSelecionado.png"] forState:UIControlStateSelected];
    [btnPagos addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDiversao = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 74.0, 59.0, 37.0)];
    [btnDiversao setImage:[UIImage imageNamed:@"BtnLateral_03DiversaoNormal.png"] forState:UIControlStateNormal];
    [btnDiversao setImage:[UIImage imageNamed:@"BtnLateral_03DiversaoSelecionado.png"] forState:UIControlStateSelected];
    [btnDiversao addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnCompras = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 111.0, 59.0, 37.0)];
    [btnCompras setImage:[UIImage imageNamed:@"BtnLateral_07ComprasNormal.png"] forState:UIControlStateNormal];
    [btnCompras setImage:[UIImage imageNamed:@"BtnLateral_07ComprasSelecionado.png"] forState:UIControlStateSelected];
    [btnCompras addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnGastro = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 148.0, 59.0, 37.0)];
    [btnGastro setImage:[UIImage imageNamed:@"BtnLateral_04GastronomiaNormal.png"] forState:UIControlStateNormal];
    [btnGastro setImage:[UIImage imageNamed:@"BtnLateral_04GastronomiaSelecionado.png"] forState:UIControlStateSelected];
    [btnGastro addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnExpo = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 185.0, 59.0, 37.0)];
    [btnExpo setImage:[UIImage imageNamed:@"BtnLateral_05ExpoNormal.png"] forState:UIControlStateNormal];
    [btnExpo setImage:[UIImage imageNamed:@"BtnLateral_05ExpoSelecionado.png"] forState:UIControlStateSelected];
    [btnExpo addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBares = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 222.0, 59.0, 37.0)];
    [btnBares setImage:[UIImage imageNamed:@"BtnLateral_06BaresNormal.png"] forState:UIControlStateNormal];
    [btnBares setImage:[UIImage imageNamed:@"BtnLateral_06BaresSelecionado.png"] forState:UIControlStateSelected];
    [btnBares addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnTeatro = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 259.0, 59.0, 37.0)];
    [btnTeatro setImage:[UIImage imageNamed:@"BtnLateral_08TeatroNormal.png"] forState:UIControlStateNormal];
    [btnTeatro setImage:[UIImage imageNamed:@"BtnLateral_08TeatroSelecionado.png"] forState:UIControlStateSelected];
    [btnTeatro addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnParques = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 296.0, 59.0, 37.0)];
    [btnParques setImage:[UIImage imageNamed:@"BtnLateral_09ParquesNormal.png"] forState:UIControlStateNormal];
    [btnParques setImage:[UIImage imageNamed:@"BtnLateral_09ParquesSelecionado.png"] forState:UIControlStateSelected];
    [btnParques addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnHotel = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 333.0, 59.0, 37.0)];
    [btnHotel setImage:[UIImage imageNamed:@"BtnLateral_10HotelNormal.png"] forState:UIControlStateNormal];
    [btnHotel setImage:[UIImage imageNamed:@"BtnLateral_10HotelSelecionado.png"] forState:UIControlStateSelected];
    [btnHotel addTarget:self action:@selector(filtroMapa:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnTodos setTag:1];
    [btnDiversao setTag:2];
    [btnCompras setTag:3];
    [btnGastro setTag:4];
    [btnExpo setTag:5];
    [btnBares setTag:6];
    [btnTeatro setTag:7];
    [btnParques setTag:8];
    [btnHotel setTag:9];
    [btnPagos setTag:10];
    
    [botoes addObject:btnTodos];
    [botoes addObject:btnDiversao];
    [botoes addObject:btnCompras];
    [botoes addObject:btnGastro];
    [botoes addObject:btnExpo];
    [botoes addObject:btnBares];
    [botoes addObject:btnTeatro];
    [botoes addObject:btnParques];
    [botoes addObject:btnHotel];
    [botoes addObject:btnPagos];
    
    [self.scrollview addSubview:btnTodos];
    [self.scrollview addSubview:btnDiversao];
    [self.scrollview addSubview:btnCompras];
    [self.scrollview addSubview:btnGastro];
    [self.scrollview addSubview:btnExpo];
    [self.scrollview addSubview:btnBares];
    [self.scrollview addSubview:btnTeatro];
    [self.scrollview addSubview:btnParques];
    [self.scrollview addSubview:btnHotel];
    [self.scrollview addSubview:btnPagos];
    
    self.scrollview.contentSize = CGSizeMake(59, 460);
    [self.scrollview setShowsHorizontalScrollIndicator:FALSE];
	self.scrollview.delegate = self;
}

- (void) filtroMapa:(id)sender
{
    UIButton *botao = (UIButton *)sender;
    
    filtro = [NSNumber numberWithInt:[botao tag] -1];
    NSLog(@"FILT %@", filtro);
    
    if ([botao tag] != 1) {
        UIButton *btn = [botoes objectAtIndex:0];
        [btn setSelected:FALSE];
        
        if ([botao state] == 5) {
            [botao setSelected:FALSE];
            
            for (int i=0; i < [filtros count]; i++)
            {
                if (filtro == [filtros objectAtIndex:i])
                {
                    [filtros removeObjectAtIndex:i];
                }
            }
            
        } else {
            [botao setSelected:TRUE];
            [filtros addObject:filtro];
        }
        
        if ([filtros count] == 0)
        {
            UIButton *bt = [botoes objectAtIndex:0];
            [bt setSelected:TRUE];
        }
        
    } else {
        
        [botao setSelected:TRUE];
        
        for (int i=0; i < [botoes count]; i++) {
             if (i != 0)
             {
                 UIButton *btn = [botoes objectAtIndex:i];
                 [btn setSelected:FALSE];
             }
        }
        
        [filtros removeAllObjects];
    }
    
    [self adicionaPinos:filtros];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setImageBarra:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) detalheLocal:(id)sender
{
    UIButton* rightButton = (UIButton *)sender;
    NSLog(@"PIN %d", [rightButton tag]);
    
    for (int i=0; i < [locais count]; i++) {
     
        Estabelecimento *local = [locais objectAtIndex:i];
        if ([rightButton tag] == [[local estabelecimentoId] intValue])
        {
            [singleton setEstabelecimentoATUAL:local];
        }
    }
    
    DetalheLugaresViewController *detailViewController = [[DetalheLugaresViewController alloc] initWithNibName:@"DetalheLugaresViewController_iPhone" bundle:nil];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void) searchUsuario
{

    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    self.location = self.mapView.userLocation.coordinate;
    
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:NO];

}


-(CLLocationCoordinate2D) addressLocation:(NSString *)_address
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                           [_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if(locationString) {
        NSArray *listItems = [locationString componentsSeparatedByString:@","];
        if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
            latitude = [[listItems objectAtIndex:2] doubleValue];
            longitude = [[listItems objectAtIndex:3] doubleValue];
        }
        else {
            //NSLog(@"Error1 = %@", error);
        }
    } else {
        // NSLog(@"Error2 = %@", error);
    }
    
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = latitude;
    locationCoordinate.longitude = longitude;
    
    return locationCoordinate;
}

#pragma mark LocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

	[mapView setCenterCoordinate:newLocation.coordinate animated:YES];
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
	NSLog(@"locationManager");
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	[self locationFail];
}

#pragma mark - Events
- (void)locationFail {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível se conectar com o GPS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

- (void)connectionFail {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível se conectar com a internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self relocateGoogleLogo];
}

- (void)relocateGoogleLogo {
	/*UIImageView *logo = [mapView googleLogo];
	if (logo == nil)
		return;
    
	CGRect frame = logo.frame;
	frame.origin.x = 320 - (frame.size.width + 20);
	logo.frame = frame;*/
    
    
    UIView *legalView = nil;
    [legalView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    for (UIView *subview in self.mapView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            // Legal label iOS 6
            legalView = subview;
        } else if ([subview isKindOfClass:[UIImageView class]]) {
            // google image iOS 5 and lower
            legalView = subview;
        }
    }

    
    CGRect frame = legalView.frame;
	frame.origin.x = 320 - (frame.size.width + 20);
    legalView.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
