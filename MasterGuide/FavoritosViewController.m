//
//  FavoritosViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "FavoritosViewController.h"
#import "IIViewDeckController.h"

#import "Language.h"
#import "DetalheLugaresViewController.h"

@interface FavoritosViewController ()

@end

@implementation FavoritosViewController
@synthesize singleton, tabela;

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
    UILabel *label = (UILabel *) self.navigationItem.titleView;
    label.text = [Language get:@"menuFavoritos" alter:nil];
    
    UIBarButtonItem *botao = (UIBarButtonItem *) self.navigationItem.leftBarButtonItem;
    UIButton *bt = (UIButton *)[botao customView];
    [bt setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *editar = (UIBarButtonItem *) self.navigationItem.rightBarButtonItem;
    UIButton *btE = (UIButton *)[editar customView];
    [btE setTitle:[Language get:@"btnEditar" alter:nil] forState:UIControlStateNormal];
    
    //ITENS
    itens = [self getFavoritos];
    [tabela reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    editarTAB = FALSE;
    
    [singleton setCallMenu:TRUE];
    
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
    
    //BOTAO EDITAR
    UIButton *btnEditar =[[UIButton alloc] init];
    [btnEditar setBackgroundImage:[UIImage imageNamed:@"Btn_Editar.png"] forState:UIControlStateNormal];
    [btnEditar setTitle:[Language get:@"btnEditar" alter:nil] forState:UIControlStateNormal];
    [[btnEditar titleLabel] setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    btnEditar.contentEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    
    btnEditar.frame = CGRectMake(100, 100, 52, 31);
    UIBarButtonItem *barBtnEditar =[[UIBarButtonItem alloc] initWithCustomView:btnEditar];
    [btnEditar addTarget:self action:@selector(editarFavoritos) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = barBtnEditar;
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"menuFavoritos" alter:nil];
    
    self.navigationItem.titleView = label;
    
    //TABELA
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background_DemaisTelas.png"]];
    [tabela setBackgroundView:imageView];
    [tabela setSeparatorColor:[UIColor clearColor]];
    
    //ITENS
    itens = [self getFavoritos];
}

- (NSMutableArray *) getFavoritos
{
    NSMutableArray *locais = [singleton estabelecimentos];
    NSMutableArray *favoritos = [singleton favoritos];
    NSMutableArray *new = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [favoritos count]; i++)
    {
        NSString *fav = [favoritos objectAtIndex:i];
        
        for (int l = 0; l < [locais count]; l++)
        {
            Estabelecimento *local = [locais objectAtIndex:l];
            if ([fav isEqualToString:[local estabelecimentoId]])
            {
                [new addObject:local];
            }
        }
    }
    
    return new;
}

- (void) backView
{
    [self.viewDeckController openLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            self.viewDeckController.centerController = [singleton principal];
        }
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
    }];
}

- (void) editarFavoritos
{
    if (!editarTAB)
    {
        editarTAB = TRUE;
        [tabela setEditing:TRUE animated:YES];
        
        UIBarButtonItem *editar = (UIBarButtonItem *) self.navigationItem.rightBarButtonItem;
        UIButton *btE = (UIButton *)[editar customView];
        [btE setTitle:@"Ok" forState:UIControlStateNormal];
        
    } else {
        
        editarTAB = FALSE;
        [tabela setEditing:FALSE animated:YES];
        
        UIBarButtonItem *editar = (UIBarButtonItem *) self.navigationItem.rightBarButtonItem;
        UIButton *btE = (UIButton *)[editar customView];
        [btE setTitle:[Language get:@"btnEditar" alter:nil] forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        [itens removeObjectAtIndex:[indexPath row]];
        
        [self atualizaFavoritos];
        
    }
    [tableView endUpdates];
}

- (void) atualizaFavoritos
{
    NSMutableArray *new = [[NSMutableArray alloc] init];
    for (int i = 0; i < [itens count]; i++)
    {
        Estabelecimento *local = [itens objectAtIndex:i];
        [new addObject:[local estabelecimentoId]];
    }
    
    [singleton setFavoritos:new];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[singleton favoritos] forKey:@"favoritos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"LugarCell";
    CellFavorito *cell = (CellFavorito *)[tableView dequeueReusableCellWithIdentifier:[CellFavorito reuseIdentifier]];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _customCell;
        [cell initCell];
        _customCell = nil;
    }
    
    // Set up the cell...
    Estabelecimento *item = [itens objectAtIndex:indexPath.row];
    
    //ALTERAR
    NSString *url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [item foto1]];
    [cell setThumbPhoto:url];
    
    if ([[item foto1] isEqualToString:@""])
    {
        [cell.lb_titulo setFrame:CGRectMake(22.0, 7.0, 250.0, 21.0)];
        [cell.lb_texto setFrame:CGRectMake(14.0, 22.0, 250.0, 34.0)];
        [cell.carregador setHidden:TRUE];
    }
    
    [cell.lb_titulo setText:[item nome]];
    [cell.lb_titulo setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    
    [cell.lb_texto setText:[item descricao]];
    [cell.lb_texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:11.0]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [singleton setEstabelecimentoATUAL:[itens objectAtIndex:[indexPath row]]];
    
    DetalheLugaresViewController *detailViewController = [[DetalheLugaresViewController alloc] initWithNibName:@"DetalheLugaresViewController_iPhone" bundle:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
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

@end
