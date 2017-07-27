//
//  CompartilhaViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "CompartilhaViewController.h"
#import "Language.h"
#import "Estabelecimento.h"
#import "Endereco.h"

#import "SHK.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKFoursquareV2.h"

#import "IIViewDeckController.h"

@interface CompartilhaViewController ()

@end

@implementation CompartilhaViewController
@synthesize tabela, cellFavoritar, singleton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    singleton = [SingletonManager sharedController];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Menu_Background.png"]];
    [tabela setBackgroundView:imageView];
    [tabela setSeparatorColor:[UIColor blackColor]];
    
    itens = [[NSMutableArray alloc] init];
    [self carregaItens];
 
    //ALERT CHECK REDES
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Já configurou sua rede?" message:@"Antes de compartilhar em sua redes sociais, configure sua conta" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Confirmar",nil];
     [alert setTag:0];
     [alert show];*/
    
}

- (void) carregaItens
{
    [itens removeAllObjects];
    
    NSDictionary *favoritar = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"favoritar", @"id",
                               [Language get:@"sharedFavoritar" alter:nil], @"titulo",
                               @"Icon_FavoritarOFF.png", @"icon",nil];
    [itens addObject:favoritar];
    
    NSDictionary *facebook = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"facebook", @"id",
                              @"Facebook", @"titulo",
                              @"Icon_Facebook.png", @"icon",nil];
    [itens addObject:facebook];
    
    NSDictionary *twitter = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"twitter", @"id",
                             @"Twitter", @"titulo",
                             @"Icon_Twitter.png", @"icon",nil];
    [itens addObject:twitter];
    
    NSDictionary *foursquare = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"foursquare", @"id",
                                @"Check-In Foursquare", @"titulo",
                                @"Icon_FourSquare.png", @"icon",nil];
    [itens addObject:foursquare];
    
    NSDictionary *email = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"email", @"id",
                           [Language get:@"sharedEmail" alter:nil], @"titulo",
                           @"Icon_Email.png", @"icon",nil];
    [itens addObject:email];
    
    NSDictionary *site = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"site", @"id",
                          [Language get:@"sharedSite" alter:nil], @"titulo",
                          @"Icon_Link.png", @"icon",nil];
    [itens addObject:site];
    
    NSDictionary *rota = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"rota", @"id",
                         [Language get:@"btnRota" alter:nil], @"titulo",
                          @"Icon_TracarRota.png", @"icon",nil];
    [itens addObject:rota];
}

- (void) reloadMenu
{
    [self carregaItens];
    [tabela reloadData];
}

