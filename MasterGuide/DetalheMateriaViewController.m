//
//  DetalheMateriaViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "DetalheMateriaViewController.h"

#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#import "Language.h"
#import "MateriasViewController.h"

@interface DetalheMateriaViewController ()

@end

@implementation DetalheMateriaViewController
@synthesize texto = _texto;
@synthesize especial, singleton, materia;

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
    materia = [singleton materiaATUAL];
    
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
    CGRect frame = CGRectMake(0, 0, 120, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [materia titulo];
    
    self.navigationItem.titleView = label;
    
    if (especial) {
        [self addItemEspecial];
    } else {
        [self addItensNormal];
        [[self carregador] setHidden:TRUE];
    }
 
}

- (void) addItensNormal
{
    
    imageView = [[EGOImageView alloc] init];
    NSString *url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [materia foto]];
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 190.0);
    imageView.imageURL = [NSURL URLWithString:url];
    [self.scrollview addSubview:imageView];
    
    texto = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 200.0, 300.0, 600.0)];
    [texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:12.0]];
    [texto setTextColor:[UIColor whiteColor]];
    [texto setEditable:FALSE];
    [texto setScrollEnabled:FALSE];
    [texto setUserInteractionEnabled:FALSE];
    [texto setBackgroundColor:[UIColor clearColor]];
    
    [texto setText:[materia texto]];
    [self.scrollview addSubview:texto];
    
    self.scrollview.contentSize = CGSizeMake(320, 500);
	self.scrollview.delegate = self;
}

- (void) addItemEspecial
{
    imageView = [[EGOImageView alloc] init];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    [imageView setDelegate:self];
    
    NSString *url;
    
    if(result.height == 480)
    {
        url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", [materia fotoEspecial]];
        imageView.frame = CGRectMake(0.0f, 0.0f, 1919.0f, 370.0f);
        
        imageView.imageURL = [NSURL URLWithString:url];
        [self.scrollview addSubview:imageView];
        self.scrollview.contentSize = CGSizeMake(1919, 367);
        [self.scrollview setPagingEnabled:TRUE];
    }
    if(result.height == 568)
    {
        NSString *nome = [[materia fotoEspecial] substringToIndex:[[materia fotoEspecial] length] - 4];
        NSString *novo = [NSString stringWithFormat:@"%@@2x.png", nome];
        
        url = [[NSString alloc] initWithFormat:@"http://masterguide.lindolfolacerda.com.br/images/%@", novo];
        imageView.frame = CGRectMake(0.0f, 0.0f, 2354.0f, 454.0f);
        
        imageView.imageURL = [NSURL URLWithString:url];
        [self.scrollview addSubview:imageView];
        self.scrollview.contentSize = CGSizeMake(2354.0f, 454.0f);
    }
    
	self.scrollview.delegate = self;
}

- (void)imageViewLoadedImage:(EGOImageView *)imageView
{
    [[self carregador] setHidden:TRUE];
}

- (void) backView
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollview:nil];
    [super viewDidUnload];
}
@end
