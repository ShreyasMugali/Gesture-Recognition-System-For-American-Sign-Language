clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_user');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_user\';
listing1 = dir('C:\Data\Spring 2018\DM\CSVFiles_FE');
pathie1 = 'C:\Data\Spring 2018\DM\CSVFiles_FE\';

for j=3:length(listing)
    fold = listing(j).name;
    fold_path = strcat(pathie,fold);
    fold_listing = dir(fold_path);
    for i=4:2:length(fold_listing)
        fmat = fold_listing(i).name;
        fmat_path = strcat(fold_path,'\',fmat);
        fname = strtok(fmat,'_');
        opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles_user\',fold,'\',fname,'_fmnew','.csv');
        pmat = strcat(fname,'_pca','.csv');
        pmat_path = strcat(pathie1,pmat);
        M1 = table2array(readtable(fmat_path));
        M2 = table2array(readtable(pmat_path));
        TF = isempty(M1);
        if TF ~= 1;
            M = M1*M2;
        else
            M = [];
        end
        dlmwrite(opfilename,M,'-append')
    end
end
        
        
        
