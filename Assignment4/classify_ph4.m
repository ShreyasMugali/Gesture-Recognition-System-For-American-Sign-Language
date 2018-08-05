clc ;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_ph4\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\DM\';
pathie1 = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\';
M = zeros(15,4);M1 = zeros(15,4);

fold_listing = dir(pathie);
fmat_path = strcat(pathie,'\','datamat.csv');
file_csv = readtable(fmat_path);
x = table2array(file_csv);
trdata=x;
trdata = array2table(trdata);

mdl=fitcecoc(trdata,'trdata6');

mdl1=fitctree(trdata,'trdata6');

for j = 4:length(listing)-1
    fold = listing(j).name;
    fold_path = strcat(pathie1,fold);
    fold_listing = dir(fold_path);
    fmat_path = strcat(fold_path,'\','datamat.csv');
    file_csv = readtable(fmat_path);
    x1 = table2array(file_csv);
    
    tesdata=x1;

    label = predict(mdl,tesdata(:,1:5));

    stats = confusionmatStats(tesdata(:,6),label);

    M(j-3,1) = nanmean(stats.precision);
    M(j-3,2) = nanmean(stats.recall);
    M(j-3,3) = nanmean(stats.Fscore);
    M(j-3,4) = nanmean(stats.accuracy);

    label1 = predict(mdl1,tesdata(:,1:5));

    stats1 = confusionmatStats(tesdata(:,6),label1);

    M1(j-3,1) = nanmean(stats1.precision);
    M1(j-3,2) = nanmean(stats1.recall);
    M1(j-3,3) = nanmean(stats1.Fscore);
    M1(j-3,4) = nanmean(stats1.accuracy);
end

