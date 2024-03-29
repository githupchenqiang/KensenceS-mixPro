//
//  ProSetView.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/19.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "ProSetView.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
#import "ProConnect.h"
#import "SignalViewController.h"
#import "DataBaseHelp.h"
#import "Masonry.h"
#import "DataSqlite.h"

#import "SetTableViewController.h"
#define KscWith    self.view.frame.size.width
#define KscHeight  self.view.frame.size.height
#define WhitColor [UIColor whiteColor]

@interface ProSetView ()<GCDAsyncUdpSocketDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
}

@property (nonatomic ,strong)UIButton *ratioButton;
@property (nonatomic ,strong)UIButton *Spacebutton;
@property (nonatomic ,strong)UIButton *LightAdd;
@property (nonatomic ,strong)UIButton *LightCut;
@property (nonatomic ,strong)UIButton *contrastadd;
@property (nonatomic ,strong)UIButton *contrastCut;
@property (nonatomic ,strong)UIButton *chromaCut;
@property (nonatomic ,strong)UIButton *chromaAdd;
@property (nonatomic ,strong)UIButton *Saturation;
@property (nonatomic ,strong)UIButton *SaturationCut;
@property (nonatomic ,strong)UIButton *ZoomAdd;
@property (nonatomic ,strong)UIButton *ZoomCut;
@property (nonatomic ,strong)UIButton *ErectImage;
@property (nonatomic ,strong)UIButton *InvertedImage;
@property (nonatomic ,strong)UIButton *Reset;
@property (nonatomic ,strong)UIButton *Naming;
@property (nonatomic ,strong)UITextField *Nametext;
@property (nonatomic ,strong)UIButton *Cancle;
@property (nonatomic ,strong)UITableView *table;

@property (nonatomic ,assign)BOOL isDelop; //是否展开
@property (nonatomic ,strong)NSArray *Groups; //列表分组
@property (nonatomic ,strong)NSArray *Array;
@property (nonatomic ,strong)UITableView *Space;
@property (nonatomic ,strong)SetTableViewController *SpaceTable;
@property (nonatomic ,strong)NSString *NameString;//记录Pro的输入
@property (nonatomic ,strong)UIView *Aview;
@property (nonatomic ,strong)UITextField *IPText;
@property (nonatomic ,strong)UITextField *valeText;

@end

