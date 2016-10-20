//
//  ShareViewController.m
//  Pamily
//
//  Created by LinYiting on 2016/9/13.
//  Copyright © 2016年 Pamily. All rights reserved.
//

#import "ShareViewController.h"

#import <AssetsLibrary/ALAssetRepresentation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>


// Third Party
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <Social/Social.h>
#import <MBProgressHUD.h>
#import <MessageUI/MessageUI.h>
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import <Accounts/Accounts.h>
#import "UIImage+animatedGIF.h"
#import "GIFConverter.h"

// UI
#import "ShareCollectionViewCell.h"

#import "DeviceDetection.h"


@interface ShareViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    MFMessageComposeViewControllerDelegate,
    MFMailComposeViewControllerDelegate,
    FBSDKSharingDelegate,
    UIDocumentInteractionControllerDelegate
>

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIButton *dismissButton;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIDocumentInteractionController *dic;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *albumURL;

@property (nonatomic, assign) BOOL isProcessing;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [self generateDataArray];

    
    [self constructView];
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationNone];
    
    [self.collectionView reloadData];
}

- (NSArray *)generateDataArray
{
    return @[
             @{
                 @"text":@"Instagram",
                 @"image":@"shareInstagram"
                 },
             @{
                 @"text":@"Facebook",
                 @"image":@"shareFacebook"
                 },
             @{
                 @"text":@"Messenger",
                 @"image":@"shareMessenger"
                 },
             @{
                 @"text":@"WhatsApp",
                 @"image":@"shareWhatsapp"
                 },
             @{
                 @"text":@"Email",
                 @"image":@"shareMail"
                 },
             @{
                 @"text":NSLocalizedString(@"SMS", nil),
                 @"image":@"shareSms"
                 },
             @{
                 @"text":NSLocalizedString(@"More", nil),
                 @"image":@"shareMore"
                 }
             ];
}


#pragma mark - Setup UI
- (void)constructView
{
    self.view.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.969 alpha:1.000];
    
    
    [self setupCloseButton];
    [self setupTopView];
    [self setupCollectionView];
    
}

- (void)setupCloseButton
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"btnCloseShoot"] forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.top.left.equalTo(self.view).with.offset(10);
    }];
    [closeButton addTarget:self
                    action:@selector(clickClose)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTopView
{
    NSData *gifData = [NSData dataWithContentsOfURL:self.sharedImageURL];
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    CGFloat ratio = gifImage.size.height / gifImage.size.width;

    UIView *topView = [UIView new];
    
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(topView.mas_width).multipliedBy(ratio);
    }];
    
    self.topView = topView;
    
    FLAnimatedImageView *imageView = [FLAnimatedImageView new];
    imageView.animatedImage = gifImage;
    
    [topView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.equalTo(imageView.mas_width).multipliedBy(ratio);
        if (ratio > 1) {
            make.height.equalTo(topView);
        } else {
            make.width.equalTo(topView);
        }
    }];
    
}

- (void)setupCollectionView
{
    NSInteger numberOfColumns = 3;
    CGFloat itemWidth = floorf(318 / numberOfColumns);
    CGSize cellSize = CGSizeMake(itemWidth, 103);
    
    // collection
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = cellSize;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = self.view.backgroundColor;
    collectionView.tag = 2;
    [collectionView registerClass:[ShareCollectionViewCell class]
       forCellWithReuseIdentifier:shareCollectionViewCellCellIdentifier];
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        if (IS_IPHONE_5){
            make.top.equalTo(self.topView.mas_bottom).with.offset(15);
        } else if (IS_IPHONE_6){
            make.top.equalTo(self.topView.mas_bottom).with.offset(30);
        } else if (IS_IPHONE_6P){
            make.top.equalTo(self.topView.mas_bottom).with.offset(50);
        } else {
            make.top.equalTo(self.topView.mas_bottom).with.offset(10);
        }
        make.centerX.equalTo(self.view);
        make.width.equalTo(@318);
    }];
    
    self.collectionView = collectionView;
}

