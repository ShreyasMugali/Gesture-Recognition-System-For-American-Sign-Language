clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_ph4\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\';
for j=3:length(listing)-1
    fold = listing(j).name;
    fold_path = strcat(pathie,fold);
    fold_listing = dir(fold_path);
    opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles_ph4\',fold,'\','datamat','.csv');
    folderName = strcat(pathie,fold);
    if ~exist(folderName,'dir')
        mkdir(folderName);
    end
    k = 1;
    for i=4:2:length(fold_listing)
        fmat = fold_listing(i).name;
        fmat_path = strcat(fold_path,'\',fmat);
        file_csv = readtable(fmat_path);
        x = table2array(file_csv);
        siz = size(x,1);
        A = ones(siz,1)*k;
        x = [x A];
        k = k+1;
        dlmwrite(opfilename,x,'-append')
    end
end