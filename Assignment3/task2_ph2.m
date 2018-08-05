clc;clear all;close all;

filename = 'C:\Data\Spring 2018\DM\CSE572_A2_data\DM09\ABOUT120839PM.csv';
opts = detectImportOptions(filename);opts.SelectedVariableNames = [1:34];opts.VariableNamesLine = 1;
tab1 = readtable(filename,opts,'ReadVariableNames',1);tab1 = tab1(:,1:34);
sensors = tab1.Properties.VariableNames;
 
listing = dir('C:\Data\Spring 2018\DM\CSVFiles');
pathie='C:\Data\Spring 2018\DM\CSVFiles\';
ges_list=["","","ABOUT", "AND", "CAN", "COP", "DEAF", "DECIDE", "FATHER", "FIND", "GO-OUT", "HEARING"];

for i=3:length(listing)
    file=listing(i).name;
    file_path=strcat(pathie,file);
    ges_name=ges_list(i);
    opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles_FE\',ges_name,'_pca','.csv');
    file_csv=readtable(file_path);
    x = table2array(file_csv);
    [l1,l2] = size(x);

    mat1 = findFFT(x);
    mat2 = findMean(x);
    mat3 = findVar(x);
    
    emgl = zeros(l1/34,l2);
    emgr = zeros(l1/34,l2);   
    k = 1;
    for s = 7:34:l1
        for s1 = s:s+7
            emgl(k,:) = emgl(k,:)+x(s1,:);
            emgr(k,:) = emgr(k,:)+x(s1+8,:);
            s1 = s1-8;
        end
    k = k+1;
    end
    [h,~] = findDWT(emgl(1,:),3);
    mat4 = zeros(l1/34,size(h,2));mat5 = zeros(l1/34,size(h,2));
    for t = 1:l1/34
        [ca1,cd1] = findDWT(emgl(t,:),3);
        [ca2,cd2] = findDWT(emgr(t,:),3);
        mat4(t,:) = ca1;mat5(t,:) = ca2;
    end
%     figure,subplot(2,1,1),plot(var(emgl,1,2),'r','DisplayName','Left Hand'),hold on,plot(var(emgr,1,2),'b','DisplayName','Right Hand'),title({ges_name,'EMG signals'}),hold off;
%     xlabel('Number of persons*Number of actions'),ylabel('Sum of 8 EMG sensor values');legend('show');
%     subplot(2,1,2),plot(mat4,'r'),hold on,plot(mat5,'b'),title('DWT of EMG Signals'),hold off;
%     xlabel('Number of persons*Number of actions'),ylabel('Magnitude of approx coefficients after 3rd level DWT');
    
    mat6 = findRMS(x);
    
    M = [mat1 mat2 mat3 mat4 mat5 mat6];
    covM = cov(M);
    [eigMV,eigMD] = eig(covM);
    ges_name
    ter=eigMD(47,47)/trace(eigMD)
    [coeff,score,latent] = pca(M);
%     var_labels = {'fft-grx1','fft-grx2','fft-grx3','fft-grx4','fft-grx5','mean-glx','mean-gly','mean-glz','mean-grx','mean-gry','mean-grz',...
%               'var-glx','var-gly','var-glz','var-grx','var-gry','var-grz','dwt-emgl1','dwt-emgl2','dwt-emgl3','dwt-emgl4','dwt-emgl5','dwt-emgl6','dwt-emgl7',...
%               'dwt-emgr1','dwt-emgr2','dwt-emgr3','dwt-emgr4','dwt-emgr5','dwt-emgr6','dwt-emgr7','rms-emgl1','rms-emgl2','rms-emgl3','rms-emgl4','rms-emgl5',...
%               'rms-emgl6','rms-emgl7','rms-emgl8','rms-emgr1','rms-emgr2','rms-emgr3','rms-emgr4','rms-emgr5','rms-emgr6','rms-emgr7','rms-emgr8'};
%     leg = {'Eigen Vector 1','Eigen Vector 2','Eigen Vector 3','Eigen Vector 4','Eigen Vector 5'};
%     tle=convertStringsToChars('Spider plot showing the top 5 eigen vectors from PCA for '+ges_name);
%     spider(eigMV(:,43:47),tle,[],var_labels,leg);
    dlmwrite(opfilename,eigMV(:,43:47),'-append');
end


function mat = findFFT(x)
    [l1,l2] = size(x);
    n = 2^nextpow2(l2);
    y = fft(x,n,2);
    P2 = abs(y/n);
    P1 = P2(:,1:n/2+1);
    P1(:,2:end-1) = 2*P1(:,2:end-1);
    mat = zeros(l1/34,size(P1,2));
    k = 1;
    for p=26:34:l1
        mat(k,:) = P1(p,:);
        k = k+1;
    end
    mat = maxk(mat,5,2);
end

function mat = findMean(x)
    [l1,l2] = size(x);
    mat = zeros(l1/34,6);
    y = mean(x,2);
    k = 1;
    for p=23:34:l1
        p2 = 1;
        for p1=p:p+5
            mat(k,p2) = y(p1);
            p2 = p2+1;
        end
        k = k+1;
    end
end

function mat = findVar(x)
    [l1,l2] = size(x);
    mat = zeros(l1/34,6);
    y = var(x,1,2);
    k = 1;
    for p=23:34:l1
        p2 = 1;
        for p1=p:p+5
            mat(k,p2) = y(p1);
            p2 = p2+1;
        end
        k = k+1;
    end
end

function [cA,cD] = findDWT(x,i)
    wname = 'db1';
    cd = x;
    for j = 1:i
        [ca1,cd1] = dwt(cd,wname);
        cd = cd1;
    end
    cA = ca1;cD = cd1;
end

function mat = findRMS(x)
    [l1,l2] = size(x);
    mat = zeros(l1/34,16);
    k = 1;
    y = rms(x,2);
    for p=7:34:l1
        p2 = 1;
        for p1=p:p+15
            mat(k,p2) = y(p1);
            p2 = p2+1;
        end
        k = k+1;
    end
end

    
