clc ;close all;clear all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_user_data\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_user_data\';
M2 = zeros(37,4);
for j=3:length(listing)
    fold = listing(j).name;
    fold_path = strcat(pathie,fold);
    fold_listing = dir(fold_path);
    if length(fold_listing) == 3
        fmat = fold_listing(3).name;
        fmat_path = strcat(fold_path,'\',fmat);
        file_csv = readtable(fmat_path);
        x = table2array(file_csv);
        % shuffledArray = x(randperm(size(x,1)),:);
        [trainInd,valInd,testInd] = dividerand(x',0.6,0,0.4);

        trdata=trainInd';
        tesdata=testInd';

        trdata1=trdata(:,1:5);
        targe=trdata(:,6);
        vec = ind2vec(targe') ;
        trtarget_var = full(vec');

        tesdata1=tesdata(:,1:5);
        tarorg=tesdata(:,6);
        vec = ind2vec(tarorg') ;
        testarget_var = full(vec') ;

        trainFcn = 'trainscg';
        net = patternnet([5,10], trainFcn);

        % Train the Network
        [net,tr] = train(net,trdata1',trtarget_var');

        % Test the Network
        y = net(tesdata1');

        y=vec2ind(y);
        testarget_var=vec2ind(testarget_var');

        stats=confusionmatStats(testarget_var,y);
        M2(j-2,1) = nanmean(stats.precision);
        M2(j-2,2) = nanmean(stats.recall);
        M2(j-2,3) = nanmean(stats.Fscore);
        M2(j-2,4) = nanmean(stats.accuracy);
    else
        M2(j-2,1) = 0; 
        M2(j-2,2) = 0; 
        M2(j-2,3) = 0; 
        M2(j-2,4) = 0; 
    end
end



    