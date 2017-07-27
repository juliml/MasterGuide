//
//  MateriasViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "MateriasViewController.h"
#import "DetalheMateriaViewController.h"

#import "Language.h"
#import "Materia.h"

@interface MateriasViewController ()

@end

@implementation MateriasViewController
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
    [self checkMaterias];
    
    UILabel *titulo = (UILabel *) self.navigationItem.titleView;
    titulo.text = [Language get:@"materiasHome" alter:nil];
    
    UIBarButtonItem *botao = (UIBarButtonItem *) self.navigationItem.leftBarButtonItem;
    UIButton *bt = (UIButton *)[botao customView];
    [bt setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];

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
    label.text = [Language get:@"materiasHome" alter:nil];
    
    self.navigationItem.titleView = label;
    
    itens = [[NSMutableArray alloc] init];
    
    if ([itens count] == 0)
    {
        NSLog(@"NAO EXITE MATERIAS");
        
        connectionJSON = [[JSONFetcher alloc] init];
        [connectionJSON setDelegate:self];
        [connectionJSON queryServiceWithParent:@"http://masterguide.lindolfolacerda.com.br/jsonNoticias.php"];
        
        //PROGRESS
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
    }
    
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
            Materia *materia = [[Materia alloc] init];
            
            [materia setIdiomaId:[item objectForKey:@"idiomaId"]];
            [materia setTitulo:[item objectForKey:@"titulo"]];
            [materia setTexto:[item objectForKey:@"texto"]];
            [materia setFoto:[item objectForKey:@"foto"]];
            [materia setSite:[item objectForKey:@"site"]];
            [materia setEspecial:[item objectForKey:@"especial"]];
            [materia setFotoEspecial:[item objectForKey:@"foto_especial"]];
            
            [dados addObject:materia];
        }
        
        [singleton setNoticias:dados];
        [self checkMaterias];
    }
}

- (void) checkMaterias
{
    NSMutableArray *materias = [singleton noticias];
    [itens removeAllObjects];
    
    for (int y = 0; y < [materias count]; y++)
    {
        Materia *materia = [materias objectAtIndex:y];
        
        if ([[materia idiomaId] intValue] == [singleton idioma])
        {
            [itens addObject:materia];
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
 
    static NSString *CellIdentifier = @"MateriaCell";
    CellMateria *cell = (CellMateria *)[tableView dequeueReusableCellWithIdentifier:[CellMateria reuseIdentifier]];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _customCell;
        [cell initCell];
        _customCell = nil;
    }
    
    // Set up the cell...
    Materia *materia = [itens objectAtIndex:indexPath.row];
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [materia foto]];
    [cell setThumbPhoto:url];
    
    if ([[materia foto] isEqualToString:@""])
    {
        [cell.titulo setFrame:CGRectMake(22.0, 7.0, 250.0, 21.0)];
        [cell.texto setFrame:CGRectMake(14.0, 22.0, 250.0, 34.0)];
        [cell.carregador setHidden:TRUE];
    }
    
    [cell.titulo setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    cell.titulo.text = [materia titulo];
    
    [cell.texto setFont:[UIFont fontWithName:@"Zeppelin 33" size:11.0]];
    cell.texto.text = [materia texto];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // NSDictionary *item = [itens objectAtIndex:[indexPath row]];
    
    Materia *mat = [itens objectAtIndex:[indexPath row]];
    [singleton setMateriaATUAL:mat];
    
    DetalheMateriaViewController *materia = [[DetalheMateriaViewController alloc] initWithNibName:@"DetalheMateriaViewController_iPhone" bundle:nil];
    
    if ([[mat especial] isEqualToString:@"1"]) [materia setEspecial:TRUE];
    else [materia setEspecial:FALSE];
    
    [self.navigationController pushViewController:materia animated:YES];
    
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
