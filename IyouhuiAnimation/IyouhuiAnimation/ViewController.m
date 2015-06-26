//
//  ViewController.m
//  IyouhuiAnimation
//
//  Created by keyzhang on 14-10-17.
//  Copyright (c) 2014年 keyzhang. All rights reserved.
//

#import "ViewController.h"

#define kCellWidth 100
#define kCellHeight 100


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *cellsArray;//此数组用来存放当前显示的cell，用于随机取cell
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.
    self.collectionView.delegate  = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
    
    return cell;

}

//int i = 0;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *allCells = [self.collectionView visibleCells];
    
    cellsArray = [NSMutableArray arrayWithArray:allCells];
    
    [self doAnimation];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(200, 100);
    }
    return CGSizeMake(kCellWidth, kCellHeight);
}


#pragma mark -Animation Method
- (void)doAnimation
{
    if (cellsArray.count == 0) {
        return;
    }
    
//    srandom(time(0));
    long m = random()%(cellsArray.count);
    
    UICollectionViewCell *cell = [cellsArray objectAtIndex:m];
    [cellsArray removeObjectAtIndex:m];
    
    CGRect firstframe = cell.frame;
    //设置cell的锚点坐标
    cell.layer.anchorPoint = CGPointMake(-cell.frame.origin.x/kCellWidth, .5);
    
    CATransform3D originTrans = cell.layer.transform;

    CATransform3D trans = cell.layer.transform;
    trans.m34 = 1.f/10000.f;
    cell.layer.transform = trans;
    
    //这里需要将frame重新设置一下
    cell.frame = firstframe;
    //动画变量创建 （keyPath）
    CABasicAnimation *FlipAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    //(时间模式)
    FlipAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //目标量
    FlipAnimation.toValue= [NSNumber numberWithFloat:M_PI_2];
    //动画时间
    FlipAnimation.duration=.55;
    
    //动画结束后是否保留效果
    FlipAnimation.removedOnCompletion=NO;
    FlipAnimation.fillMode=kCAFillModeForwards;
    [cell.layer addAnimation:FlipAnimation forKey:@"flip"];
    
    [UIView animateWithDuration:.55 animations:^{
        cell.alpha = 0;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
        cell.layer.anchorPoint = CGPointMake(.5, .5);
        cell.layer.frame = firstframe;
        cell.layer.transform = originTrans;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.layer removeAnimationForKey:@"flip"];
        });
        
    }];
    
    if (cellsArray.count == 0) {
        [self performSelector:@selector(doPush) withObject:nil afterDelay:.35];
        return;
    }
    
    [self performSelector:@selector(doAnimation) withObject:nil afterDelay:.01];
    
}



-(void)doPush{
    UIViewController *vc = [[UIViewController alloc] init];
    [vc.view setBackgroundColor:[UIColor redColor]];
    [self.navigationController pushViewController:vc animated:YES];
}





@end