#pragma mark - Binding
- (void)bindData
{
    @weakify(self);
    [[[RACObserve(self, isProcessing) ignore:nil] distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([x boolValue]) {
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         } else {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     }];
}

#pragma mark - Share Image
- (void)shareImageTo:(NSString *)platform
{
    if ([platform isEqualToString:@"Facebook"]) {
        [self shareImageToFacebook];
    } else if ([platform isEqualToString:@"Messenger"]) {
        [self shareImageToMessenger];
    }  else if ([platform isEqualToString:@"WhatsApp"]) {
        [self shareImageToWhatsApp];
    } else if([platform isEqualToString:NSLocalizedString(@"SMS", nil)]) {
        [self shareImageToSMS];
    } else if ([platform isEqualToString:NSLocalizedString(@"Copy Link", nil)]) {
        [self saveImage];
    } else if ([platform isEqualToString:NSLocalizedString(@"More", nil)]) {
        [self shareImageToOtherPlatform];
    } else if ([platform isEqualToString:@"Email"]){
        [self shareImageToEmail];
    } else if ([platform isEqualToString:@"Instagram"]){
        [self shareImageToInstagram];
    }
}

- (void)shareImageToInstagram
{
    self.isProcessing = YES;
    
    @weakify(self);
    [[[self convertToMp4Signal]
      flattenMap:^RACStream *(id value) {
          @strongify(self);
          return [self saveToAlbumWithVideoURL:value];
      }] subscribeNext:^(NSURL *assetURL) {
          @strongify(self);
          self.isProcessing = NO;
          
          NSString *caption = @"Pamily";
          
          NSURL *instagramURL = [NSURL URLWithString:
                                 [NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",
                                  [assetURL.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]],
                                  [caption stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]
                                 ];
          [[UIApplication sharedApplication] openURL:instagramURL];
      } error:^(NSError *error) {
          self.isProcessing = NO;
          NSLog(@"Error:%@",[error localizedDescription]);
      }];
}


- (void)shareImageToFacebook
{
    self.isProcessing = YES;
    
    @weakify(self);
    [[[self convertToMp4Signal]
     flattenMap:^RACStream *(id value) {
         @strongify(self);
         return [self saveToAlbumWithVideoURL:value];
     }] subscribeNext:^(id x) {
         @strongify(self);
         self.isProcessing = NO;
         
         FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
         FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
         video.videoURL = x;
         content.video = video;
         [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
     } error:^(NSError *error) {
         self.isProcessing = NO;
         NSLog(@"Error:%@",[error localizedDescription]);
     }];
}

- (void)shareImageToMessenger
{
    NSData *gifData = [NSData dataWithContentsOfURL:self.sharedImageURL];
    [FBSDKMessengerSharer shareAnimatedGIF:gifData withOptions:nil];
}

- (void)shareImageToWhatsApp
{
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        self.isProcessing = YES;
        @weakify(self);
        [[self convertToMp4Signal] subscribeNext:^(id x) {
            @strongify(self);
            self.isProcessing = NO;
            
            self.dic = [UIDocumentInteractionController interactionControllerWithURL:x];
            self.dic.UTI = @"public.movie";
            self.dic.delegate = self;
            
            [self.dic presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0)
                                         inView:self.view
                                       animated:YES];
        } error:^(NSError *error) {
            self.isProcessing = NO;
            NSLog(@"Error:%@",[error localizedDescription]);
        }];
    } else {
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id310633997"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}

- (void)shareImageToSMS
{
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *messageComposer =
        [[MFMessageComposeViewController alloc] init];
        NSString *message = [NSString stringWithFormat:@"%@", @"Sent from Election 2016 - Vote with pet"];
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        if ([MFMessageComposeViewController canSendAttachments]) {
            [messageComposer addAttachmentData:[NSData dataWithContentsOfURL:self.sharedImageURL]
                                typeIdentifier:@"public.data"
                                      filename:@"image.gif"];
        }
        
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
}

- (void)shareImageToTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@", @"Sent from Election 2016 - Vote with pet"]];
        [tweetSheet addImage:[UIImage animatedImageWithAnimatedGIFURL:self.sharedImageURL]];
        [tweetSheet addURL:self.sharedImageURL];
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultDone) {
                
            }
        };
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)shareImageToEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Vote for America"];
        [controller setMessageBody:[NSString stringWithFormat:@"%@",@"Sent from Election 2016 - Vote with pet"]
                            isHTML:YES];
        [controller addAttachmentData:[NSData dataWithContentsOfURL:self.sharedImageURL]
                             mimeType:@"image/gif"
                             fileName:@"pamily.gif"];
        
        [self presentViewController:controller
                           animated:YES
                         completion:^{
                             
                         }];
    }
}


- (void)saveImage
{
    UIImage *animatedImage = [UIImage animatedImageWithAnimatedGIFURL:self.sharedImageURL];
    UIImageWriteToSavedPhotosAlbum(animatedImage, nil, nil, nil);
}

