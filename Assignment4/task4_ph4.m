clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_ph4\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\';
listing1 = dir('C:\Data\Spring 2018\DM\CSVFiles_ph4\eigen\');
pathie1 = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\eigen\';

for j=3:length(listing)-1
    fold = listing(j).name;
    fold_path = strcat(pathie,fold);
    fold_listing = dir(fold_path);
    for i=3:length(fold_listing)
        fmat = fold_listing(i).name;
        fmat_path = strcat(fold_path,'\',fmat);
        fname = strtok(fmat,'_');
        opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles_ph4\',fold,'\',fname,'_fmnew','.csv');
        pmat = strcat(fname,'_eig','.csv');
        pmat_path = strcat(pathie1,pmat);
        M1 = table2array(readtable(fmat_path));
        M2 = table2array(readtable(pmat_path));
        M = M1*M2;
        dlmwrite(opfilename,M,'-append')
    end
end
        
        
        
