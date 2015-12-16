//
//  ViewController.m
//  单击事件
//
//  Created by Ibokan on 15/9/28.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView* imageView;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    添加单个Image
    imageView= [[UIImageView alloc]initWithFrame:CGRectMake(50, 150, 220, 320)];
    UIImage* image = [UIImage imageNamed:@"tupian/run1.tiff"];
    imageView.image=image;
    //注意：要对ImageView做手势，记得吧用户交互属性设yes
//    因为ImageView不能做手势交互
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
//
    NSArray* GesArr=@[@"单击",@"拖拽",@"旋转",@"捏合",@"长按",@"轻扫",@"边缘"];
    UISegmentedControl* seg=[[UISegmentedControl alloc]initWithItems:GesArr];
    seg.frame=CGRectMake(10, 627, 350, 38);
    [seg addTarget:self action:@selector(segmentAtion:) forControlEvents:UIControlEventValueChanged];
    //设置可选
    [seg setEnabled:NO forSegmentAtIndex:0];
    //自动设配选项的宽度
    seg.apportionsSegmentWidthsByContent=YES;
    //改变选项颜色
    seg.tintColor = [UIColor yellowColor];
    //设置segment的默认选项
    seg.selectedSegmentIndex=2;
    [self.view addSubview:seg];
    
    
}
-(void)segmentAtion:(UISegmentedControl*)segment{
    //手势管理
    for (UIGestureRecognizer* ges in [imageView gestureRecognizers]) {
        [imageView removeGestureRecognizer:ges];
    }
    switch (segment.selectedSegmentIndex) {
        case 0:
//            UITapGestureRecognizer//点击
//            UIGestureRecognizer//管全部
        {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAtion:)];
            [imageView addGestureRecognizer:tap];
            
        }break;
        case 1:
        {
            UIPanGestureRecognizer* pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragAction:)];
            [imageView addGestureRecognizer:pan];
        }break;
        case 2:{
            UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateAction:)];
           
            [imageView addGestureRecognizer:rotate];
        }break;
        case 3:{
             UIPinchGestureRecognizer* pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
          
            [imageView addGestureRecognizer:pinch];
        }break;
        case 4:{
            UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self  action:@selector(longPressAction:)];
            [imageView addGestureRecognizer:longPress];
            
        }break;
        case 5:{
            UISwipeGestureRecognizer* swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
            [imageView addGestureRecognizer:swipe];
        }break;
        case 6:{
            UIScreenEdgePanGestureRecognizer* scress = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(scressAction:)];
            [self.view addGestureRecognizer:scress];
            scress.edges=UIRectEdgeLeft;
//            scress.edges=UIRectEdgeRight;
        }break;
        default:
            break;
    }
}
-(void)tapAtion:(id)sender{
    NSLog(@"单击");
//    [imageView removeGesture]
    NSString* str = [NSString stringWithFormat:@"tupian/run2.tiff"];
    UIImage * image2=[UIImage imageNamed:str];
    imageView.image=image2;
}
-(void)dragAction:(id)sender{
    NSLog(@"拖拽");
    //向量translation
    UIPanGestureRecognizer* pan=(UIPanGestureRecognizer*)sender;
    
    CGPoint translation=[sender translationInView:self.view];
    
    pan.view.center=CGPointMake(pan.view.center.x+translation.x, pan.view.center.y+translation.y);
    [pan setTranslation:CGPointZero inView:imageView];
    
    
}
-(void)rotateAction:(UIRotationGestureRecognizer*)sender{
    NSLog(@"旋转");

    
    sender.view.transform=CGAffineTransformRotate(sender.view.transform, sender.rotation);
    sender.rotation=0;//旋转的弧度为180
    
}
-(void)pinchAction:(id)sender{
    NSLog(@"捏合");
 
    UIPinchGestureRecognizer* pinch=(UIPinchGestureRecognizer*)sender;
    imageView.transform=CGAffineTransformMakeScale(pinch.scale, pinch.scale);
    
}
-(void)longPressAction:(id)sender{
    NSLog(@"长");
}
-(void)swipeAction:(id)sender{
    NSLog(@"轻扫");
//    UISwipeGestureRecognizer* swipe=(UISwipeGestureRecognizer*)sender;
    for (UIView* view in [self.view subviews]) {
        if ([view isMemberOfClass:[UISegmentedControl class]]) {
            UISegmentedControl * seg=(UISegmentedControl*)view;
            [seg removeSegmentAtIndex:[seg numberOfSegments]-1 animated:YES];
            //根据操作需要自行调用segment触发方法
            seg.selectedSegmentIndex=-1;
            [self segmentAtion:seg];
        }
    }
    
}
-(void)scressAction:(id)sender{
    
    UIScreenEdgePanGestureRecognizer* edge=(UIScreenEdgePanGestureRecognizer*)sender;
 
    UIView* view=[self.view hitTest:[edge locationInView:edge.view] withEvent:nil];
    view.alpha=0.5;
    if (UIGestureRecognizerStateBegan==edge.state||UIGestureRecognizerStateChanged==edge.state) {
//        向量获取通过ScreenEdge手势方法
        CGPoint translation=[edge translationInView:edge.view];
        if (edge.edges==UIRectEdgeLeft)
        {
            //目标视图的center坐标根据向量translation做改变
            imageView.center=CGPointMake(self.view.center.x+translation.x,imageView.center.y);
        }
    }
    else {
        [UIView animateWithDuration:1 animations:^{imageView.center=CGPointMake(self.view.center.x,self.view.center.y);}];
        }
        
        
    
    
    NSLog(@"边缘");
}

//-(void)segementAction:(UISegmentedControl*)segment{
//    //手势管理
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
