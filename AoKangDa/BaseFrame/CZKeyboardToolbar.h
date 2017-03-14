
//

#import <UIKit/UIKit.h>

@class CZKeyboardToolbar;
@protocol CZKeyboardToolbarDelegate <NSObject>

@optional

/**
 *  item.tag  0 表示上一个按钮 1:下一个按钮 2:done完成按钮
 */
-(void)keyboardToolbar:(CZKeyboardToolbar *)toolbar btndidSelected:(UIBarButtonItem *)item;

@end

@interface CZKeyboardToolbar : UIToolbar

+(instancetype)toolbar;

@property (weak, nonatomic) id<CZKeyboardToolbarDelegate> kbDelegate;//键盘的代理

@end
