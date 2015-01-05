//
//  WebViewController.h
//  Club
//
//  Created by dongway on 14-8-15.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property(nonatomic,copy)NSString *urlString;
-(void)loadWebPageWithString:(NSString *)urlString inWebView:(UIWebView *)webview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@end
