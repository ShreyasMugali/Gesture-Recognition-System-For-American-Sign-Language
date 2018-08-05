clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_user');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_user\';
pathie1 = 'C:\Data\Spring 2018\DM\CSVFiles_user_data\';
for j=3:length(listing)
    fold = listing(j).name;
    fold_path = strcat(pathie,fold);
    fold_listing = dir(fold_path);
    opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles_user_data\',fold,'\','datamat','.csv');
    folderName = strcat(pathie1,fold);
    if ~exist(folderName,'dir')
        mkdir(folderName);
    end
    k = 1;
    for i=5:3:length(fold_listing)
        if i > 3
            fmat = fold_listing(i).name;
            fmat_path = strcat(fold_path,'\',fmat);
            file_csv = readtable(fmat_path);
            x = table2array(file_csv);
            TF = isempty(x);
            if TF ~= 1
                siz = size(x,1);
                A = ones(siz,1)*k;
                x = [x A];
                k = k+1;
                dlmwrite(opfilename,x,'-append')
            end
        end
    end
end