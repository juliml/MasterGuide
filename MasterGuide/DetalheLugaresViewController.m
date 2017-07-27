//
//  DetalheLugaresViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "DetalheLugaresViewController.h"
#import "IIViewDeckController.h"

#import "Language.h"
#import "DTCustomColoredAccessory.h"
#import "CompartilhaViewController.h"

#import "MapaLocalViewController.h"
#import "Endereco.h"

#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface DetalheLugaresViewController ()

@end

@implementation DetalheLugaresViewController
@synthesize singleton, texto, telefoneSelecionado;
@synthesize local, images, pageControl;

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
    UIBarButtonItem *botao = (UIBarButtonItem *) self.navigationItem.leftBarButtonItem;
    UIButton *bt = (UIButton *)[botao customView];
    [bt setTitle:[Language get:@"btnVoltar" alter:nil] forState:UIControlStateNormal];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    local = [singleton estabelecimentoATUAL];
    
    listaEnderecos = [local endereco];
    
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
    
    //BOTAO SHARED
    UIButton *btnShare =[[UIButton alloc] init];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"Btn_Enviar.png"] forState:UIControlStateNormal];
    
    btnShare.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnShare =[[UIBarButtonItem alloc] initWithCustomView:btnShare];
    [btnShare addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = barBtnShare;
    
    [self.texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:12.0]];
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 120, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [local nome];
    
    self.navigationItem.titleView = label;
    
    //VERIFICA FAVORITO
    CompartilhaViewController *compartilha = (CompartilhaViewController *)[[self.navigationController viewDeckController]  rightController];
    [compartilha checkFavorito];
    
    self.scrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addComponents];
    
    [self.tabela setBackgroundColor:[UIColor clearColor]];
    [self.tabela setSeparatorColor:[UIColor clearColor]];
}

- (void) addComponents
{
    arrayImages = [[NSMutableArray alloc] init];
    
    if (![[local foto1] isEqual:@""])
    {
        NSString *url1 = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [local foto1]];
        [arrayImages addObject:url1];
    }
    
    if (![[local foto2] isEqual:@""])
    {
        NSString *url2 = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [local foto2]];
        [arrayImages addObject:url2];
    }
    
    if (![[local foto3] isEqual:@""])
    {
        NSString *url3 = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [local foto3]];
        [arrayImages addObject:url3];
    }
    
    if ([arrayImages count] > 0)
    {
        // a page is the width of the scroll view
        images = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 190)];
        images.pagingEnabled = YES;
        images.contentSize = CGSizeMake(320 * [arrayImages count], 190.0);
        images.showsHorizontalScrollIndicator = NO;
        images.showsVerticalScrollIndicator = NO;
        images.scrollsToTop = NO;
        images.delegate = self;
        
        [self.scrollview addSubview:images];
        
        for (int i=0; i < [arrayImages count]; i++) {
            
            EGOImageView *img = [[EGOImageView alloc] init];
            img.frame = CGRectMake(i*320, 0.0, 320, 190);
            img.imageURL = [NSURL URLWithString:[arrayImages objectAtIndex:i]];
            
            [images addSubview:img];
        }
        
        if ([arrayImages count] > 1) {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 185, 320, 36)];
            pageControl.numberOfPages = [arrayImages count];
            pageControl.currentPage = 0;
            [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
            
            [self.scrollview addSubview:pageControl];
        }
        
        texto = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 210.0, 300.0, 200.0)];
        [texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:12.0]];
        [texto setTextColor:[UIColor whiteColor]];
        [texto setEditable:FALSE];
        [texto setScrollEnabled:FALSE];
        [texto setUserInteractionEnabled:FALSE];
        [texto setBackgroundColor:[UIColor clearColor]];
        
        [texto setText:[local descricao]];
        
        CGRect frame = texto.frame;
        frame.size.height = texto.contentSize.height;
        texto.frame = frame;
        
        [self.scrollview addSubview:texto];
        
        int posTab = 200 + texto.contentSize.height + 10;
        self.tabela.frame = CGRectMake(0.0, posTab, 320.0, 400.0);
        
        self.scrollview.contentSize = CGSizeMake(320, 750);
        
    } else {

        texto = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 200.0)];
        [texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:12.0]];
        [texto setTextColor:[UIColor whiteColor]];
        [texto setEditable:FALSE];
        [texto setScrollEnabled:FALSE];
        [texto setUserInteractionEnabled:FALSE];
        [texto setBackgroundColor:[UIColor clearColor]];
        
        [texto setText:[local descricao]];
        
        CGRect frame = texto.frame;
        frame.size.height = texto.contentSize.height;
        texto.frame = frame;
        
        [self.scrollview addSubview:texto];
        
        int posTab = 20 + texto.contentSize.height + 10;
        self.tabela.frame = CGRectMake(0.0, posTab, 320.0, 400.0);
        
        self.scrollview.contentSize = CGSizeMake(320, 600);
        
    }
    
}

