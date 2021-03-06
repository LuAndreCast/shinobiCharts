//
//  CandlestickViewController.m
//  shinobiCharts
//
//  Created by Luis Castillo on 9/28/16.
//  Copyright © 2016 LC. All rights reserved.
//

#import "CandlestickViewController.h"

@interface CandlestickViewController ()

@property (strong, nonatomic) CandlestickDatasource *datasource;
@property (strong, nonatomic) ShinobiChart *chart;

// Dictionary mapping series indices to mutable arrays of data point indices
@property (strong, nonatomic) NSMutableDictionary *selectedDonutIndices;

// Dictionary mapping series indices to rotation angles
@property (strong, nonatomic) NSMutableDictionary *rotations;

@end

@implementation CandlestickViewController

@synthesize chartView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //chart init
    CGFloat margin = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 10.0 : 30.0;
    self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.chartView.bounds, margin, margin)];
    [self.chartView addSubview:self.chart];
    self.chart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //data source setup
    self.datasource = [[CandlestickDatasource alloc]init];
    self.chart.datasource = self.datasource;
    
    [self setupChart];
    [self setupTheme];
    [self setupHorizontalLegend];
}//eom


#pragma mark - Setup
-(void)setupChart
{
    self.chart.title = @"Candlestick chart";
    
    self.chart.delegate = self;
    
    //Legend
    self.chart.legend.hidden = YES;
    
    //License Key
    self.chart.licenseKey = [[Constants shared] getLicenseKey];
    
    
    /* X Axis */
    self.chart.xAxis = [SChartDateTimeAxis new];
    self.chart.xAxis.title = @"";
    self.chart.xAxis.labelFormatString = @"MM dd yy";
    self.chart.xAxis.majorTickFrequency = [[SChartDateFrequency alloc]initWithDay:1];
    
    self.chart.xAxis.style.majorTickStyle.showTicks = TRUE;
    
    /* Y Axis */
    self.chart.yAxis = [SChartNumberAxis new];
    self.chart.yAxis.defaultRange = [[SChartNumberRange alloc] initWithMinimum:@0 andMaximum:@100];
    self.chart.yAxis.title = @"Value in £s";
    
//    // Add second y-axis: rainfall, in reverse position (i.e. on right hand side)
//    SChartNumberAxis *secondAxis = [SChartNumberAxis new];
//    secondAxis.axisPosition = SChartAxisPositionReverse;
//    secondAxis.defaultRange = [[SChartRange alloc] initWithMinimum:0 andMaximum:@160];
//    secondAxis.title = @"Rainfall (mm)";
//    [self.chart addYAxis:secondAxis];
    
    
    for (SChartAxis *axis in self.chart.allAxes) {
        axis.enableGesturePanning = YES;
        axis.enableGestureZooming = YES;
        axis.enableMomentumPanning = YES;
        axis.enableMomentumZooming = YES;
    }
}//eom

-(void)setupTheme
{
    SChartTheme * theme = [SChartiOS7Theme new];
    
    UIColor *darkGrayColor = [UIColor colorWithRed:83.0/255 green:96.0/255 blue:107.0/255 alpha:1];
    theme.chartTitleStyle.font = [UIFont systemFontOfSize:18];
    theme.chartTitleStyle.textColor = darkGrayColor;
    theme.chartTitleStyle.titleCentresOn = SChartTitleCentresOnChart;
    theme.chartStyle.backgroundColor = [UIColor whiteColor];
    theme.legendStyle.borderWidth = 0;
    theme.legendStyle.font = [UIFont systemFontOfSize:16];
    theme.legendStyle.titleFontColor = darkGrayColor;
    theme.legendStyle.fontColor = darkGrayColor;
    theme.crosshairStyle.defaultFont = [UIFont systemFontOfSize:14];
    theme.crosshairStyle.defaultTextColor = darkGrayColor;
    
    [self styleAxisStyle:theme.xAxisStyle useLightLabelFont:YES];
    [self styleAxisStyle:theme.yAxisStyle useLightLabelFont:YES];
    [self styleAxisStyle:theme.xAxisRadialStyle useLightLabelFont:NO];
    [self styleAxisStyle:theme.yAxisRadialStyle useLightLabelFont:NO];
    
    
    [self.chart applyTheme:theme];
}//eom

#pragma mark - Setup Helpers
- (void)styleAxisStyle:(SChartAxisStyle *)style useLightLabelFont:(BOOL)useLightLabelFont
{
    UIColor *darkGrayColor = [UIColor colorWithRed:83.0/255 green:96.0/255 blue:107.0/255 alpha:1];
    
    style.titleStyle.font = [UIFont systemFontOfSize:16];
    style.titleStyle.textColor = darkGrayColor;
    if (useLightLabelFont) {
        style.majorTickStyle.labelFont = [UIFont systemFontOfSize:14];
    } else {
        style.majorTickStyle.labelFont = [UIFont systemFontOfSize:14];
    }
    style.majorTickStyle.labelColor = style.titleStyle.textColor;
    style.majorTickStyle.lineColor = style.titleStyle.textColor;
    style.lineColor = style.titleStyle.textColor;
}//eom


- (void)setupHorizontalLegend
{
    self.chart.legend.hidden = NO;
    
    self.chart.legend.position = SChartLegendPositionBottomMiddle;
    
    self.chart.legend.style.horizontalPadding = @10;
    self.chart.legend.style.orientation = SChartLegendOrientationHorizontal;
    self.chart.legend.style.symbolAlignment = SChartSeriesLegendAlignSymbolsLeft;
    self.chart.legend.style.textAlignment = NSTextAlignmentLeft;
}//eom


@end