@implementation ProSetView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SignalValue ShareValue].isConnect = 0;
    [SignalValue ShareValue].IPstring = nil;
    [SignalValue ShareValue].ValueString = nil;

    NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].OutArray[0]];
    NSInteger key = NumberKey.integerValue;
    [DataSqlite CreatDataSource];
    [DataSqlite SelectByType:0 numberKey:key];
    
    self.preferredContentSize = CGSizeMake(KscWith/1.7, KscHeight/1.4);

    _Aview  = [[UIView alloc]init];
    _Aview.frame = CGRectMake(0, 0, KscWith, KscHeight);
    [self.view addSubview:_Aview];

    self.view.backgroundColor = [UIColor colorWithRed:41/255.0 green:51/255.0 blue:61/255.0 alpha:1];
    
    UIView *HeaderView = [[UIView alloc]init];
    HeaderView.frame = CGRectMake(0, 0, KscWith, 50);
    HeaderView.backgroundColor = [UIColor colorWithRed:31/255.0 green:39/255.0 blue:49/255.0 alpha:1];
    [_Aview addSubview:HeaderView];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(15, KscHeight/14+15, KscWith/17, KscHeight/19);
    label.text = NSLocalizedString(@"分辨率",@"");
    label.textColor = WhitColor;
    [_Aview addSubview:label];
    
    UILabel *space = [[UILabel alloc]init];
    space.frame = CGRectMake(15,CGRectGetMaxY(label.frame) +20, KscWith/15, KscHeight/19);
    space.text = NSLocalizedString(@"色彩空间",@"");
    space.textColor = WhitColor;
    [_Aview addSubview:space];
    
   _Groups = @[@"SD(480i)60  ",@"SD(576i)50  ",@"SD(480p)60  ",@"SD(576p)50  ",@"HD(720p)60  ",@"HD(720p)59  ",@"HD(720p)50  ",@"HD(720p)30  ",@"HD(720p)25  ",@"HD(720p)24  ",@"HD(1080i)60 ",@"HD(1080i)59 ",@"HD(1080i)50 ",@"HD(1080p)60 ",@"HD(1080p)59 ",@"HD(1080p)50 ",@"HD(1080p)30 ",@"HD(1080p)25 ",@"HD(1080p)24 ",@"MON(VGA)60 ",@"MON(VGA)75 ",@"MON(SVGA)60 ",@"MON(SVGA)75 ",@"MON(XGA)60 ",@"MON(XGA)75 ",@"MON(SXGA)60 ",@"MON(SXGA)75 ",@"1360x768p60 ",@"1366x768p60 ",@"1400x1050p60 ",@"1600x1200p60 ",@"1440x900p60 ",@"1440x900p75 ",@"1680x1050p60 ",@"1680x1050pRB ",@"1920x1080pRB ",@"1920x1200pRB ",@"1280x800p60"];
  
   
    _ratioButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _ratioButton.frame = CGRectMake(KscWith/9, KscHeight/14, KscWith/4, 40);
    _ratioButton.layer.borderColor = [UIColor blackColor].CGColor;
    _ratioButton.layer.borderWidth = 0.5f;
    [_ratioButton setTitle:NSLocalizedString(@"分辨率",@"") forState:UIControlStateNormal];
    [_ratioButton setTitleColor:WhitColor forState:UIControlStateNormal];
    UIImageView *FEnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *FENameimage = [UIImage imageNamed:@"TextBac"];
    FENameimage = [FENameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FEnameImageView.image = FENameimage;
    FEnameImageView.userInteractionEnabled = YES;
    [_Aview addSubview:FEnameImageView];
    [FEnameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
   [_ratioButton addTarget:self action:@selector(ratioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_ratioButton];
    [_ratioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
        }];

    UIImageView *RGCDnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *RGBNameimage = [UIImage imageNamed:@"TextBac"];
    RGBNameimage = [RGBNameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RGCDnameImageView.image = RGBNameimage;
    RGCDnameImageView.userInteractionEnabled = YES;
    [_Aview addSubview:RGCDnameImageView];
    [RGCDnameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(space.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    _Spacebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _Spacebutton.frame = CGRectMake(KscWith/9, CGRectGetMinY(space.frame), KscWith/4, 40);
    _Spacebutton.tag = 355555;
    [_Spacebutton setTitle:@"RGB" forState:UIControlStateNormal];
    [_Spacebutton setTitleColor:WhitColor forState:UIControlStateNormal];
     [_Spacebutton addTarget:self action:@selector(SpacebuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_Spacebutton];
    [_Spacebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(space.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    UILabel *light = [[UILabel alloc]init];
    light.frame = CGRectMake(15,CGRectGetMaxY(space.frame) +15, KscWith/15, KscHeight/19);
    light.text = NSLocalizedString(@"brightness",@"");
     light.textColor = WhitColor;
    [_Aview addSubview:light];
    
    UILabel *dui = [[UILabel alloc]init];
    dui.frame = CGRectMake(15,CGRectGetMaxY(light.frame) +15, KscWith/15, KscHeight/19);
    dui.text = NSLocalizedString(@"contrast",@"");
     dui.textColor = WhitColor;
    [_Aview addSubview:dui];
    
    UILabel *baohe = [[UILabel alloc]init];
    baohe.frame = CGRectMake(15,CGRectGetMaxY(dui.frame) +15, KscWith/15, KscHeight/19);
    baohe.text = NSLocalizedString(@"saturation",@"");
    baohe.textColor = WhitColor;
    [_Aview addSubview:baohe];
    
    UILabel *color = [[UILabel alloc]init];
    color.frame = CGRectMake(15,CGRectGetMaxY(baohe.frame) +15, KscWith/15, KscHeight/19);
    color.text = NSLocalizedString(@"chroma",@"");
     color.textColor = WhitColor;
    [_Aview addSubview:color];
    

    
    UILabel *zoom = [[UILabel alloc]init];
    zoom.frame = CGRectMake(15,CGRectGetMaxY(color.frame) +15, KscWith/15, KscHeight/19);
    zoom.text = NSLocalizedString(@"The zoom",@"");
     zoom.textColor = WhitColor;
    [_Aview addSubview:zoom];
  
    
    _LightAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _LightAdd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(space.frame)+15, KscWith/15, KscHeight/19);
    UIImage *imagelight = [UIImage imageNamed:@"ADD"];
    imagelight = [imagelight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_LightAdd setImage:imagelight forState:UIControlStateNormal];
      [_LightAdd addTarget:self action:@selector(LightAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_LightAdd];
    
    _LightCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _LightCut.frame = CGRectMake(CGRectGetMaxX(_LightAdd.frame)+10, CGRectGetMaxY(space.frame)+15, KscWith/15, KscHeight/19);
    UIImage *LightCut = [UIImage imageNamed:@"Remove"];
    LightCut = [LightCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_LightCut setImage:LightCut forState:UIControlStateNormal];
    [_LightCut addTarget:self action:@selector(LightCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_LightCut];
    
    _contrastadd = [UIButton buttonWithType:UIButtonTypeSystem];
    _contrastadd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(light.frame)+15, KscWith/15, KscHeight/19);
    UIImage *contrastadd = [UIImage imageNamed:@"ADD"];
    contrastadd = [contrastadd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_contrastadd setImage:contrastadd forState:UIControlStateNormal];
    [_contrastadd addTarget:self action:@selector(contrastaddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_contrastadd];
    

    _contrastCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _contrastCut.frame = CGRectMake(CGRectGetMaxX(_LightAdd.frame)+10, CGRectGetMaxY(light.frame)+15, KscWith/15, KscHeight/19);
    UIImage *contrastCut = [UIImage imageNamed:@"Remove"];
    contrastCut = [contrastCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_contrastCut setImage:contrastCut forState:UIControlStateNormal];
    [_contrastCut addTarget:self action:@selector(contrastCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_contrastCut];
    
    
    _Saturation = [UIButton buttonWithType:UIButtonTypeSystem];
    _Saturation.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(dui.frame)+15, KscWith/15, KscHeight/19);
    UIImage *Saturation = [UIImage imageNamed:@"ADD"];
    Saturation = [Saturation imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Saturation setImage:Saturation forState:UIControlStateNormal];
    [_Saturation addTarget:self action:@selector(SaturationAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_Saturation];
    
    
    
    _SaturationCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _SaturationCut.frame = CGRectMake(CGRectGetMaxX(_Saturation.frame)+10, CGRectGetMaxY(dui.frame)+15, KscWith/15, KscHeight/19);
    UIImage *SaturationCut = [UIImage imageNamed:@"Remove"];
    SaturationCut = [SaturationCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_SaturationCut setImage:SaturationCut forState:UIControlStateNormal];
     [_SaturationCut addTarget:self action:@selector(SaturationCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_SaturationCut];
    

    _chromaAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _chromaAdd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(baohe.frame)+15, KscWith/15, KscHeight/19);
    UIImage *chromaAdd = [UIImage imageNamed:@"ADD"];
    chromaAdd = [chromaAdd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chromaAdd setImage:chromaAdd forState:UIControlStateNormal];
      [_chromaAdd addTarget:self action:@selector(chromaAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_chromaAdd];
    
    
    _chromaCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _chromaCut.frame = CGRectMake(CGRectGetMaxX(_chromaAdd.frame) + 10, CGRectGetMaxY(baohe.frame)+15, KscWith/15, KscHeight/19);
    UIImage *chromaCut = [UIImage imageNamed:@"Remove"];
    chromaCut = [chromaCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chromaCut setImage:chromaCut forState:UIControlStateNormal];
    [_chromaCut addTarget:self action:@selector(chromaCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_chromaCut];
    
    
    
    _ZoomAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _ZoomAdd.frame = CGRectMake(CGRectGetMaxX(_chromaAdd.frame)+10, CGRectGetMaxY(color.frame)+15, KscWith/15, KscHeight/19);
    UIImage *ZoomAdd = [UIImage imageNamed:@"Remove"];
    ZoomAdd = [ZoomAdd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ZoomAdd setImage:ZoomAdd forState:UIControlStateNormal];
    [_ZoomAdd addTarget:self action:@selector(ZoomAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_ZoomAdd];
   
    
    _ZoomCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _ZoomCut.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(color.frame)+15, KscWith/15, KscHeight/19);
    UIImage *ZoomCut = [UIImage imageNamed:@"ADD"];
    ZoomCut = [ZoomCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ZoomCut setImage:ZoomCut forState:UIControlStateNormal];
    [_ZoomCut addTarget:self action:@selector(ZoomCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_ZoomCut];
    
    
    
    
    
    _ErectImage = [UIButton buttonWithType:UIButtonTypeSystem];
    _ErectImage.frame = CGRectMake(CGRectGetMaxX(_chromaCut.frame)+5, CGRectGetMaxY(baohe.frame)-20, KscWith/15, KscHeight/17);
    UIImage *ErectImage = [UIImage imageNamed:@"ButBack"];
    ErectImage = [ErectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ErectImage setBackgroundImage:ErectImage forState:UIControlStateNormal];
    [_ErectImage addTarget:self action:@selector(ErectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_ErectImage setTitle:NSLocalizedString(@"positive",@"") forState:UIControlStateNormal];
    [_ErectImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Aview addSubview:_ErectImage];
    [_ErectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(light.mas_top).with.offset(0);
        make.left.equalTo(_Spacebutton.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4/2 - 10);
        make.height.mas_equalTo(KscHeight * 0.065);
    }];
    
    
    _InvertedImage = [UIButton buttonWithType:UIButtonTypeSystem];
    _InvertedImage.frame = CGRectMake(CGRectGetMaxX(_ErectImage.frame)+5, CGRectGetMaxY(baohe.frame)-20, KscWith/15, KscHeight/17);
    UIImage *InvertedImage = [UIImage imageNamed:@"ButBack"];
    InvertedImage = [InvertedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_InvertedImage setBackgroundImage:InvertedImage forState:UIControlStateNormal];
    [_InvertedImage setTitle:NSLocalizedString(@"The horse",@"") forState:UIControlStateNormal];
    [_InvertedImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_InvertedImage addTarget:self action:@selector(InvertedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:_InvertedImage];
    [_InvertedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(light.mas_top).with.offset(0);
        make.left.equalTo(_ErectImage.mas_right).with.offset(20);
        make.width.mas_equalTo(KscWith/4/2 - 10);
        make.height.mas_equalTo(KscHeight * 0.065);
    }];
    
    UIImageView *IpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *Ipimage = [UIImage imageNamed:@"TextBac"];
    Ipimage = [Ipimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    IpImageView.image = Ipimage;
    IpImageView.userInteractionEnabled = YES;
    [_Aview addSubview:IpImageView];
    [IpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dui.mas_top).with.offset(0);
        make.left.equalTo(_ErectImage.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    _IPText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _IPText.placeholder = NSLocalizedString(@"H323Ip",@"");
    _IPText.text = [SignalValue ShareValue].IPstring;
    [_IPText setValue:[UIColor colorWithRed:42/255.0 green:50/255.0 blue:62/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_IPText setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _IPText.textColor = WhitColor;
    [IpImageView addSubview:_IPText];
    [_IPText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IpImageView.mas_top).with.offset(0);
        make.left.equalTo(IpImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    
    UIImageView *VAlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    UIImage *Valueimage = [UIImage imageNamed:@"TextBac"];
//    Valueimage = [Valueimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VAlueImageView.image = Ipimage;
    VAlueImageView.userInteractionEnabled = YES;
    [_Aview addSubview:VAlueImageView];
    [VAlueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baohe.mas_top).with.offset(0);
        make.left.equalTo(_ErectImage.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    _valeText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _valeText.placeholder = NSLocalizedString(@"bandwidth 256 ~ 4000",@"");
    _valeText.text = [SignalValue ShareValue].ValueString;
    [_valeText setValue:[UIColor colorWithRed:42/255.0 green:50/255.0 blue:62/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_valeText setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _valeText.textColor = WhitColor;
    [VAlueImageView addSubview:_valeText];
    [_valeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(VAlueImageView.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    UIButton *Callbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [Callbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    if ([SignalValue ShareValue].isConnect == NO) {
        [Callbutton setTitle:NSLocalizedString(@"call",@"") forState:UIControlStateNormal];
        UIImage *CallImge = [UIImage imageNamed:@"Call"];
        CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Callbutton setBackgroundImage:CallImge forState:UIControlStateNormal];
    }else
    {
        UIImage *CallImge = [UIImage imageNamed:@"Clear"];
        CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Callbutton setBackgroundImage:CallImge forState:UIControlStateNormal];
        [Callbutton setTitle:NSLocalizedString(@"Hang up",@"") forState:UIControlStateNormal];
    }
    
    [Callbutton addTarget:self action:@selector(CallAction:) forControlEvents:UIControlEventTouchDown];
    [_Aview addSubview:Callbutton];
    [Callbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(color.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(40);
    }];
    

    _Reset = [UIButton buttonWithType:UIButtonTypeSystem];
    _Reset.frame = CGRectMake(CGRectGetMaxX(_chromaCut.frame)+30, CGRectGetMaxY(color.frame)+10, KscWith/12, KscHeight/17);
    UIImage *Reset = [UIImage imageNamed:@"ButBack"];
    Reset = [Reset imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Reset setBackgroundImage:Reset forState:UIControlStateNormal];
    [_Reset addTarget:self action:@selector(ResetAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Reset setTitle:NSLocalizedString(@"reset",@"") forState:UIControlStateNormal];
    [_Reset setTitleColor:WhitColor forState:UIControlStateNormal];
    [_Aview addSubview:_Reset];
    [_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zoom.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    UIImageView *nameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *Nameimage = [UIImage imageNamed:@"TextBac"];
    Nameimage = [Nameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nameImageView.image = Nameimage;
    nameImageView.userInteractionEnabled = YES;
    [_Aview addSubview:nameImageView];
    [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zoom.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(_ZoomAdd.mas_right).with.offset(0);
        make.height.mas_equalTo(KscHeight * 0.06);
    }];
    
    
    _Nametext = [UITextField new];
    _Nametext.frame = CGRectMake(KscWith/15, CGRectGetMaxY(zoom.frame)+20, KscWith/5, 50);
    _Nametext.layer.borderColor = [UIColor blackColor].CGColor;
    _Nametext.layer.borderWidth = 0.5f;
    _Nametext.tag = 100000;
    _Nametext.delegate = self;
    _Nametext.placeholder = NSLocalizedString(@"Modify the name",@"");
    [_Nametext setValue:[UIColor colorWithRed:42/255.0 green:50/255.0 blue:62/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_Nametext setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
     _Nametext.textColor = WhitColor;
    [_Aview addSubview:_Nametext];
    [_Nametext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zoom.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(_ZoomAdd.mas_right).with.offset(0);
        make.height.mas_equalTo(KscHeight * 0.06);
    }];
    
    _Naming = [UIButton buttonWithType:UIButtonTypeSystem];
    _Naming.frame = CGRectMake(CGRectGetMaxX(_Nametext.frame)+10, CGRectGetMaxY(zoom.frame)+25, KscWith/15, KscHeight/19);
    UIImage *image1 = [UIImage imageNamed:@"ButBack"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Naming setBackgroundImage:image1  forState:UIControlStateNormal];
    [_Naming addTarget:self action:@selector(NamingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Naming setTitleColor:WhitColor forState:UIControlStateNormal];
    [_Naming setTitle:NSLocalizedString(@"named",@"") forState:UIControlStateNormal];
    [_Aview addSubview:_Naming];
    [_Naming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Nametext.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.06);
    }];
    
    
    _Cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    _Cancle.frame = CGRectMake(KscWith/2 - 55,5, 40, 40);
    _Cancle.tintColor = [UIColor whiteColor];
    UIImage *CanclaImage = [UIImage imageNamed:@"Cancle"];
    CanclaImage = [CanclaImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Cancle setBackgroundImage:CanclaImage forState:UIControlStateNormal];
    [_Cancle addTarget:self action:@selector(CancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderView addSubview:_Cancle];
    [_Cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    UILabel *Inlabel = [[UILabel alloc]init];
    Inlabel.frame = CGRectMake(5, 5, KscWith/8, 30);
    Inlabel.text = [NSString stringWithFormat:@"%@  %@",@"OutPut : ",[SignalValue ShareValue].OutArray[0]];
    Inlabel.textColor = [UIColor whiteColor];
    [_Aview addSubview:Inlabel];
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_ratioButton.frame), CGRectGetMaxY(_ratioButton.frame), KscWith/4,KscHeight/2) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _table.hidden = YES;
    [_Aview addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ratioButton.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight/2);
    }];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OutSpaceAction:) name:@"OutName" object:nil];
}


//呼叫事件
- (void)CallAction:(UIButton *)callbutton
{
    
    if (![self isValidateIP:_IPText.text]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.margin = 10.0f; //提示框的大小
            mbp.label.text = NSLocalizedString(@"IP input incorrect",@"");
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
        
        
       }else if([self isValidateIP:_IPText.text] && [self isRangeValue:_valeText.text.integerValue])
    {
        NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].OutArray[0]];
        NSInteger key = NumberKey.integerValue;
        [DataSqlite SelectByType:0 numberKey:key];
        
        if ([SignalValue ShareValue].isConnect == NO) {
            NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].OutArray[0]];
            NSInteger key = NumberKey.integerValue;
            [DataSqlite DeleteByType:0 numberKey:key];
            udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            unsigned char buf[1024] = {0};
            NSString *str = _valeText.text;
            unsigned short utfString = [str integerValue];
            NSString *DataString = [NSString stringWithFormat:@"echo \"<c><m>d</m><n>%@</n><b>%d</b></c>\" | socat - TCP:127.0.0.1:45678\r\n",_IPText.text,utfString];
            NSLog(@"%@",DataString);
            unsigned char bufData[1024];
            memcpy(bufData, [DataString cStringUsingEncoding:NSASCIIStringEncoding], 2*[DataString length]);
            NSInteger length = make_ctr_pack_5555(METHOD_SET, CARD_OUTPUT,[[SignalValue ShareValue].OutArray[0] integerValue],DataString.length,bufData,buf);
            NSData *data = [NSData dataWithBytes:(void *)&buf length:length];
            NSLog(@"ip:%@ port:%hu",[SignalValue ShareValue].SignalIpStr,[SignalValue ShareValue].SignalPort);
            [udpSocket sendData:data toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
            
            [DataSqlite InsertIntoType:0 NumberKey:key isConnect:1 IPString:_IPText.text valueWidth:_valeText.text];
            
            [callbutton setTitle:NSLocalizedString(@"Hang up",@"") forState:UIControlStateNormal];
            UIImage *CallImge = [UIImage imageNamed:@"Clear"];
            CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [callbutton setBackgroundImage:CallImge forState:UIControlStateNormal];
            
        }else
        {
            
            NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].OutArray[0]];
            NSInteger key = NumberKey.integerValue;
            udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            unsigned char buf[1024] = {0};
            NSString *DataString = @"echo \"<c><m>h</m></c>\" | socat - TCP:127.0.0.1:45678\r\n";
            unsigned char bufData[1024];
            memcpy(bufData, [DataString cStringUsingEncoding:NSASCIIStringEncoding], 2*[DataString length]);
            NSInteger length = make_ctr_pack_5555(METHOD_SET,CARD_OUTPUT,[[SignalValue ShareValue].OutArray[0]integerValue],DataString.length,bufData,buf);
            NSData *data = [NSData dataWithBytes:(void *)&buf length:length];
            [udpSocket sendData:data toHost:[SignalValue ShareValue].SignalIpStr port:4000 withTimeout:60 tag:544];
            UIImage *CallImge = [UIImage imageNamed:@"Call"];
            CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [callbutton setBackgroundImage:CallImge forState:UIControlStateNormal];
            [callbutton setTitle:NSLocalizedString(@"Call",@"") forState:UIControlStateNormal];
            [DataSqlite DeleteByType:0 numberKey:key];
            [DataSqlite InsertIntoType:0 NumberKey:key isConnect:0 IPString:_IPText.text valueWidth:_valeText.text];
            
        }

        
        
    }
    
    
}


//判断是否是Ip格式
- (BOOL)isValidateIP:(NSString *)IP
{
    NSString *ipRegex = @"(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)";
    NSPredicate *iptext = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegex];
    return [iptext evaluateWithObject:IP];
    
}


- (BOOL)isRangeValue:(NSInteger)value
{
    if (value < 512)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = NSLocalizedString(@"Input bandwidth value is too small Please enter the512~4000",@"");
            mbp.margin = 10.0f; //提示框的大小
            [mbp customView];
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
        return NO;
        
    }else if(value > 4000)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = NSLocalizedString(@"Beyond the maximum input bandwidth Please enter the512~4000",@"");
            mbp.margin = 10.0f; //提示框的大小
            [mbp customView];
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
        return NO;
        
    }else
    {
        return YES;
    }
}


- (void)OutSpaceAction:(NSNotification *)notice
{
    NSString *string = notice.userInfo[@"Out"];
    [_Spacebutton setTitle:string forState:UIControlStateNormal];
    _Spacebutton.titleLabel.font = [UIFont systemFontOfSize:21];
    
    _SpaceTable.view.hidden = YES;
    _Spacebutton.selected = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    return _Groups.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _Groups[indexPath.row];
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *number = _Groups[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",number];
    
    [_ratioButton setTitle:string forState:UIControlStateNormal];
    _ratioButton.titleLabel.font = [UIFont systemFontOfSize:21];
    _ratioButton.tintColor  = [UIColor blackColor];
    _table.hidden = YES;
    _ratioButton.selected = NO;
    
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    
    NSNumber *Anumber= [SignalValue ShareValue].OutArray[0];
    NSInteger integer = Anumber.integerValue;
    int a = (int)integer;
   
    NSInteger inte = indexPath.row;
    unsigned char bull = (unsigned char)inte;
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid,V_RESOLUTION_OUTPUT, 1,&bull , buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)CancleAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//分辨率
- (void)ratioButtonAction:(UIButton *)button
{   _SpaceTable.view.hidden = YES;
    
    if (button.selected == NO) {
        _table.hidden = NO;
        button.selected = YES;
        
    }else
    {
        _table.hidden = YES;
        button.selected = NO;
    }
  
}


//色彩空间
- (void)SpacebuttonAction:(UIButton *)button
{
    _table.hidden = YES;
    if (button.selected == NO) {
        self.SpaceTable = [SetTableViewController new];
        _SpaceTable.view.frame = CGRectMake(CGRectGetMinX(_ratioButton.frame), CGRectGetMaxY(_Spacebutton.frame), _Spacebutton.frame.size.width, KscHeight/2.8);
        [self.view addSubview:_SpaceTable.view];
        [self addChildViewController:_SpaceTable];
        button.selected = YES;
        
       
    }else
    {
        _SpaceTable.view.hidden = YES;
        button.selected = NO;
    }
   
    unsigned char buf[256] = {0};
    unsigned char num = 0;
//    int make_ctr_pack_5555(unsigned char METHOD_SET, unsigned char CARD_INPUT,unsigned char 9,unsigned short 3,unsigned char* cmd_parameter_data_in, unsigned char * buf_out);

    NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

- (void)CAmerAction:(UIButton *)button
{
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[1024] = {0};
    NSString *IpString = @"192.168.1.123";
    NSString *DataString = [NSString stringWithFormat:@"echo \"<c><m>d</m><n>%@</n><b>2000</b></c>\" | socat - TCP:127.0.0.1:45678\r\n",IpString];
    unsigned char bufData[1024];
    memcpy(bufData, [DataString cStringUsingEncoding:NSASCIIStringEncoding], 2*[DataString length]);
    NSInteger length = make_ctr_pack_5555(METHOD_SET, CARD_INPUT,9,DataString.length,bufData,buf);
    NSData *data = [NSData dataWithBytes:(void *)&buf length:length];
    NSLog(@"ip:%@ port:%hu",[SignalValue ShareValue].SignalIpStr,[SignalValue ShareValue].SignalPort);
    [udpSocket sendData:data toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    NSLog(@"%@",data);
    
}

- (void)DisConnect:(UIButton *)button
{
   
}


//命名
- (void)NamingAction:(UIButton *)button
{
    _NameString = @"";
    
    UITextField *textfield = (UITextField *)[self.view viewWithTag:100000];
    NSString *string = textfield.text;
    
    [[SignalValue ShareValue].OutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = obj;
        NSInteger integer = number.integerValue;
        UIButton *button = [self.view viewWithTag:599+integer+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
        NSString *Nstring = [NSString stringWithFormat:@"%ld",(long)integer+599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
        [[SignalValue ShareValue].OutArray removeObject:obj];
        [[SignalViewController new].RemoveArray removeObject:obj];
        if (string.length <= 0) {
            
            [button setTitle:[NSString stringWithFormat:@"%ld",(long)integer] forState:UIControlStateNormal];
            
            unsigned char integertag = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integertag type:tage Key:Nstring];
            [DataBaseHelp InsertIntoTemp:integertag Type:tage Key:Nstring Values:[NSString stringWithFormat:@"%ld",(long)integer]];
            [[SignalValue ShareValue].OutArray removeAllObjects];
            _NameString = [NSString stringWithFormat:@"%ld",(long)integer];
            
            
        }else if (string.length >= 5){
            
            NSString *str = [string substringToIndex:5];
            [button setTitle:str forState:UIControlStateNormal];
            unsigned char integertag = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integertag type:tage Key:Nstring];
            [DataBaseHelp InsertIntoTemp:integertag Type:tage Key:Nstring Values:str];
            [DataBaseHelp SelectTemp:integertag Type:tage];
          
            [[SignalValue ShareValue].OutArray removeAllObjects];
            _NameString = str;
            
            
        }else
        {
            
            [button setTitle:string forState:UIControlStateNormal];
            _NameString = string;
            
            
            unsigned char integertag = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integertag type:tage Key:Nstring];
            [DataBaseHelp InsertIntoTemp:integertag Type:tage Key:Nstring Values:string];
            [[SignalValue ShareValue].OutArray removeAllObjects];
        }
        [[SignalValue ShareValue].OutArray removeAllObjects];
        
    }];
    [[SignalValue ShareValue].OutArray removeAllObjects];

    //创建通知
    NSDictionary *dict = @{@"Name":_NameString};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textname" object:nil userInfo:dict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

//亮度加
- (void)LightAddAction:(UIButton *)button
{

    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char in_parameter = 1;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_BRIGHTNESS_UP_DOWN, 1, &in_parameter, buf);
        NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//亮度减
- (void)LightCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char in_parameter = 0;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET,CARD_OUTPUT,cardid, V_BRIGHTNESS_UP_DOWN, 1, &in_parameter, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    
    
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//对比度减
- (void)contrastCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid,V_CONTRAST_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
 //   [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//对比度加
- (void)contrastaddAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
  
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_CONTRAST_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
    
}

//饱和度加
- (void)SaturationAction:(UIButton *)button
{
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_SATURATION_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
 //   [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
}

//饱和度减
- (void)SaturationCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_SATURATION_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
}

//色度加
- (void)chromaAddAction:(UIButton *)button
{
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_HUE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
}

//色度减
- (void)chromaCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_HUE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//正像
- (void)ErectImageAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_ZOOM_IMAGE_MIRROR, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}


//倒像
- (void)InvertedImageAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_ZOOM_IMAGE_MIRROR, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//复位

- (void)ResetAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0x01;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, C_SYSTEM_RESET, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//缩放+

- (void)ZoomAddAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
  
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_ZOOM_IMAGE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}


//缩放-
- (void)ZoomCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].OutArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
 
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid, V_ZOOM_IMAGE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}


#pragma mark ===创建socket=====
- (void)ShowUdpSocket
{
    //初始化对象，使用全局队列
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}


#pragma mark === udpSocket执行的代理方法=======
//发送成功34
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 544) {
        NSLog(@"标记为200的数据发送完成了");
    }
}
//发送失败
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag,error);
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    

    _Aview.frame = CGRectMake(_Aview.frame.origin.x, _Aview.frame.origin.y - 158, _Aview.frame.size.width, _Aview.frame.size.height);
    

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
   _Aview.frame = CGRectMake(_Aview.frame.origin.x, _Aview.frame.origin.y+158, _Aview.frame.size.width, _Aview.frame.size.height);
  

}


@end
