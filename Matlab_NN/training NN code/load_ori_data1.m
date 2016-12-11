% load the train data of marial

clc;
clear;
close all;

% ====
addpath('data_2');

% % read the data from input.txt
% fid=fopen('data_0.txt','r');
% [f,count]=fscanf(fid,'%f %f',[2 169]);
% fclose(fid);
% 
% for i=1:40
%     ref=reshape(f(i,:),13,13);
%     ref=ref';
%     
%     imagesc(ref);
%     pause(0.3);
% end

% ============================
% % get the original data
% oriData=importdata('data_2.txt');
% % show the data
% [m, n]=size(oriData);
% figure;
% for i=1:m
%     fangMat=reshape(oriData(i,:),13,13); % reshape the data
%     imagesc(fangMat');
%     pause(0.03);
%     disp(['The frame -> ',num2str(i)]);    
% end


% ============================
oriLabel=importdata('labels_0.txt');

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


            







