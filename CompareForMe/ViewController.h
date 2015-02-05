//
//  ViewController.h
//  CompareForMe
//
//  Created by Narlei Moreira on 02/02/15.
//  Copyright (c) 2015 NarleiMoreira. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>
@property (nonatomic,strong) NSMutableArray *arquivosEsquerda;
@property (nonatomic,strong) NSMutableArray *arquivosDireita;
@property (nonatomic,strong) NSMutableArray *arquivos;
@property (weak) IBOutlet NSTableView *tableViewLeft;

@property (weak) IBOutlet NSPathControl *pathControlLeft;
@property (weak) IBOutlet NSPathControl *pathControlRight;
@property (weak) IBOutlet NSTextField *labelTotalArquivosLeft;
@property (weak) IBOutlet NSTextField *labelTotalArquivosRight;
@property (weak) IBOutlet NSProgressIndicator *progress;
- (IBAction)buttonCompararPressed:(id)sender;
@property (weak) IBOutlet NSTextFieldCell *labelNomeArquivoLeft;
@property (weak) IBOutlet NSTextFieldCell *labelNomeArquivoRight;
- (IBAction)abrirArquivoRight:(id)sender;
- (IBAction)abrirArquivoLeft:(id)sender;
@property (weak) IBOutlet NSButtonCell *buttonAbrirLeft;

- (IBAction)buttonAbrirLeftPressed:(id)sender;
- (IBAction)buttonAbrirRightPressed:(id)sender;



@end

