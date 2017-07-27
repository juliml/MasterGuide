//
//  ParceirosViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "ParceirosViewController.h"
#import "ParceiroSiteViewController.h"

#import "Language.h"

@interface ParceirosViewController ()

@end

@implementation ParceirosViewController
@synthesize tabela, connectionJSON, singleton;

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
    UILabel *titulo = (UILabel *) self.navigationItem.titleView;
    titulo.text = [Language get:@"parceirosHome" alter:nil];
    
    UIBarButtonItem *botao = (UIBarButtonItem *) self.navigationItem.leftBarButtonItem;
    UIButton *bt = (UIButton *)[botao customView];
    [bt setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];
    
    [self checkParceiros];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    
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
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"parceirosHome" alter:nil];
    
    self.navigationItem.titleView = label;
    
    //TABELA
    
    itens = [[NSMutableArray alloc] init];
    
    connectionJSON = [[JSONFetcher alloc] init];
    [connectionJSON setDelegate:self];
    [connectionJSON queryServiceWithParent:@"http://masterguide.lindolfolacerda.com.br/jsonParceiros.php"];
    
    //PROGRESS
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background_DemaisTelas.png"]];
    [tabela setBackgroundView:imageView];
    [tabela setSeparatorColor:[UIColor clearColor]];
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
            [dados addObject:item];
        }
        
        [singleton setParceios:dados];
        [self checkParceiros];
    }
    
    [tabela reloadData];
}

- (void) checkParceiros;
{
    NSMutableArray *dados = [singleton parceios];
    [itens removeAllObjects];
    
    for (int y = 0; y < [dados count]; y++)
    {
        NSDictionary *parceiro = [dados objectAtIndex:y];
        
        if ([[parceiro objectForKey:@"idiomaId"] intValue] == [singleton idioma]) {
            [itens addObject:parceiro];
        }
    }
    
    [tabela reloadData];
}

- (void) backView
{
    [[self navigationController] popViewControllerAnimated:TRUE];
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
    
    static NSString *CellIdentifier = @"ParceiroCell";
    CellParceiro *cell = (CellParceiro *)[tableView dequeueReusableCellWithIdentifier:[CellParceiro reuseIdentifier]];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _customCell;
        [cell initCell];
        _customCell = nil;
    }
    
    // Set up the cell...
    NSDictionary *item = [itens objectAtIndex:indexPath.row];
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [item objectForKey:@"logomarca"]];
    [cell setThumbPhoto:url];
    
    if ([[item objectForKey:@"logomarca"] isEqualToString:@""])
    {
        [cell.titulo setFrame:CGRectMake(22.0, 24.0, 250.0, 21.0)];
        [cell.carregador setHidden:TRUE];
    }

    [cell.titulo setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    cell.titulo.text = [item objectForKey:@"nome"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [itens objectAtIndex:[indexPath row]];
    
    ParceiroSiteViewController *site = [[ParceiroSiteViewController alloc] initWithNibName:@"ParceiroSiteViewController_iPhone" bundle:nil];

    [site setTxtTitulo:[item objectForKey:@"nome"]];
    [site setTxtLink:[item objectForKey:@"site"]];
    [site setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:site animated:YES completion:nil];
    //[self presentModalViewController:site animated:YES];
    
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
