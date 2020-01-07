//
//  KIImagePager.m
//  KIImagePager
//
//  Created by Marcus Kida on 07.04.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#define kPageControlHeight  30
#define kOverlayWidth       50
#define kOverlayHeight      15

#import "KIImagePager.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "AppDelegate.h"
#import "RegistrationScreen.h"
#import "LoginScreen.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface KIImagePagerDefaultImageSource : NSObject <KIImagePagerImageSource, UIWebViewDelegate>
@end

@interface KIImagePager () <UIScrollViewDelegate>
{
    __weak id <KIImagePagerDataSource> _dataSource;
    __weak id <KIImagePagerDelegate> _delegate;

    UIPageControl *_pageControl;
    UILabel *_countLabel;
    UILabel *_captionLabel;
    UIView *_imageCounterBackground;
    NSTimer *_slideshowTimer;
    NSUInteger _slideshowTimeInterval;
    NSMutableDictionary *_activityIndicators;

    BOOL _indicatorDisabled;
	BOOL _bounces;
}
@end

@implementation KIImagePager

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize contentMode = _contentMode;
@synthesize pageControl = _pageControl;
@synthesize indicatorDisabled = _indicatorDisabled;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
		_bounces = YES;
        [self initialize];
     
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
		_bounces = YES;
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) layoutSubviews
{
	for (UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
    [self initialize];
}

#pragma mark - General
- (void) initialize
{
    self.slideshowShouldCallScrollToDelegate = YES;
    self.captionBackgroundColor = [UIColor whiteColor];
    self.captionTextColor = [UIColor blackColor];
    self.captionFont = [UIFont fontWithName:@"Helvetica-Light" size:12.0f];
    self.hidePageControlForSinglePages = YES;

    [self initializeScrollView];
    [self initializePageControl];
    if(!_imageCounterDisabled) {
        [self initalizeImageCounter];
    }
    [self initializeCaption];

    if(!self.imageSource)
    {
        self.imageSource = [[self class] defaultDataSource];
    }

    [self loadData];
}


+ (id<KIImagePagerImageSource>)defaultDataSource {
    static KIImagePagerDefaultImageSource *_defaultDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultDataSource = [KIImagePagerDefaultImageSource new];
    });

    return _defaultDataSource;
}

- (UIColor *) randomColor
{
    return [UIColor colorWithHue:(arc4random() % 256 / 256.0)
                      saturation:(arc4random() % 128 / 256.0) + 0.5
                      brightness:(arc4random() % 128 / 256.0) + 0.5
                           alpha:1];
}

- (void) initalizeImageCounter
{
    _imageCounterBackground = [[UIView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width-(kOverlayWidth-4),
                                                                       _scrollView.frame.size.height-kOverlayHeight,
                                                                       kOverlayWidth,
                                                                       kOverlayHeight)];
    _imageCounterBackground.backgroundColor = [UIColor whiteColor];
    _imageCounterBackground.alpha = 0.7f;
    _imageCounterBackground.layer.cornerRadius = 5.0f;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [icon setImage:[UIImage imageNamed:@"KICamera"]];
    icon.center = CGPointMake(_imageCounterBackground.frame.size.width-18, _imageCounterBackground.frame.size.height/2);
    //[_imageCounterBackground addSubview:icon];

    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setTextColor:[UIColor blackColor]];
    [_countLabel setFont:[UIFont systemFontOfSize:11.0f]];
    _countLabel.center = CGPointMake(15, _imageCounterBackground.frame.size.height/2);
    [_imageCounterBackground addSubview:_countLabel];

    //if(!_imageCounterDisabled) [self addSubview:_imageCounterBackground];
}

