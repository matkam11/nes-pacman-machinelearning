% input and output based on trained model by txt file

clc;
clear;
close all

% load the model
disp('load NN model');
load('/home/matkam11/ML/Matlab_NN/trained_NN_net.mat');
% addpath('data_2');
%=============

% all the training data
featureDataAll=[];
labelDataAll=[];

% for file_count=0:10   
%     
%     dataFileName=['data_',num2str(file_count),'.txt'];
%     labelFileName=['labels_',num2str(file_count),'.txt'];    
%     
%     % ============================
%     % get the original data
%     oriData=importdata(dataFileName);
%     
%     % ============================
%     oriLabel=importdata(labelFileName);
%     % get the binary decision output
%     [control_m control_n]=size(oriLabel);%get the size of the control label
%     oriLabelBin=zeros(control_m,6); % initial the whole control decision matrix
%     for control_count=1:control_m
%         con_ins=oriLabel(control_count,1);%get one control instance
%         con_ins=con_ins{1};
%         [mt, nt]=size(con_ins); % get the size of the text
%         input_count=1;
%         for i=1:nt
%             if con_ins(i)=='t'
%                 oriLabelBin(control_count,input_count)=1;
%                 input_count=input_count+1;
%             end
%             if con_ins(i)=='f'
%                 oriLabelBin(control_count,input_count)=0;
%                 input_count=input_count+1;
%             end
%         end
%     end       
%     featureDataAll=[featureDataAll;oriData];
%     labelDataAll=[labelDataAll;oriLabelBin];       
% end
% 
% featureDataAll=featureDataAll+1; % arrange the feature



fidloopCount=1;
loopCount=1;
while 1
    tic;
    % check the flag  
    disp('wait the flag...');
    while 1
        fid=fopen('/home/matkam11/ML/Matlab_NN/flag.txt','r');
        [f,count]=fscanf(fid,'%f',[1 1]);
        fclose(fid);
        if f==1
            disp('f=1 break');
            break;
        end
    end
    
    % load the data
    inputDataFile=fopen('/home/matkam11/ML/Matlab_NN/inputData.txt','r');
    [inputData,count]=fscanf(inputDataFile,'%f',[1 169]);
    fclose(inputDataFile);
    
    
%     anmi=0;
%     if inputData(99)==-1
%         anmi=1;
%     end
%     if inputData(100)==-1
%         anmi=1;
%     end
%         if inputData(99)==1
%         anmi=1;
%     end
%      if inputData(100)==1
%         anmi=1;
%     end
    

    figure(1);
    mInput=reshape(inputData,13,13);
    imagesc(mInput');

    
    
    % input into the model and get output
    output_c=sim(net_1,inputData');
%     output_c(1)=anmi;
    
    if loopCount<10000
        output_c(4)=0;
        output_c(5)=1;
    end
    
         if output_c(1) > .2
        output_c(1) =1;
    end   
    
    
    figure(2);
    imagesc(output_c);
    

    %pause(0.05);

    output=round(output_c);
    % write the output to the result.txt file
    outputFile=fopen('/home/matkam11/ML/Matlab_NN/output.txt','wt');    
    fprintf(outputFile,'%c',num2str(output));
    fclose(outputFile);
    
    % reset the flag
    resetFile=fopen('/home/matkam11/ML/Matlab_NN/flag.txt','wt');
    fprintf(resetFile,'%c',num2str(0));
    fclose(resetFile);
    
    disp(['loop = ',num2str(loopCount)]); % show the number of loop  
    loopCount=loopCount+1;
    toc;
end