- (IBAction)pageChange:(id)sender
{
    CGRect frame = images.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [images scrollRectToVisible:frame animated:TRUE];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
    int page = sv.contentOffset.x / sv.frame.size.width;
    pageControl.currentPage = page;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	if(!newSuperview) {
		//[imageView cancelImageLoad];
	}
}

- (void) backView
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark TABLE

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listaEnderecos count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,42)];
    
    UIImageView *fundo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 42)];
    [fundo setImage:[UIImage imageNamed:@"Cell_Telefone_Local.png"]];
    [tempView addSubview:fundo];
    
    UILabel *titulo = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 8.0, 220.0, 30.0)];
    [titulo setText:[Language get:@"btnTelefone" alter:nil]];
    [titulo setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    [titulo setTextColor:[UIColor whiteColor]];
    [titulo setBackgroundColor:[UIColor clearColor]];
    [tempView addSubview:titulo];
    
    UIImageView *icone = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 33.0, 33.0)];
    [icone setImage:[UIImage imageNamed:@"icon_Telefone.png"]];
    [tempView addSubview:icone];

    return tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Endereco *end = [listaEnderecos objectAtIndex:[indexPath row]];
    
    UIImageView *fundo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 72)];
    [fundo setImage:[UIImage imageNamed:@"Cell_Telefone_mais_endereo.png"]];
    [cell addSubview:fundo];
    
    UIImageView *seta = [[UIImageView alloc] initWithFrame:CGRectMake(290.0, 29.0, 10, 14)];
    [seta setImage:[UIImage imageNamed:@"Cell_Seta.png"]];
    [cell addSubview:seta];
    
    NSString *completo = [[NSString alloc] initWithFormat:@"%@, %@, %@, %@", [end endereco], [end numero], [end bairro], [end cidade]];
    
    UILabel *endereco = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 270.0, 30.0)];
    [endereco setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    [endereco setTextColor:[UIColor whiteColor]];
    [endereco setTag:1];
    [endereco setBackgroundColor:[UIColor clearColor]];
    [endereco setText:completo];
    
    NSMutableArray *fones = [end telefones];
    NSString *fone = [[NSString alloc] init];
   /* for (int i = 0; i < [fones count]; i++) {
        fone = [fone stringByAppendingString:[NSString stringWithFormat:@" %@", [fones objectAtIndex:i]]];
    }*/
    if ([fones count] > 0) fone = [fones objectAtIndex:0];
    
    UILabel *telefone = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30, 320, 30)];
    [telefone setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    [telefone setTextColor:[UIColor whiteColor]];
    [telefone setTag:2];
    [telefone setBackgroundColor:[UIColor clearColor]];
    [telefone setText:fone];
    
    [cell addSubview:endereco];
    [cell addSubview:telefone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    Endereco *item = [listaEnderecos objectAtIndex:[indexPath row]];
    
    MapaLocalViewController *mapa = [[MapaLocalViewController alloc] initWithNibName:@"MapaLocalViewController_iPhone" bundle:nil];
    [mapa setEndereco:item];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *categoria = [f numberFromString:[local categoriaId]];

    NSString *anuncio = [local anuncioPago];
    if ([anuncio isEqualToString:@"1"]) categoria = [NSNumber numberWithFloat:([categoria floatValue] + 8.0)];
    
    [mapa setCategoria:categoria];
    [mapa setTitulo:[local nome]];
    
    [self.navigationController pushViewController:mapa animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
