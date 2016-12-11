% input and output based on trained model by txt file

clc;
clear;
close all

% load the model
disp('load NN model');
load('train_result1.mat');

%=============

loopCount=0;
while 1
    tic;
    % check the flag  
    disp('wait the flag...');
    while 1
        fid=fopen('d:\flag.txt','r');
        [f,count]=fscanf(fid,'%f',[1 1]);
        fclose(fid);
        if f==1
            disp('f=1 break');
            break;
        end
    end
    
    % load the data
    inputDataFile=fopen('d:\inputData.txt','r');
    [inputData,count]=fscanf(inputDataFile,'%f',[1 169]);
    fclose(inputDataFile);

    % input into the model and get output
    output=sim(net_1,inputData');
    output=round(output);
    % write the output to the result.txt file
    outputFile=fopen('d:/output.txt','wt');    
    fprintf(outputFile,'%c',num2str(output));
    fclose(outputFile);
    
    % reset the flag
    resetFile=fopen('d:\flag.txt','wt');
    fprintf(resetFile,'%c',num2str(0));
    fclose(resetFile);
    
    disp(['loop = ',num2str(loopCount)]); % show the number of loop  
    loopCount=loopCount+1;
    toc;
end