- (void)viewDidUnload
{
    [self setTabela:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [itens count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *titulo;
    NSDictionary *item = [itens objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *icone = [[UIImageView alloc] initWithFrame:CGRectMake(65,0,40,40)];
        icone.tag = 1;
        [icone setImage:[UIImage imageNamed:[item valueForKey:@"icon"]]];
        
        titulo = [[UILabel alloc] initWithFrame:CGRectMake(105,8,200,30)];
        titulo.text = [item valueForKey:@"titulo"];
        titulo.tag = 2;
        titulo.textColor = [UIColor whiteColor];
        titulo.backgroundColor = [UIColor clearColor];
        titulo.font = [UIFont fontWithName:@"Zeppelin 33" size:14];
        
        [cell.contentView addSubview:icone];
        [cell.contentView addSubview:titulo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([[item objectForKey:@"id"] isEqualToString:@"favoritar"]) cellFavoritar = cell;
        
    } else {
        
        titulo = (UILabel*)[cell.contentView viewWithTag:2];
        titulo.text = [item valueForKey:@"titulo"];
    }
    
    return cell;
}

- (void) checkFavorito
{
    NSMutableArray *favoritos = [singleton favoritos];
    Estabelecimento *local = [singleton estabelecimentoATUAL];
    Boolean eFavorito = FALSE;
    
    for (int i = 0; i < [favoritos count]; i++)
    {
        NSString *fav = [favoritos objectAtIndex:i];
        if ([fav isEqualToString:[local estabelecimentoId]])
        {
            eFavorito = TRUE;
        }
    }
    
    favorito = eFavorito;
    UIImageView *icone = (UIImageView*)[cellFavoritar.contentView viewWithTag:1];
    
    if (eFavorito)
        [icone setImage:[UIImage imageNamed:@"Icon_FavoritarON.png"]];
    else
        [icone setImage:[UIImage imageNamed:@"Icon_FavoritarOFF.png"]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [itens objectAtIndex:[indexPath row]];
    NSString *tipo = [item objectForKey:@"id"];
    
    if ([tipo isEqualToString:@"favoritar"])
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *icone = (UIImageView*)[cell.contentView viewWithTag:1];
        
        if (favorito) {
            favorito = FALSE;
            [icone setImage:[UIImage imageNamed:@"Icon_FavoritarOFF.png"]];
            [self removeFavorito];
        } else {
            favorito = TRUE;
            [icone setImage:[UIImage imageNamed:@"Icon_FavoritarON.png"]];
            [self adicionaFavorito];
        }
        
    }
    else if ([tipo isEqualToString:@"facebook"])
    {
        if ([SHKFacebook isServiceAuthorized])
        {
            Estabelecimento *local = [singleton estabelecimentoATUAL];
            
            SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ via http://www.facebook.com/MasterGuideApp", [local nome]]];
            [SHKFacebook shareItem:item];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisTitulo" alter:nil] message:[Language get:@"alertSociaisTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
            [alert setTag:4];
            [alert show];
        }

    }
    else if ([tipo isEqualToString:@"twitter"])
    {

        if ([singleton setTwitter])
        {
            Estabelecimento *local = [singleton estabelecimentoATUAL];
            
            SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ via @masterguideapp", [local nome]]];
            [SHKTwitter shareItem:item];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisTitulo" alter:nil] message:[Language get:@"alertSociaisTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
            [alert setTag:4];
            [alert show];
        }
        
        
        
    }
    else if ([tipo isEqualToString:@"foursquare"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaCheckTitulo" alter:nil] message:[Language get:@"alertaCheckTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
        [alert setTag:1];
        [alert show];
        
    }
    else if ([tipo isEqualToString:@"email"])
    {
        [self sendEmail];
    }
    else if ([tipo isEqualToString:@"site"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaSiteTitulo" alter:nil] message:[Language get:@"alertaSiteTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
        [alert setTag:2];
        [alert show];
    }
    else if ([tipo isEqualToString:@"rota"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaRotaTitulo" alter:nil] message:[Language get:@"alertaRotaTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil] ,nil];
        [alert setTag:3];
        [alert show];
    }
}

- (void) adicionaFavorito
{
    NSMutableArray *favoritos = [singleton favoritos];
    
    Estabelecimento *local = [singleton estabelecimentoATUAL];
    NSString *idLocal = [local estabelecimentoId];
    
    [favoritos addObject:idLocal];
    [singleton setFavoritos:favoritos];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[singleton favoritos] forKey:@"favoritos"];

}

- (void) removeFavorito
{
    NSMutableArray *favoritos = [singleton favoritos];
    NSMutableArray *new = [[NSMutableArray alloc] init];
    
    Estabelecimento *local = [singleton estabelecimentoATUAL];
    
    for (int i = 0; i < [favoritos count]; i++)
    {
        NSString *fav = [favoritos objectAtIndex:i];
        if (![fav isEqualToString:[local estabelecimentoId]])
        {
            [new addObject:fav];
        }
    }
    
    [singleton setFavoritos:new];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[singleton favoritos] forKey:@"favoritos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void) sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [[mailViewController navigationBar] setTintColor:[UIColor colorWithRed:136/255.f green:2/255.f blue:22/255.f alpha:1.0]];

        [mailViewController setSubject:[Language get:@"textoEmail" alter:nil]];
        //[mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        
        Estabelecimento *estabelecimento = [singleton estabelecimentoATUAL];
        
        NSArray *usersTo = [NSArray arrayWithObject:[estabelecimento email]];
        [mailViewController setToRecipients:usersTo];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
        //[self presentModalViewController:mailViewController animated:YES];
          
    }
    else {
              
        NSLog(@"Device is unable to send email in its current state.");
              
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1)
    {
        if ([alertView tag] == 0) //ALERT CONFIGURA
        {
            
        }
        else if ([alertView tag] == 1) //ALERT FOURSQUARE
        {
            
            if ([SHKFoursquareV2 isServiceAuthorized])
            {
                
                Estabelecimento *local = [singleton estabelecimentoATUAL];
                
                SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ via @masterguideapp", [local nome]]];
                [SHKFoursquareV2 shareItem:item];
                
            } else {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisTitulo" alter:nil] message:[Language get:@"alertSociaisTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:4];
                [alert show];
                
            }
            
        }
        else if ([alertView tag] == 2) //ALERT SITE
        {
            Estabelecimento *local = [singleton estabelecimentoATUAL];
            NSString *site = [local site];
            
            if ([site isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaSiteTitulo" alter:nil] message:[Language get:@"alertSemSite" alter:nil] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                [alert setTag:5];
                [alert show];
            }
            else
            {
                UIApplication *app = [UIApplication sharedApplication];
                [app openURL:[NSURL URLWithString:site]];
            }
           
        }
        else if ([alertView tag] == 3) //ALERT ROTA
        {
            
            Estabelecimento *local = [singleton estabelecimentoATUAL];
            NSMutableArray *locais = [local endereco];
            Endereco *endereco = [locais objectAtIndex:0];

            NSString *link;
            
            float version = [[[UIDevice currentDevice] systemVersion] floatValue];
            if (version < 6.0){
                link = @"http://maps.google.com/maps?daddr=";
            } else {
                link = @"http://maps.apple.com/maps?daddr=";
            }
            
            NSString *from = [singleton localizacaoATUAL];
            NSString *rota = [NSString stringWithFormat:@"%@%@+%@+%@+%@&saddr=%@", link, [endereco endereco], [endereco numero], [endereco bairro], [endereco cidade], from];
            
            NSString *encodedAddress = [rota stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
            
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:[NSURL URLWithString:encodedAddress]];
            
        }
        else if ([alertView tag] == 4) //ALERT CONFIGURE
        {
            if ([singleton callMenu]) {
            
                [self.viewDeckController openLeftViewBouncing:^(IIViewDeckController *controller) {
                    if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
                        
                        
                        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                            
                            self.viewDeckController.centerController = [singleton principal];
                            [[singleton principal] setSelectedIndex:4];
                            
                            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
                        }];
                        
                        
                    }
                    [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
                    
                }];
                
            } else {
                
                [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
                    
                    [[singleton principal] setSelectedIndex:4];
                    
                    [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
                }];
            }
        }
    }
}

@end
