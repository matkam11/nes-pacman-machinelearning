% load the train data of marial

clc;
clear;
close all;

% load and arrange all the data
% =================================================================
addpath('data_2');

% all the training data
featureDataAll=[];
labelDataAll=[];

for file_count=0:10   
    
    dataFileName=['data_',num2str(file_count),'.txt'];
    labelFileName=['labels_',num2str(file_count),'.txt'];    
    
    % ============================
    % get the original data
    oriData=importdata(dataFileName);
    
    % ============================
    oriLabel=importdata(labelFileName);
    % get the binary decision output
    [control_m control_n]=size(oriLabel);%get the size of the control label
    oriLabelBin=zeros(control_m,6); % initial the whole control decision matrix
    for control_count=1:control_m
        con_ins=oriLabel(control_count,1);%get one control instance
        con_ins=con_ins{1};
        [mt, nt]=size(con_ins); % get the size of the text
        input_count=1;
        for i=1:nt
            if con_ins(i)=='t'
                oriLabelBin(control_count,input_count)=1;
                input_count=input_count+1;
            end
            if con_ins(i)=='f'
                oriLabelBin(control_count,input_count)=0;
                input_count=input_count+1;
            end
        end
    end       
    featureDataAll=[featureDataAll;oriData];
    labelDataAll=[labelDataAll;oriLabelBin];       
end

featureDataAll=featureDataAll+1; % arrange the feature

% initial and train the data
net_1=newff(minmax(featureDataAll'),labelDataAll',[5 5]);%,{'tansig','purelin'},'traingd');

net_1.trainParam.show = 1;
net_1.trainParam.lr = 0.002;
net_1.trainParam.mc = 0.3;
net_1.trainParam.epochs = 1000;
net_1.trainParam.goal = 0.0001; 

[net_1,tr]=train(net_1,featureDataAll',labelDataAll');
outSim=sim(net_1,featrueDataAll');

roundOut=round(outSim);

figure;imagesc(labelDataAll');
figure;imagesc(roundOut);
figure;imagesc(labelDataAll'-roundOut);

correct=(labelDataAll'-roundOut)==0;
n_correct=sum(sum(correct));
rate=n_correct/(6*25155);

disp(['The accuarcy -> ',num2str(rate)]);