- (void) initializeCaption
{
//    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _scrollView.frame.size.width - 10, 20)];
//    [_captionLabel setBackgroundColor:self.captionBackgroundColor];
//    [_captionLabel setTextColor:self.captionTextColor];
//    [_captionLabel setFont:self.captionFont];
//
//    _captionLabel.alpha = 0.7f;
//    _captionLabel.layer.cornerRadius = 5.0f;
//
//    [self addSubview:_captionLabel];
    
    
    AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.fromPageScrollController isEqualToString:@"YES"]) {
        
        
        self.luxHotlStayLbl = [[UILabel alloc]init];
        self.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
        self.luxHotlStayLbl.textColor = [UIColor whiteColor];
        [self addSubview:self.luxHotlStayLbl];
        
        
        
        
        self.priceLblBigFont = [[UILabel alloc]init];
        
        self.priceLblBigFont.textColor = [UIColor whiteColor];
        [self addSubview:self.priceLblBigFont];
        
        
        self.bottomLbl = [[UILabel alloc]init];
        self.bottomLbl.text      = @"ALL OVER INDIA";
        self.bottomLbl.textColor = [UIColor whiteColor];
        
        
        
        [self addSubview:self.bottomLbl];
        
        
        self.webView = [[UIWebView alloc]init];
        self.webView.delegate = self;
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView setOpaque:NO];
        self.webView.userInteractionEnabled = YES;
        self.webView.layer.masksToBounds = YES;
        [self addSubview:self.webView];
        
        self.luxHotlStayLbl.hidden = YES;
        self.priceLblBigFont.hidden = YES;
        self.bottomLbl.hidden = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.luxHotlStayLbl.frame = CGRectMake(30, 30, self.frame.size.width, 36);
            self.priceLblBigFont.frame = CGRectMake(30, self.luxHotlStayLbl.frame.origin.y +self.luxHotlStayLbl.frame.size.height +5, self.frame.size.width, 36);
            
            self.bottomLbl.frame = CGRectMake(30, self.priceLblBigFont.frame.origin.y +self.priceLblBigFont.frame.size.height +5, self.frame.size.width, 36);
            
            self.webView.frame = CGRectMake(20, 15, 300, 150);
            
            self.luxHotlStayLbl.font = [UIFont systemFontOfSize:36];
            self.bottomLbl.font = [UIFont systemFontOfSize:24];
            NSMutableAttributedString *attString =
            [[NSMutableAttributedString alloc]
             initWithString: @"FOR ₹ 2999/- (INCL. TAXES)"];
            
            [attString addAttribute: NSFontAttributeName
                              value:  [UIFont systemFontOfSize:36]
                              range: NSMakeRange(0,12)];
            
            [attString addAttribute: NSFontAttributeName
                              value:  [UIFont boldSystemFontOfSize:12]
                              range: NSMakeRange(12,14)];
            self.priceLblBigFont.attributedText = attString;
            
            
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            self.luxHotlStayLbl.frame = CGRectMake(15, 15, self.frame.size.width, 24);
            self.priceLblBigFont.frame = CGRectMake(15, self.luxHotlStayLbl.frame.origin.y +self.luxHotlStayLbl.frame.size.height + 5, self.frame.size.width, 24);
            
            self.bottomLbl.frame = CGRectMake(15, self.priceLblBigFont.frame.origin.y +self.priceLblBigFont.frame.size.height +5, self.frame.size.width, 24);
              self.webView.frame = CGRectMake(5, 2,220 , 98);
            NSMutableAttributedString *attString =
            [[NSMutableAttributedString alloc]
             initWithString: @"FOR ₹ 2,999/- (INCL. TAXES)"];
            
            
            [attString addAttribute: NSFontAttributeName
                              value:  [UIFont systemFontOfSize:24]
                              range: NSMakeRange(0,13)];
            
            [attString addAttribute: NSFontAttributeName
                              value:  [UIFont boldSystemFontOfSize:12]
                              range: NSMakeRange(13,14)];
            self.luxHotlStayLbl.font = [UIFont systemFontOfSize:24];
            self.bottomLbl.font = [UIFont systemFontOfSize:17];
            self.priceLblBigFont.attributedText = attString;
            
        }
        
    }
    
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void) reloadData
{
    for (UIView *view in _scrollView.subviews)
        [view removeFromSuperview];

    [self loadData];
    [self checkWetherToToggleSlideshowTimer];
}

