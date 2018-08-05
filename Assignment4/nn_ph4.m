clc ;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_ph4\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\DM\';
pathie1 = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\';
M2 = zeros(15,4);

fold_listing = dir(pathie);
fmat_path = strcat(pathie,'\','datamat.csv');
file_csv = readtable(fmat_path);
x = table2array(file_csv);
trdata=x;

%trdata = array2table(trdata);
trdata1=trdata(:,1:5);
targe=trdata(:,6);
vec = ind2vec(targe') ;
trtarget_var = full(vec');

trainFcn = 'trainscg';
net = patternnet([5,10], trainFcn);

% Train the Network
[net,tr] = train(net,trdata1',trtarget_var');

for j=4:length(listing)-1
    fold = listing(j).name;
    fold_path = strcat(pathie1,fold);
    fold_listing = dir(fold_path);
    fmat_path = strcat(fold_path,'\','datamat.csv');
    file_csv = readtable(fmat_path);
    x1 = table2array(file_csv);
    tesdata=x1;

    tesdata1=tesdata(:,1:5);
    tarorg=tesdata(:,6);
    vec = ind2vec(tarorg') ;
    testarget_var = full(vec') ;

    % Test the Network
    y = net(tesdata1');

    y=vec2ind(y);
    testarget_var=vec2ind(testarget_var');

    stats=confusionmatStats(testarget_var,y);
    M2(j-3,1) = nanmean(stats.precision);
    M2(j-3,2) = nanmean(stats.recall);
    M2(j-3,3) = nanmean(stats.Fscore);
    M2(j-3,4) = nanmean(stats.accuracy);
 end



    