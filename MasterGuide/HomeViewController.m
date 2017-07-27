//
//  HomeViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "HomeViewController.h"
#import "IIViewDeckController.h"

#import "MateriasViewController.h"
#import "DicasViewController.h"
#import "ParceirosViewController.h"

#import "SplashViewController.h"

#import "Language.h"
#import "Evento.h"

#import "MapaLocalViewController.h"
#import "PinAnnotation.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize tituloEvento;
@synthesize descricaoEvento;
@synthesize tituloTempo;
@synthesize valDias;
@synthesize valHora;
@synthesize txtDias;
@synthesize txtHora;
@synthesize txtMinutos;
@synthesize txtSegundos;
@synthesize txtMaterias;
@synthesize txtDicas;
@synthesize txtParceiros;
@synthesize destinationDate, timer;
@synthesize connectionJSON, singleton;
@synthesize eventos;

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
    //self.tituloEvento.text = [Language get:@"titHome" alter:nil];
    //self.descricaoEvento.text = [Language get:@"txtHome" alter:nil];
    [self checkEvento];
    
    self.tituloTempo.text = [Language get:@"tempoHome" alter:nil];
    self.txtDias.text = [Language get:@"diasHome" alter:nil];
    self.txtHora.text = [Language get:@"horasHome" alter:nil];
    self.txtMinutos.text = [Language get:@"minHome" alter:nil];
    self.txtSegundos.text = [Language get:@"segHome" alter:nil];
    
    self.txtMaterias.text = [Language get:@"materiasHome" alter:nil];
    self.txtDicas.text = [Language get:@"dicasHome" alter:nil];
    self.txtParceiros.text = [Language get:@"parceirosHome" alter:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        //[self.imagemBack setImage:[UIImage imageNamed:@"Menu_Background.png"]];
        [self.tituloTempo setFrame:CGRectMake(123, 203, 74, 15)];
        [self.tituloEvento setFrame:CGRectMake(63, 149, 195, 20)];
        [self.descricaoEvento setFrame:CGRectMake(0, 177, 320, 21)];
        
        [self.txtDias setFrame:CGRectMake(72, 250, 31, 21)];
        [self.txtHora setFrame:CGRectMake(115, 250, 43, 21)];
        [self.txtMinutos setFrame:CGRectMake(163, 250, 51, 21)];
        [self.txtSegundos setFrame:CGRectMake(225, 250, 31, 21)];
    }
    if(result.height == 568)
    {
        //[self.imagemBack setImage:[UIImage imageNamed:@"Home_Background_568.png"]];
        [self.tituloTempo setFrame:CGRectMake(123, 210, 74, 15)];
        [self.tituloEvento setFrame:CGRectMake(63, 120, 195, 20)];
        [self.descricaoEvento setFrame:CGRectMake(0, 144, 320, 21)];
        
        [self.txtDias setFrame:CGRectMake(72, 245, 31, 21)];
        [self.txtHora setFrame:CGRectMake(115, 245, 43, 21)];
        [self.txtMinutos setFrame:CGRectMake(163, 245, 51, 21)];
        [self.txtSegundos setFrame:CGRectMake(225, 245, 31, 21)];
    }
    
    //BOTAO MENU
    UIButton *btnMenu =[[UIButton alloc] init];
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"NavBar_MenuBtn.png"] forState:UIControlStateNormal];
    
    btnMenu.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnMenu =[[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    [btnMenu addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnMenu;
    [[self.tabBarController viewDeckController] setEnabled:FALSE];
    
    //BOTAO LOCAL
    UIButton *btnShare =[[UIButton alloc] init];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"NavBar_Autodromo.png"] forState:UIControlStateNormal];
    
    btnShare.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnShare =[[UIBarButtonItem alloc] initWithCustomView:btnShare];
    [btnShare addTarget:self action:@selector(openEndereco) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = barBtnShare;

    
    //TITULO
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"NavBar_Logo.png"]];
    
    //TEXTOS
    [tituloEvento setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    [descricaoEvento setFont:[UIFont fontWithName:@"Zeppelin 33" size:11.0]];
    [tituloTempo setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    
    //[valDias setFont:[UIFont fontWithName:@"HelveticaNeue Regular" size:28.0]];
    [valDias setTextColor:[UIColor colorWithRed:255/255.f green:188/255.f blue:2/255.f alpha:1.0]];
    
    //[valHora setFont:[UIFont fontWithName:@"HelveticaNeue Regular" size:28.0]];
    [valHora setTextColor:[UIColor colorWithRed:255/255.f green:188/255.f blue:2/255.f alpha:1.0]];
    
    eventos = [singleton evento];
    
    //GET JSON
    if (eventos == nil)
    {
        NSLog(@"NAO EXITE EVENTOS");
        
        connectionJSON = [[JSONFetcher alloc] init];
        [connectionJSON setDelegate:self];
        [connectionJSON queryServiceWithParent:@"http://masterguide.lindolfolacerda.com.br/jsonEventos.php?top=1"];
        
        //PROGRESS
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    } else {
        
        NSLog(@"EXITE EVENTOS");
        [self checkEvento];
        
        destinationDate = [NSDate dateWithTimeIntervalSince1970:dataEvento];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
        
    }

    SplashViewController *splash = [[SplashViewController alloc] initWithNibName:@"SplashViewController_iPhone" bundle:nil];
    [splash setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:splash animated:NO completion:nil];
    
}

- (void) openEndereco
{
    NSLog(@"FOIII");
    
    Evento *event = [singleton eventoATUAL];
    NSString *end = [event endereco];
    
    MapaLocalViewController *mapa = [[MapaLocalViewController alloc] initWithNibName:@"MapaLocalViewController_iPhone" bundle:nil];
    [mapa setEndCorrida:end];
    [mapa setNomeCorrida:[event titulo]];
    
    [mapa setCategoria:[NSNumber numberWithInt:Corrida]];
    [mapa setTitulo:[Language get:@"txtComoChegar" alter:nil]];
    
    [[self navigationController] pushViewController:mapa animated:TRUE];
}

- (void)processSuccessful:(BOOL)success dataReceived:(NSArray *)data
{
    
    if (success)
    {

        [HUD hide:YES];
        
        NSMutableArray *dados = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [data count]; i++)
        {
            NSDictionary *item = [data objectAtIndex:i];
            Evento *evento = [[Evento alloc] init];
            
            [evento setEventoID:[item objectForKey:@"eventoId"]];
            [evento setTitulo:[item objectForKey:@"nome"]];
            [evento setDescricao:[item objectForKey:@"descricao"]];
            [evento setSince1970:[item objectForKey:@"dataHoraEpoch"]];
            [evento setIdiomaId:[item objectForKey:@"idiomaId"]];
            [evento setEndereco:[item objectForKey:@"endereco"]];
			[evento setImagem:[item objectForKey:@"imagem"]];
			
			NSLog(@"IMG %@", [item objectForKey:@"imagem"]);

            [dados addObject:evento];
        }
        
        [singleton setEvento:dados];
        eventos = dados;
        [self checkEvento];
        
        destinationDate = [NSDate dateWithTimeIntervalSince1970:dataEvento];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    }

}

