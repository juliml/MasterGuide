//
//  TelefonesViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "TelefonesViewController.h"
#import "IIViewDeckController.h"
#import "CellTelefone.h"

#import "Language.h"
#import "IIViewDeckController.h"

@interface TelefonesViewController ()

@end

@implementation TelefonesViewController
@synthesize singleton, tabela, telefone, connectionJSON;

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
    label.text = [Language get:@"menuTelefones" alter:nil];
    
    UIBarButtonItem *botao = (UIBarButtonItem *) self.navigationItem.leftBarButtonItem;
    UIButton *bt = (UIButton *)[botao customView];
    [bt setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];
    
    [self checkTelefones];
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
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"menuTelefones" alter:nil];
    
    self.navigationItem.titleView = label;
    
    itens = [[NSMutableArray alloc] init];
    
    connectionJSON = [[JSONFetcher alloc] init];
    [connectionJSON setDelegate:self];
    [connectionJSON queryServiceWithParent:@"http://masterguide.lindolfolacerda.com.br/jsonTelefonesUteis.php"];
    
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
        NSMutableArray *dados = [[NSMutableArray alloc] init];
        [HUD hide:YES];
        
        for (int i = 0; i < [data count]; i++)
        {
            NSDictionary *item = [data objectAtIndex:i];
            [dados addObject:item];
        }
        
        [singleton setTelefones:dados];
        [self checkTelefones];
    }
}

- (void) checkTelefones
{
    NSMutableArray *telefones = [singleton telefones];
    [itens removeAllObjects];
    
    for (int y = 0; y < [telefones count]; y++)
    {
        NSDictionary *tel = [telefones objectAtIndex:y];
        
        if ([[tel objectForKey:@"idiomaId"] intValue] == [singleton idioma])
        {
            [itens addObject:tel];
        }
    }
    
    [tabela reloadData];
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
    
    static NSString *CellIdentifier = @"TelefoneCell";
    CellTelefone *cell = (CellTelefone *)[tableView dequeueReusableCellWithIdentifier:[CellTelefone reuseIdentifier]];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _customCell;
        _customCell = nil;
    }
    
    // Set up the cell...
    NSDictionary *cellValue = [itens objectAtIndex:indexPath.row];
    
    [cell.lb_nome setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    cell.lb_nome.text = [cellValue objectForKey:@"nome"];
    
    [cell.lb_fone setFont:[UIFont fontWithName:@"Zeppelin 33" size:11.0]];
    cell.lb_fone.text = [cellValue objectForKey:@"numero"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [itens objectAtIndex:[indexPath row]];
    telefone = [item objectForKey:@"numero"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertaLigarTitulo" alter:nil] message:[Language get:@"alertaLigarTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        NSString *numero = [NSString stringWithFormat:@"tel:%@", telefone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numero]];
    }
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
