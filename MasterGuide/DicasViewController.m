//
//  DicasViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "DicasViewController.h"
#import "Language.h"

#import "DetalheLugaresViewController.h"

@interface DicasViewController ()

@end

@implementation DicasViewController
@synthesize tabela, singleton;

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
    titulo.text = [Language get:@"dicasHome" alter:nil];
    
    UIBarButtonItem *botao = (UIBarButtonItem *) self.navigationItem.leftBarButtonItem;
    UIButton *bt = (UIButton *)[botao customView];
    [bt setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];
    
    itens = [self getEstabelecimentos];
    [tabela reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    [singleton setCallMenu:FALSE];
    
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
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"dicasHome" alter:nil];
    
    self.navigationItem.titleView = label;
    
    //ITENS
    itens = [self getEstabelecimentos];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background_DemaisTelas.png"]];
    [tabela setBackgroundView:imageView];
    [tabela setSeparatorColor:[UIColor clearColor]];
}

- (NSMutableArray *) getEstabelecimentos
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *dados = [singleton estabelecimentos];
    
    for (int i = 0; i < [dados count]; i++)
    {
        Estabelecimento *local = [dados objectAtIndex:i];
        
        if ([[local anuncioPago] isEqualToString:@"1"] &&
            [[local idiomaId] isEqualToString:[NSString stringWithFormat:@"%d", singleton.idioma]])
        {
            [array addObject:local];
        }
    }
    
    return array;
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
    
   static NSString *CellIdentifier = @"DicasCell";
    CellDicas *cell = (CellDicas *)[tableView dequeueReusableCellWithIdentifier:[CellDicas reuseIdentifier]];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _customCell;
        [cell initCell];
        _customCell = nil;
    }
    
    Estabelecimento *item = [itens objectAtIndex:indexPath.row];
    
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
    // Navigation logic may go here. Create and push another view controller.
   // NSDictionary *item = [itens objectAtIndex:[indexPath row]];

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
