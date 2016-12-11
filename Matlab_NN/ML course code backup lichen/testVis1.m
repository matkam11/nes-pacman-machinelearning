


close all;
roundOut=round(outSim);

figure;imagesc(labelDataAll');
figure;imagesc(roundOut);
figure;imagesc(labelDataAll'-roundOut);

correct=(labelDataAll'-roundOut)==0;
n_correct=sum(sum(correct));
rate=n_correct/(6*25155);



% calculate the rate of correct





