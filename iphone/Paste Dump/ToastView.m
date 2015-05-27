#import "ToastView.h"

@interface ToastView ()
@property (strong, nonatomic, readonly) UILabel *toastLabel;
@end
@implementation ToastView
@synthesize toastLabel = _toastLabel;

float const ToastHeight = 50.0f;
float const ToastGap = 10.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(UILabel *)toastLabel
{
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, self.frame.size.width - 10.0, self.frame.size.height - 10.0)];
        _toastLabel.backgroundColor = [UIColor clearColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.numberOfLines = 2;
        _toastLabel.font = [UIFont systemFontOfSize:17.0];
        _toastLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_toastLabel];
        
    }
    return _toastLabel;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.toastLabel.text = text;
}

+ (void)showToast: (UIView *)parentView withText:(NSString *)text withDuaration:(float)length;
{
    
    //Count toast views are already showing on parent. Made to show several toasts one above another
    int toastsAlreadyInParent = 0;
    for (UIView *subView in [parentView subviews]) {
        if ([subView isKindOfClass:[ToastView class]])
        {
            toastsAlreadyInParent++;
        }
    }
    
    CGRect parentFrame = parentView.frame;
    
    float yOrigin = parentFrame.size.height - (80.0 + ToastHeight * toastsAlreadyInParent + ToastGap * toastsAlreadyInParent);
    
    CGRect selfFrame = CGRectMake(parentFrame.origin.x + 20.0, yOrigin, parentFrame.size.width - 40.0, ToastHeight);
    ToastView *toast = [[ToastView alloc] initWithFrame:selfFrame];
    
    toast.backgroundColor = [UIColor darkGrayColor];
    toast.alpha = 0.0f;
    toast.layer.cornerRadius = 4.0;
    toast.text = text;
    
    [parentView addSubview:toast];
    
    [UIView animateWithDuration:0.4 animations:^{
        toast.alpha = 0.9f;
        toast.toastLabel.alpha = 0.9f;
    }completion:^(BOOL finished) {
        if(finished){
            
        }
    }];
    
    
    [toast performSelector:@selector(hideSelf) withObject:nil afterDelay:length];
    
}

- (void)hideSelf
{
    
    [UIView animateWithDuration:0.38 animations:^{
        self.alpha = 0.0;
        self.toastLabel.alpha = 0.0;
    }completion:^(BOOL finished) {
        if(finished){
            [self removeFromSuperview];
        }
    }];
}

@end