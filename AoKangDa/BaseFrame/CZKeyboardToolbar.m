

#import "CZKeyboardToolbar.h"


@interface CZKeyboardToolbar()

@end

@implementation CZKeyboardToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)toolbar{
    return [[[NSBundle mainBundle] loadNibNamed:@"CZKeyboardToolbar" owner:nil options:nil] lastObject];
}


- (IBAction)itemBtnClick:(id)sender {
    
    //判断代理有没有实现方法
    if ([self.kbDelegate respondsToSelector:@selector(keyboardToolbar:btndidSelected:)]) {
        [self.kbDelegate keyboardToolbar:self btndidSelected:sender];
    }
    
}
@end
