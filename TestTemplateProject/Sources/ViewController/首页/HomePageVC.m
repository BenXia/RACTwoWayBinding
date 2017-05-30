//
//  HomePageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/23.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "HomePageVC.h"

static NSString *kShowABTestEntranceUDKey = @"kShowABTestEntranceUDKey";

@interface HomePageVC () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeightConstraint;



@property (nonatomic, copy) NSString *viewTextValue;
@property (nonatomic, copy) NSString *modelTextValue;

@property (nonatomic, assign) BOOL viewBoolValue;
@property (nonatomic, assign) BOOL modelBoolValue;


@property (nonatomic, copy) NSString *onOffTextValue;
@property (nonatomic, assign) BOOL onOffBoolValue;


@property (nonatomic, weak) IBOutlet UISwitch *showABTestEntranceSwitch;
@property (nonatomic, assign) BOOL showABTestEntrance;


@property (nonatomic, weak) IBOutlet UITextField *userNameTextField;
@property (nonatomic, copy) NSString *userName;

@property (weak, nonatomic) IBOutlet UITextView *profileTextView;
@property (nonatomic, copy) NSString *profile;

@end

@implementation HomePageVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"RAC双向绑定";
    self.userNameTextField.delegate = self;
    self.profileTextView.delegate = self;   // 注意观察
    
    self.scrollContentViewHeightConstraint.constant = 300;
    
    // 1.普通情况下实现两个属性的双向绑定
    [self simpleTwoWayBinding];
    
    // 2.中间需要做一些映射规则的双向绑定
    [self customMapTwoWayBinding];
    
    // 3.实现UISwitch跟随NSUserDefaults存储的值双向绑定
    [self switchDemoTwoWayBinding];
    
    // 4.UITextField的text与自定义属性双向绑定
    [self textFieldDemoTwoWayBinding];
    
    // 5.UITextView的text与自定义属性双向绑定
    [self textViewDemoTwoWayBinding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 普通情况下实现两个属性的双向绑定

- (void)simpleTwoWayBinding {
    NSLog (@"=======simpleTwoWayBinding=======");
    
    // 方法一
    RACChannelTo(self, viewTextValue) = RACChannelTo(self, modelTextValue);
    
    self.viewTextValue = @"123";
    NSLog (@"self.viewTextValue: %@ self.modelTextValue: %@", self.viewTextValue, self.modelTextValue);
    
    self.modelTextValue = @"abc";
    NSLog (@"self.viewTextValue: %@ self.modelTextValue: %@", self.viewTextValue, self.modelTextValue);
    
    NSLog (@"\n\n\n");
    
    // 与方法一完全等价
    [[RACKVOChannel alloc] initWithTarget:self keyPath:@"viewBoolValue" nilValue:nil][@"followingTerminal"] = [[RACKVOChannel alloc] initWithTarget:self keyPath:@"modelBoolValue" nilValue:nil][@"followingTerminal"];
    
    self.viewBoolValue = YES;
    NSLog (@"self.viewBoolValue: %d self.modelBoolValue: %d", self.viewBoolValue, self.modelBoolValue);
    
    self.modelBoolValue = NO;
    NSLog (@"self.viewBoolValue: %d self.modelBoolValue: %d", self.viewBoolValue, self.modelBoolValue);
    
    NSLog (@"\n\n\n\n");
}

#pragma mark - 中间需要做一些映射规则的双向绑定

- (void)customMapTwoWayBinding {
    NSLog (@"=======customMapTwoWayBinding=======");
    
    RACChannelTerminal *channelA = RACChannelTo(self, onOffTextValue);
    RACChannelTerminal *channelB = RACChannelTo(self, onOffBoolValue);
    
    // onOffTextValue: "On"表示打开，"Off"表示关闭
    // onOffBoolValue: YES表示打开，NO表示关闭
    
    [[channelA map:^id(NSString *value) {
        if ([value isEqualToString:@"On"]) {
            return @YES;
        } else {
            return @NO;
        }
    }] subscribe:channelB];
    
    [[channelB map:^id(NSNumber *value) {
        if ([value boolValue]) {
            return @"On";
        } else {
            return @"Off";
        }
    }] subscribe:channelA];
    
    NSLog (@"self.onOffTextValue: %@ self.onOffBoolValue: %d", self.onOffTextValue, self.onOffBoolValue);
    
    self.onOffTextValue = @"On";
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.onOffTextValue: %@ self.onOffBoolValue: %d", self.onOffTextValue, self.onOffBoolValue);
    });
    
    self.onOffBoolValue = NO;
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.onOffTextValue: %@ self.onOffBoolValue: %d", self.onOffTextValue, self.onOffBoolValue);
    });
    
    NSLog (@"\n\n\n\n");
}

#pragma mark - 实现UISwitch跟随NSUserDefaults存储的值双向绑定

- (void)switchDemoTwoWayBinding {
    NSLog (@"=======switchDemoTwoWayBinding=======");
    
    RACChannelTerminal *switchTerminal = self.showABTestEntranceSwitch.rac_newOnChannel;
    RACChannelTerminal *defaultsTerminal = [[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kShowABTestEntranceUDKey];
    [switchTerminal subscribe:defaultsTerminal];
    [defaultsTerminal subscribe:switchTerminal];
    
    NSLog (@"self.showABTestEntranceSwitch.on: %d NSUserDefaults value: %@", self.showABTestEntranceSwitch.on, [[NSUserDefaults standardUserDefaults] valueForKey:kShowABTestEntranceUDKey]);
    
    NSLog (@"\n\n\n\n");
}

- (IBAction)didSwitchValueChanged:(id)sender {
    NSLog (@"=======didSwitchValueChanged=======");
    
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.showABTestEntranceSwitch.on: %d NSUserDefaults value: %@", self.showABTestEntranceSwitch.on, [[NSUserDefaults standardUserDefaults] valueForKey:kShowABTestEntranceUDKey]);
    });
}

