//
//  DetalheAjustesViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "DetalheAjustesViewController.h"

@interface DetalheAjustesViewController ()

@end

@implementation DetalheAjustesViewController
@synthesize titulo;
@synthesize campoNome;
@synthesize campoSenha;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //BOTAO BACK
    UIButton *btnBack =[[UIButton alloc] init];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Btn_Voltar.png"] forState:UIControlStateNormal];
    [btnBack setTitle:@"Voltar" forState:UIControlStateNormal];
    [[btnBack titleLabel] setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    btnBack.frame = CGRectMake(100, 100, 58, 31);
    UIBarButtonItem *barBtnBack =[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [btnBack addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnBack;
    
    //BOTAO OK
    UIButton *btnOk =[[UIButton alloc] init];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"Btn_Ok.png"] forState:UIControlStateNormal];
    [btnOk setTitle:@"Ok" forState:UIControlStateNormal];
    [[btnOk titleLabel] setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    btnOk.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    
    btnOk.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnOk =[[UIBarButtonItem alloc] initWithCustomView:btnOk];
    [btnOk addTarget:self action:@selector(gravaDados) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = barBtnOk;
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = titulo;
    
    self.navigationItem.titleView = label;
}

- (void) backView
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void) gravaDados
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)viewDidUnload
{
    [self setCampoNome:nil];
    [self setCampoSenha:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
