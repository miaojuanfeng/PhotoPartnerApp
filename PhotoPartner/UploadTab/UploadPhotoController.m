//
//  UploadPhotoController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "UploadPhotoController.h"

@interface UploadPhotoController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;
@end

@implementation UploadPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"uploadPhotoNavigationItemTitle", nil);
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"uploadPhotoRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, 100)];
//    textView.backgroundColor = [UIColor redColor];
    textView.font = [UIFont fontWithName:@"AppleGothic" size:16.0];
    [self.view addSubview:textView];
    
    UIView *mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(textView)+GET_LAYOUT_HEIGHT(textView), VIEW_WIDTH, 150)];
//    mediaView.backgroundColor = [UIColor blueColor];
    int imagePerRow = 5;
    int imageTotal = 9;
    float imageViewSize = (GET_LAYOUT_WIDTH(mediaView)-GAP_WIDTH*(imagePerRow+1))/imagePerRow;
    float x = GAP_WIDTH;
    float y = GAP_HEIGHT;
    for(int i=0;i<imageTotal;i++){
        if( i%imagePerRow == 0 ){
            x = GAP_WIDTH;
        }else{
            x += imageViewSize + GAP_HEIGHT;
        }
        if( i > 0 && i%imagePerRow == 0 ){
            y += imageViewSize + GAP_HEIGHT;
            mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(mediaView), GET_LAYOUT_OFFSET_Y(textView)+GET_LAYOUT_HEIGHT(textView), GET_LAYOUT_WIDTH(mediaView), y+imageViewSize+GAP_HEIGHT);
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
//        imageView.backgroundColor = [UIColor orangeColor];
        imageView.image = [UIImage imageNamed:@"image"];
        [mediaView addSubview:imageView];
    }
    
    if( imageTotal%imagePerRow == 0 ){
        x = GAP_WIDTH;
    }else{
        x += imageViewSize + GAP_HEIGHT;
    }
    if( imageTotal > 0 && imageTotal%imagePerRow == 0 ){
        y += imageViewSize + GAP_HEIGHT;
        mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(mediaView), GET_LAYOUT_OFFSET_Y(textView)+GET_LAYOUT_HEIGHT(textView), GET_LAYOUT_WIDTH(mediaView), y+imageViewSize+GAP_HEIGHT);
    }
    UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
//    [addImageButton setTitle:@"+" forState:UIControlStateNormal];
//    addImageButton.titleLabel.font = [UIFont systemFontOfSize:46.0];
//    [addImageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addImageButton setImage:[UIImage imageNamed:@"iv_upload"] forState:UIControlStateNormal];
    addImageButton.layer.borderColor = BORDER_COLOR;
    addImageButton.layer.borderWidth = BORDER_WIDTH;
    [mediaView addSubview:addImageButton];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, GET_LAYOUT_WIDTH(mediaView), BORDER_WIDTH);
    topBorder.backgroundColor = BORDER_COLOR;
    [mediaView.layer addSublayer:topBorder];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, GET_LAYOUT_HEIGHT(mediaView)-1, GET_LAYOUT_WIDTH(mediaView), BORDER_WIDTH);
    bottomBorder.backgroundColor = BORDER_COLOR;
    [mediaView.layer addSublayer:bottomBorder];
    [self.view addSubview:mediaView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(mediaView)+GET_LAYOUT_HEIGHT(mediaView), VIEW_WIDTH, VIEW_HEIGHT-GET_LAYOUT_OFFSET_Y(self.tableView))];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.text = @"设备";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clickSubmitButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