#pragma mark - ScrollView Initialization
- (void) initializeScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
	_scrollView.bounces = _bounces;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];
}

- (void) loadData
{
    NSArray *aImageUrls = (NSArray *)[_dataSource arrayWithImages:self];
    _activityIndicators = [NSMutableDictionary new];

    [self updateCaptionLabelForImageAtIndex:0];

    if([aImageUrls count] > 0) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * [aImageUrls count],
                                               _scrollView.frame.size.height)];

        for (int i = 0; i < [aImageUrls count]; i++) {
            CGRect imageFrame = CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setContentMode:[_dataSource contentModeForImage:i inPager:self]];
            [imageView setTag:i];
            [imageView setClipsToBounds:YES];
            if ([_dataSource respondsToSelector:@selector(placeHolderImageForImagePager:)]) {
                [imageView setImage:[_dataSource placeHolderImageForImagePager:self]];
            }
            if([_dataSource respondsToSelector:@selector(contentModeForPlaceHolder:)]) {
                [imageView setContentMode:[_dataSource contentModeForPlaceHolder:self]];
            }

            if([[aImageUrls objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                // Set ImageView's Image directly
                [imageView setImage:(UIImage *)[aImageUrls objectAtIndex:i]];
            } else if([[aImageUrls objectAtIndex:i] isKindOfClass:[NSString class]] ||
                      [[aImageUrls objectAtIndex:i] isKindOfClass:[NSURL class]]) {
                // Instantiate and show Actvity Indicator
                UIActivityIndicatorView *activityIndicator = [UIActivityIndicatorView new];
                activityIndicator.center = (CGPoint){_scrollView.frame.size.width/2, _scrollView.frame.size.height/2};
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                [imageView addSubview:activityIndicator];
                [activityIndicator startAnimating];
                [_activityIndicators setObject:activityIndicator forKey:[NSString stringWithFormat:@"%d", i]];

                NSString *str_url = [aImageUrls objectAtIndex:i];
                // Asynchronously retrieve image
                NSURL * imageUrl  = [[aImageUrls objectAtIndex:i] isKindOfClass:[NSURL class]] ? [aImageUrls objectAtIndex:i] : [NSURL URLWithString:(NSString *)[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

                //image source is responsible for image retreiving/caching, etc...
                [self.imageSource imageWithUrl:imageUrl
                                    completion:^(UIImage *image, NSError *error)
                 {
                     if(!error) [imageView setImage:image];//should we handle error?
                     else [imageView setImage:nil];

                     [imageView setContentMode:[_dataSource contentModeForImage:i inPager:self]];

                     // Stop and Remove Activity Indicator
                     UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[_activityIndicators objectForKey:[NSString stringWithFormat:@"%d", i]];
                     if (indicatorView) {
                         [indicatorView stopAnimating];
                         [_activityIndicators removeObjectForKey:[NSString stringWithFormat:@"%d", i]];
                     }
                 }];
            }

            // Add GestureRecognizer to ImageView
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(imageTapped:)];
            [singleTapGestureRecognizer setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:singleTapGestureRecognizer];
            [imageView setUserInteractionEnabled:YES];

            [_scrollView addSubview:imageView];
         
            _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_loginButton addTarget:self action:@selector(LoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            _signupBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_signupBtn addTarget:self action:@selector(signUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

            _skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }

        [_countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[_dataSource arrayWithImages:self] count]]];
        _pageControl.numberOfPages = [(NSArray *)[_dataSource arrayWithImages:self] count];
    } else {
        UIImageView *blankImage = [[UIImageView alloc] initWithFrame:_scrollView.frame];
        if ([_dataSource respondsToSelector:@selector(placeHolderImageForImagePager:)]) {
            [blankImage setImage:[_dataSource placeHolderImageForImagePager:self]];
        }
        if([_dataSource respondsToSelector:@selector(contentModeForPlaceHolder:)]) {
            [blankImage setContentMode:[_dataSource contentModeForPlaceHolder:self]];
        }
        [_scrollView addSubview:blankImage];
    }
    [self updatePageControl];
}

