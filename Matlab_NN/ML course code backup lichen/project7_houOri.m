% ���-�糧�������

% �������ռ�
clc;
clear;
close all;

% ��ȡEXCEL���
% [NUM]=xlsread('oriData'); %�ѽ��������ݴ��һ������

load('oriData_mat.mat');

% ѵ������
P=NUM(:,1:18);%��ȡ���е��������
T=NUM(:,20);%��ȡ���е��������
T2=NUM(:,19);

T=T-8;%��ȥ���еĻ���ֵ
T2=T2-18;%��ȥ���еĻ���ֵ

% �����ݽ��й�һ��(��ȡ���ֵ)
m=max(max(P));
n=max(T);% ���1���ֵ
nt2=max(T2);% ���2���ֵ

% ���й�һ������
P=P'/m;
T=T'/n;
T2=T2'/nt2;


% %%%%%%%%%%%%%���������磨ǰ�����ʹ�õķ�����
% net_1=newff(minmax(P),T,[60 60 60 60]);%,{'tansig','purelin'},'traingd');
% net_2=newff(minmax(P),T,[25 25 25 25]);%,{'tansig','purelin'},'traingd');

%%%%%%%%%%%%%����������
net_1=newff(minmax(P),T,[15 15 15]);%,{'tansig','purelin'},'traingd');
% net_2=newff(minmax(P),T,[30 30 30]);


%%%%%%%%%%%%��������
net_1.trainParam.show = 1;
net_1.trainParam.lr = 0.00002;%ѧϰ����
net_1.trainParam.mc = 0.3;
net_1.trainParam.epochs = 100000;%���ѭ������
net_1.trainParam.goal = 0.0000001;%�����õ�����С���ֵ

% net_2.trainParam.show = 1;
% net_2.trainParam.lr = 0.003;%ѧϰ����
% net_2.trainParam.mc = 0.3;
% net_2.trainParam.epochs = 100000;%���ѭ������
% net_2.trainParam.goal = 0.000005;%�����õ�����С���ֵ

%%%%%%%%%�����е��������ݽ���ѵ��
[net_1,tr]=train(net_1,P,T);  
% [net_2,tr2]=train(net_2,P,T2);  
%%%%%%%%%%��������з���
r= sim(net_1,P);
% r2 = sim(net_2,P);
% disp('������������')


R=r'*n;
% R2=r2'*nt2;
%plot(P0,T0,P0,R)

% disp('ʵ������������������')
E=T'*n-R;
% E2=T2'*nt2-R2;

% ��ͼ�Ƚ����ߵ����������ϵ
figure(1);
plot(T*n+8,'r');
hold on;
grid on;
plot(R+8,'b');
plot(E,'k');
axis([0 450 -1 12]);
set(gcf,'color','w'); %�����������
title('FI163 Ԥ��������'); %���
legend('ԭʼ������','ģ��Ԥ����','���');


% figure(2);
% plot(T2*nt2+18,'r');
% hold on;
% grid on;
% plot(R2+18,'b');
% plot(E2,'k');
% axis([0 450 0 30]);
% set(gcf,'color','w'); %�����������
% title('FI112 Ԥ��������'); %���
% legend('ԭʼ������','ģ��Ԥ����','���');











% ===============================��ɺɺ����ԭ��
% 
% %%%%%%%����ѵ��������%%%
% P=[20 40; 20 60;20 80; 20 100;40 60;40 80;40 100; 60 80];
% %P1 = [P;P;P;P;P];
% T=[125.54; 116.84;121.45; 124.65; 127.97;124.75;131.50; 140.99];
% %T1 = [T;T;T;T;T];
% 
% %%%%%%%%%%%%��P��T���й�һ��
% % P=mapminmax(P);
% % T=mapminmax(T);
% m=max(max(P));
% n=max(T);
% P=P'/m;
% T=T'/n;
% 
% 
% 
% %%%%%%%%%%%%%����������
% net_1=newff(minmax(P),T,[4,4])%,{'tansig','purelin'},'traingd');%%%%%
% net.inputWeights{randi(1,1),randi(1,1)}.iniFcn='rands';
% 
% 
% %%%%%%%%%%%%��������
% net_1.trainParam.show = 1;
% net_1.trainParam.lr = 0.0001;%ѧϰ����
% net_1.trainParam.mc = 0.5;
% net_1.trainParam.epochs = 10000000;%���ѭ������
% net_1.trainParam.goal = 0.0001;%�����õ�����С���ֵ
% 
% %%%%%%%%%�����е��������ݽ���ѵ��
% [net_1,tr]=train(net_1,P,T);  
% %%%%%%%%%%��������з���
% r= sim(net_1,P);
% disp('������������')
% R=r'*n
% %plot(P0,T0,P0,R)
% 
% disp('ʵ������������������')
% E=T'*n-R
% 
% %%%%%%%%��������в���
% x=[60 100];
% x=x'/m;
% m=sim(net_1,x);
% disp('����������Ϊ[60 100]ʱ�������')
% M=m'*n