- (void) checkEvento
{
    for (int y = 0; y < [eventos count]; y++)
    {
        Evento *evento = [eventos objectAtIndex:y];

        if ([[evento idiomaId] intValue] == [singleton idioma])
        {
            [tituloEvento setText:[evento titulo]];
            [descricaoEvento setText:[evento descricao]];
            dataEvento = [[evento since1970] intValue];
            
            [singleton setEventoATUAL:evento];
			
			NSString *url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [evento imagem]];
			
			EGOImageView *img = [[EGOImageView alloc] init];
			img.frame = CGRectMake(0.0, 0.0, 320, 152);
			img.imageURL = [NSURL URLWithString:url];
			[self.imgEvento addSubview:img];
        }
    }
}

- (void) updateData
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int units = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date] toDate:destinationDate options:0];
    
    [self.valDias setText:[NSString stringWithFormat:@"%d", [components day]]];
    
    [self.valHora setText:[NSString stringWithFormat:@"%@ : %@ : %@", [self checkNumber:[components hour]], [self checkNumber:[components minute]], [self checkNumber:[components second]]]];
    
}

- (NSString *) checkNumber:(int)numero
{
    NSString *valor;
    
    if (numero < 10) valor = [NSString stringWithFormat:@"0%d", numero];
    else valor = [NSString stringWithFormat:@"%d", numero];
    
    return valor;
}

- (void)viewDidUnload
{
    [self setTituloEvento:nil];
    [self setDescricaoEvento:nil];
    [self setTituloTempo:nil];
    [self setValDias:nil];
    [self setValHora:nil];
    [self setTxtDias:nil];
    [self setTxtHora:nil];
    [self setTxtMinutos:nil];
    [self setTxtSegundos:nil];
    [self setTxtMaterias:nil];
    [self setTxtDicas:nil];
    [self setTxtParceiros:nil];
    [self setImagemBack:nil];
	[self setImgEvento:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)openMateriasEspeciais:(id)sender {
    
    MateriasViewController *materias = [[MateriasViewController alloc] initWithNibName:@"MateriasViewController_iPhone" bundle:nil];
    [[self navigationController] pushViewController:materias animated:TRUE];
}

- (IBAction)openMasterDicas:(id)sender {
    
    DicasViewController *dicas = [[DicasViewController alloc] initWithNibName:@"DicasViewController_iPhone" bundle:nil];
    [[self navigationController] pushViewController:dicas animated:TRUE];
}

- (IBAction)openParceirosOficiais:(id)sender {
    
    ParceirosViewController *parceiros = [[ParceirosViewController alloc] initWithNibName:@"ParceirosViewController_iPhone" bundle:nil];
    [[self navigationController] pushViewController:parceiros animated:TRUE];
}
@end