- (void) imageTapped:(UITapGestureRecognizer *)sender
{
    if([_delegate respondsToSelector:@selector(imagePager:didSelectImageAtIndex:)]) {
        [_delegate imagePager:self didSelectImageAtIndex:[(UIGestureRecognizer *)sender view].tag];
    }
}

-(void)signUpButtonPressed:(id)sender {
    [_delegate respondsToSelector:@selector(imagePager:signUpButtonPressed:)];
    if( [_delegate respondsToSelector:@selector(imagePager:signUpButtonPressed:)]) {
        [_delegate imagePager:self signUpButtonPressed:(id )sender];
    }
}
-(void)LoginButtonPressed:(id)sender {
    [_delegate respondsToSelector:@selector(imagePager:LoginButtonPressed:)];
    if( [_delegate respondsToSelector:@selector(imagePager:LoginButtonPressed:)]) {
        [_delegate imagePager:self LoginButtonPressed:(id )sender];
    }
}

-(void)skipButtonPressed:(id)sender
{
    [_delegate respondsToSelector:@selector(imagePager:skipButtonPressed:)];
    if( [_delegate respondsToSelector:@selector(imagePager:skipButtonPressed:)]) {
        [_delegate imagePager:self skipButtonPressed:(id )sender];
    }
}
- (void) setIndicatorDisabled:(BOOL)indicatorDisabled
{
    if(indicatorDisabled) {
        [_pageControl removeFromSuperview];
    } else {
        [self addSubview:_pageControl];
    }

    _indicatorDisabled = indicatorDisabled;
}

- (BOOL)bounces {

	return _bounces;
}

- (void)setBounces:(BOOL)bounces {
	_bounces = bounces;
	_scrollView.bounces = _bounces;
}

- (void)setImageCounterDisabled:(BOOL)imageCounterDisabled
{
    if (imageCounterDisabled) {
        [_imageCounterBackground removeFromSuperview];
    } else {
        [self addSubview:_imageCounterBackground];
    }

    _imageCounterDisabled = imageCounterDisabled;
}

#pragma mark - PageControl Initialization
- (void) initializePageControl
{
    CGRect pageControlFrame = CGRectMake(0, 0, _scrollView.frame.size.width, kPageControlHeight);
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    _pageControl.center = CGPointMake(_scrollView.frame.size.width / 2, _scrollView.frame.size.height - 12.0);
    _pageControl.userInteractionEnabled = NO;
    if(!_indicatorDisabled) [self addSubview:_pageControl];
}

#pragma mark - ScrollView Delegate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([_slideshowTimer isValid]) {
        [_slideshowTimer invalidate];
    }
    [self checkWetherToToggleSlideshowTimer];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    long currentPage = lround((float)scrollView.contentOffset.x / scrollView.frame.size.width);
    _pageControl.currentPage = currentPage;

    [self updateCaptionLabelForImageAtIndex:currentPage];
    [self fireDidScrollToIndexDelegateForPage:currentPage];
}

#pragma mark - Delegate Helper
- (void) updateCaptionLabelForImageAtIndex:(NSUInteger)index
{
    if ([_dataSource respondsToSelector:@selector(captionForImageAtIndex:inPager:)]) {
        if ([[_dataSource captionForImageAtIndex:index inPager:self] length] > 0) {
            [_captionLabel setHidden:NO];
            [_captionLabel setText:[NSString stringWithFormat:@" %@", [_dataSource captionForImageAtIndex:index inPager:self]]];
            return;
        }
    }
    [_captionLabel setHidden:YES];
}

