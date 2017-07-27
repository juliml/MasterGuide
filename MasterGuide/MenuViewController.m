//
//  MenuViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "MenuViewController.h"
#import "IIViewDeckController.h"

#import "TelefonesViewController.h"
#import "FavoritosViewController.h"
#import "ListaLugaresViewController.h"

#import "Language.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize tabela, singleton;

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
    
}

- (void) carregaItens
{
    [itens removeAllObjects];
    //NSLog(@"ARRAY %d", [itens count]);
    
    NSDictionary *cidade = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"", @"id",
                            [Language get:@"menuCidade" alter:nil], @"titulo",
                            @"Icon_Cidade.png", @"icon",nil];
    [itens addObject:cidade];
    
    NSDictionary *diversao = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"1", @"id",
                              [Language get:@"menuDiversao" alter:nil], @"titulo",
                              @"Icon_Diversao.png", @"icon",nil];
    [itens addObject:diversao];
    
    NSDictionary *compras = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"2", @"id",
                             [Language get:@"menuCompras" alter:nil], @"titulo",
                             @"Icon_Compras.png", @"icon",nil];
    [itens addObject:compras];
    
    NSDictionary *gastro = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"3", @"id",
                            [Language get:@"menuRestaurantes" alter:nil], @"titulo",
                            @"Icon_Gastronomia.png", @"icon",nil];
    [itens addObject:gastro];
    
    NSDictionary *expo = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"4", @"id",
                          [Language get:@"menuExposicoes" alter:nil], @"titulo",
                          @"Icon_Expo.png", @"icon",nil];
    [itens addObject:expo];
    
    NSDictionary *bares = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"5", @"id",
                           [Language get:@"menuBares" alter:nil], @"titulo",
                           @"Icon_Bares.png", @"icon",nil];
    [itens addObject:bares];
    
    NSDictionary *teatros = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"6", @"id",
                             [Language get:@"menuTeatros" alter:nil], @"titulo",
                             @"Icon_Teatro.png", @"icon",nil];
    [itens addObject:teatros];
    
    NSDictionary *parques = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"7", @"id",
                             [Language get:@"menuParques" alter:nil], @"titulo",
                             @"Icon_Parques.png", @"icon",nil];
    [itens addObject:parques];
    
    NSDictionary *hoteis = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"8", @"id",
                            [Language get:@"menuHoteis" alter:nil], @"titulo",
                            @"Icon_Hoteis.png", @"icon",nil];
    [itens addObject:hoteis];
    
    NSDictionary *telefones = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"", @"id",
                               [Language get:@"menuTelefones" alter:nil], @"titulo",
                               @"Icon_Fones.png", @"icon",nil];
    [itens addObject:telefones];
    
    NSDictionary *favoritos = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"", @"id",
                               [Language get:@"menuFavoritos" alter:nil], @"titulo",
                               @"Icon_Favoritos.png", @"icon",nil];
    [itens addObject:favoritos];
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

        UIImage *image = [UIImage imageNamed:[item valueForKey:@"icon"]];
        cell.imageView.image = image;
        
        titulo = [[UILabel alloc] initWithFrame:CGRectMake(45,8,250,30)];
        titulo.text = [item valueForKey:@"titulo"];
        titulo.tag = 1;
        titulo.textColor = [UIColor whiteColor];
        titulo.backgroundColor = [UIColor clearColor];
        titulo.font = [UIFont fontWithName:@"Zeppelin 33" size:14];
        
        [cell.contentView addSubview:titulo];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    
    } else {
        
        titulo = (UILabel*)[cell.contentView viewWithTag:1];
        titulo.text = [item valueForKey:@"titulo"];
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *item = [itens objectAtIndex:[indexPath row]];
    NSString *tipo = [item valueForKey:@"titulo"];
    NSString *categoria = [item valueForKey:@"id"];
    
    UINavigationController *interna;
    BOOL abreInterna = TRUE;
    
    if ([tipo isEqualToString:[Language get:@"menuTelefones" alter:nil]])
    {
        TelefonesViewController *telefones = [[TelefonesViewController alloc] initWithNibName:@"TelefonesViewController_iPhone" bundle:nil];
        
        interna = [[UINavigationController alloc] initWithRootViewController:telefones];
    }
    else if ([tipo isEqualToString:[Language get:@"menuFavoritos" alter:nil]]) {
        
        FavoritosViewController *favoritos = [[FavoritosViewController alloc] initWithNibName:@"FavoritosViewController_iPhone" bundle:nil];
        
        interna = [[UINavigationController alloc] initWithRootViewController:favoritos];
    }
    else if ([tipo isEqualToString:[Language get:@"menuCidade" alter:nil]]) {
        
        abreInterna = FALSE;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"menuCidade" alter:nil] message:[Language get:@"alertaCidade" alter:nil] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    else
    {
        [singleton setTituloFiltro:tipo];
        [singleton setCategoria:categoria];
        
        ListaLugaresViewController *filtro = [[ListaLugaresViewController alloc] initWithNibName:@"ListaLugaresViewController_iPhone" bundle:nil];
        
        interna = [[UINavigationController alloc] initWithRootViewController:filtro];
    }


    if (abreInterna) {
        //self.viewDeckController.centerController = interna;
        //[self.viewDeckController closeLeftViewAnimated:TRUE];
        
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            self.viewDeckController.centerController = interna;
            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
        }];
    }
    
}


@end
