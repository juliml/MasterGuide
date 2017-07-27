//
//  CidadeViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "CidadeViewController.h"
#import "IIViewDeckController.h"
#import "Cidade.h"

@interface CidadeViewController ()

@end

@implementation CidadeViewController
@synthesize texto, singleton, connectionJSON, cidade, images, pageControl, arrayImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self addComponents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    singleton = [SingletonManager sharedController];
    
    //BOTAO MENU
    UIButton *btnMenu =[[UIButton alloc] init];
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"NavBar_MenuBtn.png"] forState:UIControlStateNormal];
    
    btnMenu.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnMenu =[[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    [btnMenu addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnMenu;
    [[self.tabBarController viewDeckController] setEnabled:FALSE];
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 120, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"São Paulo";

    self.navigationItem.titleView = label;
    
    connectionJSON = [[JSONFetcher alloc] init];
    [connectionJSON setDelegate:self];
    [connectionJSON queryServiceWithParent:@"http://masterguide.lindolfolacerda.com.br/jsonCidades.php?cidadeId=1"];
    
    //PROGRESS
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    //[self addComponents];
    
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
            
            Cidade *cid = [[Cidade alloc] init];
            [cid setCidadeID:[item objectForKey:@"cidadeId"]];
            [cid setIdiomaID:[item objectForKey:@"idiomaId"]];
            [cid setEstadoID:[item objectForKey:@"estadoId"]];
            
            [cid setNome:[item objectForKey:@"nome"]];
            [cid setDescricao:[item objectForKey:@"descricao"]];
            [cid setFoto1:[item objectForKey:@"foto1"]];
            [cid setFoto2:[item objectForKey:@"foto2"]];
            [cid setFoto3:[item objectForKey:@"foto3"]];
            
            [dados addObject:cid];
        }
        
        [singleton setCidade:dados];
        [self addComponents];
    }
}

- (void) addComponents
{
    for(UIView *subview in [self.scrollview subviews]) {
        [subview removeFromSuperview];
    }
    
    NSMutableArray *dados = [singleton cidade];
    
    for (int y = 0; y < [dados count]; y++)
    {
        Cidade *cid = [dados objectAtIndex:y];
        
        if ([[cid idiomaID] intValue] == [singleton idioma]) {
            cidade = cid;
        }
    }
    
    arrayImages = [[NSMutableArray alloc] init];
    
    if (![[cidade foto1] isEqual:@""])
    {
        NSString *url1 = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [cidade foto1]];
        [arrayImages addObject:url1];
    }
    
    if (![[cidade foto2] isEqual:@""])
    {
        NSString *url2 = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [cidade foto2]];
        [arrayImages addObject:url2];
    }
    
    if (![[cidade foto3] isEqual:@""])
    {
        NSString *url3 = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [cidade foto3]];
        [arrayImages addObject:url3];
    }

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
    
    texto = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 210.0, 300.0, 500.0)];
    [texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:12.0]];
    [texto setTextColor:[UIColor whiteColor]];
    [texto setEditable:FALSE];
    [texto setScrollEnabled:FALSE];
    [texto setUserInteractionEnabled:FALSE];
    [texto setBackgroundColor:[UIColor clearColor]];
    
    [texto setText:[cidade descricao]];
    [self.scrollview addSubview:texto];
    
    self.scrollview.contentSize = CGSizeMake(320, 500);
    self.scrollview.contentOffset = CGPointMake(0.0, 0.0);
	//self.scrollview.delegate = self;
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
	[self willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		//[imageView cancelImageLoad];
	}
}

- (void)viewDidUnload
{
    [self setTexto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