- (void) fireDidScrollToIndexDelegateForPage:(NSUInteger)page
{
    if([_delegate respondsToSelector:@selector(imagePager:didScrollToIndex:)]) {
        [_delegate imagePager:self didScrollToIndex:page];
    }
}

#pragma mark - Slideshow
- (void) slideshowTick:(NSTimer *)timer
{
    NSUInteger nextPage = 0;
    if([_pageControl currentPage] < ([[_dataSource arrayWithImages:self] count] - 1)) {
        nextPage = [_pageControl currentPage] + 1;
    }

    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * nextPage, 0, self.frame.size.width, self.frame.size.width) animated:YES];
    [_pageControl setCurrentPage:nextPage];

    [self updateCaptionLabelForImageAtIndex:nextPage];

    if (self.slideshowShouldCallScrollToDelegate) {
        [self fireDidScrollToIndexDelegateForPage:nextPage];
    }
}

- (void) checkWetherToToggleSlideshowTimer
{
    if (_slideshowTimeInterval > 0) {
        if ([(NSArray *)[_dataSource arrayWithImages:self] count] > 1) {
            if(_slideshowTimer){
                [_slideshowTimer invalidate];
            }
            _slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:_slideshowTimeInterval target:self selector:@selector(slideshowTick:) userInfo:nil repeats:YES];
        }
    }
}

#pragma mark - Setter / Getter
- (void) setSlideshowTimeInterval:(NSUInteger)slideshowTimeInterval
{
    _slideshowTimeInterval = slideshowTimeInterval;

    if([_slideshowTimer isValid]) {
        [_slideshowTimer invalidate];
    }
    [self checkWetherToToggleSlideshowTimer];
}

- (NSUInteger) slideshowTimeInterval
{
    return _slideshowTimeInterval;
}

- (void) setCaptionBackgroundColor:(UIColor *)captionBackgroundColor
{
    [_captionLabel setBackgroundColor:captionBackgroundColor];
    _captionBackgroundColor = captionBackgroundColor;
}

- (void) setCaptionTextColor:(UIColor *)captionTextColor
{
    [_captionLabel setTextColor:captionTextColor];
    _captionTextColor = captionTextColor;
}

- (void) setCaptionFont:(UIFont *)captionFont
{
    [_captionLabel setFont:captionFont];
    _captionFont = captionFont;
}

- (void) setHidePageControlForSinglePages:(BOOL)hidePageControlForSinglePages
{
  _hidePageControlForSinglePages = hidePageControlForSinglePages;
  [self updatePageControl];
}

- (void)updatePageControl {
  if (self.hidePageControlForSinglePages) {
    if ([(NSArray *)[_dataSource arrayWithImages:self] count] < 2) {
      [_pageControl setHidden:YES];
      return;
    }
  }
  [_pageControl setHidden:NO];
}

- (void) setPageControlCenter:(CGPoint)pageControlCenter
{
    _pageControl.center = pageControlCenter;
}

- (NSUInteger) currentPage
{
    return [_pageControl currentPage];
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
    [self setCurrentPage:currentPage animated:YES];
}

- (void) setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated
{
    NSAssert((currentPage < [(NSArray *)[_dataSource arrayWithImages:self] count]), @"currentPage must not exceed maximum number of images");

    [_pageControl setCurrentPage:currentPage];
    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * currentPage, 0, self.frame.size.width, self.frame.size.width) animated:animated];
}

@end



#pragma mark  - Image source


@implementation KIImagePagerDefaultImageSource

-(void) imageWithUrl:(NSURL*)url completion:(KIImagePagerImageRequestBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(completion) completion([UIImage imageWithData:imageData],nil);
            
        });
    });
}

@end