- (IBAction)didClickChangeUserDefaultValueWithCodeButton:(id)sender {
    NSLog (@"=======didClickChangeUserDefaultValueWithCodeButton=======");
    
#warning ！！！ 这一块有点问题，设置完NSUserDefautls值后发现UISwitch控件有时没有变化
    
    BOOL oldBoolValue = [[NSUserDefaults standardUserDefaults] boolForKey:kShowABTestEntranceUDKey];
    [[NSUserDefaults standardUserDefaults] setBool:!oldBoolValue forKey:kShowABTestEntranceUDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.showABTestEntranceSwitch.on: %d NSUserDefaults value: %@", self.showABTestEntranceSwitch.on, [[NSUserDefaults standardUserDefaults] valueForKey:kShowABTestEntranceUDKey]);
    });
}

#pragma mark - UITextField的text与自定义属性双向绑定

- (void)textFieldDemoTwoWayBinding {
    NSLog (@"=======textFieldDemoTwoWayBinding=======");
    
    // 先来看看self.userNameTextField.rac_newTextChannel与RACChannelTo(self.userNameTextField, text)的区别
    //self.userNameTextField.rac_newTextChannel sends values when you type in the text field, but not when you change the text in the text field from code.
    //RACChannelTo(self.userNameTextField, text) sends values when you change the text in the text field from code, but not when you type in the text field.
    
    RACChannelTo(self.userNameTextField, text) = RACChannelTo(self, userName);
    // 这种写法其实已经是双向绑定的写法了，但是由于是UITextField不支持KVO原因代码设置self.userNameTextField.text的变化可以影响到userName，但是手动输入就不能影响到userName
    // userName的变化会影响self.userNameTextField.text的值
    
    // 在这里对UITextField的text changed的信号重新订阅一下，以实现上面channel未实现的手动输入影响userName的联动
    @weakify(self)
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self)
        
        self.userName = text;
        
        // RAC的观察可能还没触发，所以这一块先等1秒，再打印
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog (@"self.userNameTextField.text: %@ userName: %@", self.userNameTextField.text, self.userName);
        });
    }];
    
    NSLog (@"self.userNameTextField.text: %@ userName: %@", self.userNameTextField.text, self.userName);
    
    self.userName = @"hello world";
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.userNameTextField.text: %@ userName: %@", self.userNameTextField.text, self.userName);
    });
    
    NSLog (@"\n\n\n\n");
}

- (IBAction)didClickChangeTextFieldTextWithCodeButton:(id)sender {
    NSLog (@"=======didClickChangeTextFieldTextWithCodeButton=======");
    
    self.userNameTextField.text = @"hello rac";
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.userNameTextField.text: %@ userName: %@", self.userNameTextField.text, self.userName);
    });
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog (@"=======textFieldDidEndEditing=======");
    
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.userNameTextField.text: %@ userName: %@", self.userNameTextField.text, self.userName);
    });
}

#pragma mark - UITextView的text与自定义属性双向绑定

- (void)textViewDemoTwoWayBinding {
    NSLog (@"=======textViewDemoTwoWayBinding=======");
    
    // 先来看看self.profileTextView.rac_newTextChannel与RACChannelTo(self.profileTextView, text)的区别
    //self.profileTextView.rac_newTextChannel sends values when you type in the text field, but not when you change the text in the text field from code.
    //RACChannelTo(self.profileTextView, text) sends values when you change the text in the text field from code, but not when you type in the text field.
    
    // ！！！下面的实现与UITextField基本一致，只是UITextView的rac_textSignal会导致其delegate委托方法不触发，使用时千万需要注意这点
    
    RACChannelTo(self.profileTextView, text) = RACChannelTo(self, profile);
    // 这种写法其实已经是双向绑定的写法了，但是由于是UITextView不支持KVO原因代码设置self.profileTextView.text的变化可以影响到profile，但是手动输入就不能影响到profile
    // profile的变化会影响self.profileTextView.text的值
    
    // 在这里对UITextView的text changed的信号重新订阅一下，以实现上面channel未实现的手动输入影响profile的联动
    @weakify(self)
    [self.profileTextView.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self)
        
        self.profile = text;
        
        // RAC的观察可能还没触发，所以这一块先等1秒，再打印
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog (@"self.profileTextView.text: %@ profile: %@", self.profileTextView.text, self.profile);
        });
    }];
    
    NSLog (@"self.profileTextView.text: %@ profile: %@", self.profileTextView.text, self.profile);
    
    self.profile = @"ReactiveCocoa";
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.profileTextView.text: %@ profile: %@", self.profileTextView.text, self.profile);
    });
    
    NSLog (@"\n\n\n\n");
}

- (IBAction)didClickChangeTextViewTextWithCodeButton:(id)sender {
    NSLog (@"=======didClickChangeTextViewTextWithCodeButton=======");
    
    self.profileTextView.text = @"Objective C";
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.profileTextView.text: %@ profile: %@", self.profileTextView.text, self.profile);
    });
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog (@"=======textViewDidChange=======");
    
    // RAC的观察可能还没触发，所以这一块先等1秒，再打印
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog (@"self.profileTextView.text: %@ profile: %@", self.profileTextView.text, self.profile);
    });
}

@end