- (void)shareImageToOtherPlatform
{
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[self.sharedImageURL]
                                      applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler =
    ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
    {
        if (completed) {
            
        }
    };
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

#pragma mark - Process Video

- (void)generateVideoFileWithCompletionHandler:(void (^)(NSURL *assetURL, NSError *error))handler;
{
    NSData *gifData = [NSData dataWithContentsOfURL:self.sharedImageURL];
    
    NSString *fileName = [self.sharedImageURL.lastPathComponent stringByDeletingPathExtension];
    NSString *pathString = [NSString stringWithFormat:@"%@.mp4",fileName];
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:pathString];
    NSURL *outputURL = [NSURL fileURLWithPath:tempPath];

    if ([[NSFileManager defaultManager] fileExistsAtPath:outputURL.path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputURL.path error:nil];
    }
    
    GIFConverter *gifConverter = [[GIFConverter alloc] init];
    @weakify(self);
    
    [gifConverter convertGIFToMP4:gifData
                            speed:1.0
                             size:self.imageSize
                           repeat:0
                           output:outputURL.path
                       completion:^(NSError *error)
     {
         @strongify(self);
         if(!error) {
             self.videoURL = outputURL;
             handler(outputURL, error);
         }
     }];
}

- (RACSignal *)convertToMp4Signal
{
    if (self.videoURL) {
        return [RACSignal return:self.videoURL];
    }
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSData *gifData = [NSData dataWithContentsOfURL:self.sharedImageURL];
        
        NSString *fileName = [self.sharedImageURL.lastPathComponent stringByDeletingPathExtension];
        NSString *pathString = [NSString stringWithFormat:@"%@.mp4",fileName];
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:pathString];
        NSURL *outputURL = [NSURL fileURLWithPath:tempPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:outputURL.path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:outputURL.path error:nil];
        }
        
        GIFConverter *gifConverter = [[GIFConverter alloc] init];
        
        [gifConverter convertGIFToMP4:gifData
                                speed:1.0
                                 size:self.imageSize
                               repeat:0
                               output:outputURL.path
                           completion:^(NSError *error)
         {
             @strongify(self);
             if(!error) {
                 self.videoURL = outputURL;
                 [subscriber sendNext:outputURL];
                 [subscriber sendCompleted];
             } else {
                 [subscriber sendError:error];
             }
         }];
        return nil;
    }];
}

- (RACSignal *)saveToAlbumWithVideoURL:(NSURL *)videoURL
{
    if (self.albumURL) {
        return [RACSignal return:self.albumURL];
    }
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary writeVideoAtPathToSavedPhotosAlbum:videoURL
                                         completionBlock:^(NSURL *assetURL, NSError *error)
         {
             @strongify(self);
             if (!error) {
                 self.albumURL = assetURL;
                 [subscriber sendNext:assetURL];
                 [subscriber sendCompleted];
             } else {
                 [subscriber sendError:error];
             }
         }];
        return nil;
    }];
}

- (void)postImage:(UIImage *)image withStatus:(NSString *)status url:(NSURL*)urlData {
    
    // UIImage *img = [UIImage animatedImageNamed:@"test.gif" duration:3.0];
    NSURL *url = [NSURL URLWithString:@"https://upload.twitter.com/1.1/media/upload.json"];
    NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
    
    //set the parameter here. to see others acceptable parameters find it at twitter API here : http://bit.ly/Occe6R
    [paramater setObject:status forKey:@"status"];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray lastObject];
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:paramater];
                
                NSData *imageData = [NSData dataWithContentsOfURL:urlData]; // GIF89a file
                
                [postRequest addMultipartData:imageData withName:@"media[]" type:@"image/gif" filename:@"animated.gif"];
                
                [postRequest setAccount:twitterAccount]; // or  postRequest.account = twitterAccount;
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"output = %@",output);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    
                }];
            }
            
        }
    }];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCollectionViewCellCellIdentifier
                                                                              forIndexPath:indexPath];
    
    if (!cell) {
        cell = [ShareCollectionViewCell new];
    }
    
    NSDictionary *data = self.dataArray[indexPath.row];
    
    /*
     date @{
     text:text
     image:image
     }
     */
    
    [cell updateWithData:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataArray[indexPath.row];
    [self shareImageTo:data[@"text"]];

}

#pragma mark - Facebook Sharing
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"result:%@",results);
    if (results[@"didComplete"] && ![results[@"completionGesture"] isEqualToString:@"message"]) {
        // cancel in messageDialog
        return;
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"canceled!");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

@end
