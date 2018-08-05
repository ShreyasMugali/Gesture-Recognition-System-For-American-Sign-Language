clc ;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_user_data\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_user_data\';
M = zeros(37,4);M1 = zeros(37,4);
for j = 3:length(listing)
    fold = listing(j).name;
    fold_path = strcat(pathie,fold);
    fold_listing = dir(fold_path);
    if length(fold_listing) == 3
        fmat = fold_listing(3).name;
        fmat_path = strcat(fold_path,'\',fmat);
        file_csv = readtable(fmat_path);
        x = table2array(file_csv);
        shuffledArray = x(randperm(size(x,1)),:);
        [trainInd,valInd,testInd] = dividerand(x',0.6,0,0.4);

        trdata=trainInd';
        tesdata=testInd';

        trdata = array2table(trdata);
        %tesdata = array2table(tesdata)

        mdl=fitcecoc(trdata,'trdata6');
        label = predict(mdl,tesdata(:,1:5));

        stats = confusionmatStats(tesdata(:,6),label);

        M(j-2,1) = nanmean(stats.precision);
        M(j-2,2) = nanmean(stats.recall);
        M(j-2,3) = nanmean(stats.Fscore);
        M(j-2,4) = nanmean(stats.accuracy);
        
        mdl1=fitctree(trdata,'trdata6');
        label1 = predict(mdl1,tesdata(:,1:5));

        stats1 = confusionmatStats(tesdata(:,6),label1);

        M1(j-2,1) = nanmean(stats1.precision);
        M1(j-2,2) = nanmean(stats1.recall);
        M1(j-2,3) = nanmean(stats1.Fscore);
        M1(j-2,4) = nanmean(stats1.accuracy);
    else
        M(j-2,1) = 0; M1(j-2,1) = 0;
        M(j-2,2) = 0; M1(j-2,2) = 0;
        M(j-2,3) = 0; M1(j-2,3) = 0;
        M(j-2,4) = 0; M1(j-2,4) = 0;
    end
end

