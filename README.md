# LayerAnimation
汽车仪表动画
//使用
//创建
layer = [[LayerAnimation alloc]initWithFrame:CGRectMake(30, 50, 300, 300)];
[self.view addSubview:layer];
//设置当前进度值
[layer setProgress:0.7];
