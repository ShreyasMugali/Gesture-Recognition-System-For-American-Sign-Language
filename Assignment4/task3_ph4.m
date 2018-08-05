clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_ph4\DM\');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\DM\';
ges_list=["","","ABOUT", "AND", "CAN", "COP", "DEAF", "DECIDE", "FATHER", "FIND", "GO-OUT", "HEARING"];

for i=3:length(listing)
    file=listing(i).name;
    file_path=strcat(pathie,file);
    ges_name=ges_list(i);
    opfolderName = strcat('C:\Data\Spring 2018\DM\CSVFiles_ph4\eigen');
    if ~exist(opfolderName,'dir')
        mkdir(opfolderName);
    end
    opfilename=strcat(opfolderName,'\',ges_name,'_eig','.csv');
    file_csv=readtable(file_path);
    M = table2array(file_csv);
    covM = cov(M);
    [eigMV,eigMD] = eig(covM);
    ges_name;
    ter=eigMD(47,47)/trace(eigMD);
    [coeff,score,latent] = pca(M);
    dlmwrite(opfilename,eigMV(:,43:47),'-append');
end


