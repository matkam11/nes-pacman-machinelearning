


% read the data from input.txt
fid=fopen('d:\.txt','r');
[f,count]=fscanf(fid,'%f %f',[1 5]);
fclose(fid);




% output the data to output.txt
% fid=fopen('output.txt','wt');
% a=[1 2 3 4 5 6 12 34];
% fprintf(fid,'%c',num2str(a));
% fclose(fid);



