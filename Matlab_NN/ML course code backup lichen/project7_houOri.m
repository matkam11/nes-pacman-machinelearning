% 侯建民-电厂数据拟合

% 清理工作空间
clc;
clear;
close all;

% 读取EXCEL表格
% [NUM]=xlsread('oriData'); %已将所有数据存成一个矩阵

load('oriData_mat.mat');

% 训练数据
P=NUM(:,1:18);%截取其中的输入变量
T=NUM(:,20);%截取其中的输出变量
T2=NUM(:,19);

T=T-8;%减去其中的基础值
T2=T2-18;%减去其中的基础值

% 对数据进行归一化(求取最大值)
m=max(max(P));
n=max(T);% 输出1最大值
nt2=max(T2);% 输出2最大值

% 进行归一化处理
P=P'/m;
T=T'/n;
T2=T2'/nt2;


% %%%%%%%%%%%%%建立神经网络（前面可以使用的方法）
% net_1=newff(minmax(P),T,[60 60 60 60]);%,{'tansig','purelin'},'traingd');
% net_2=newff(minmax(P),T,[25 25 25 25]);%,{'tansig','purelin'},'traingd');

%%%%%%%%%%%%%建立神经网络
net_1=newff(minmax(P),T,[15 15 15]);%,{'tansig','purelin'},'traingd');
% net_2=newff(minmax(P),T,[30 30 30]);


%%%%%%%%%%%%参数设置
net_1.trainParam.show = 1;
net_1.trainParam.lr = 0.00002;%学习速率
net_1.trainParam.mc = 0.3;
net_1.trainParam.epochs = 100000;%最大循环次数
net_1.trainParam.goal = 0.0000001;%期望得到的最小误差值

% net_2.trainParam.show = 1;
% net_2.trainParam.lr = 0.003;%学习速率
% net_2.trainParam.mc = 0.3;
% net_2.trainParam.epochs = 100000;%最大循环次数
% net_2.trainParam.goal = 0.000005;%期望得到的最小误差值

%%%%%%%%%用已有的输入数据进行训练
[net_1,tr]=train(net_1,P,T);  
% [net_2,tr2]=train(net_2,P,T2);  
%%%%%%%%%%对网络进行仿真
r= sim(net_1,P);
% r2 = sim(net_2,P);
% disp('神经网络的输出：')


R=r'*n;
% R2=r2'*nt2;
%plot(P0,T0,P0,R)

% disp('实际输出与网络输出的误差：')
E=T'*n-R;
% E2=T2'*nt2-R2;

% 作图比较两者的输入输出关系
figure(1);
plot(T*n+8,'r');
hold on;
grid on;
plot(R+8,'b');
plot(E,'k');
axis([0 450 -1 12]);
set(gcf,'color','w'); %配置输出背景
title('FI163 预测结果曲线'); %输出
legend('原始输出结果','模型预测结果','误差');


% figure(2);
% plot(T2*nt2+18,'r');
% hold on;
% grid on;
% plot(R2+18,'b');
% plot(E2,'k');
% axis([0 450 0 30]);
% set(gcf,'color','w'); %配置输出背景
% title('FI112 预测结果曲线'); %输出
% legend('原始输出结果','模型预测结果','误差');











% ===============================黄珊珊部分原版
% 
% %%%%%%%用于训练的数据%%%
% P=[20 40; 20 60;20 80; 20 100;40 60;40 80;40 100; 60 80];
% %P1 = [P;P;P;P;P];
% T=[125.54; 116.84;121.45; 124.65; 127.97;124.75;131.50; 140.99];
% %T1 = [T;T;T;T;T];
% 
% %%%%%%%%%%%%对P和T进行归一化
% % P=mapminmax(P);
% % T=mapminmax(T);
% m=max(max(P));
% n=max(T);
% P=P'/m;
% T=T'/n;
% 
% 
% 
% %%%%%%%%%%%%%建立神经网络
% net_1=newff(minmax(P),T,[4,4])%,{'tansig','purelin'},'traingd');%%%%%
% net.inputWeights{randi(1,1),randi(1,1)}.iniFcn='rands';
% 
% 
% %%%%%%%%%%%%参数设置
% net_1.trainParam.show = 1;
% net_1.trainParam.lr = 0.0001;%学习速率
% net_1.trainParam.mc = 0.5;
% net_1.trainParam.epochs = 10000000;%最大循环次数
% net_1.trainParam.goal = 0.0001;%期望得到的最小误差值
% 
% %%%%%%%%%用已有的输入数据进行训练
% [net_1,tr]=train(net_1,P,T);  
% %%%%%%%%%%对网络进行仿真
% r= sim(net_1,P);
% disp('神经网络的输出：')
% R=r'*n
% %plot(P0,T0,P0,R)
% 
% disp('实际输出与网络输出的误差：')
% E=T'*n-R
% 
% %%%%%%%%对网络进行测试
% x=[60 100];
% x=x'/m;
% m=sim(net_1,x);
% disp('神经网络输入为[60 100]时的输出：')
% M=m'*n