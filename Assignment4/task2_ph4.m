clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSVFiles_user');
pathie = 'C:\Data\Spring 2018\DM\CSVFiles_user\';
pathie1 = 'C:\Data\Spring 2018\DM\CSVFiles_ph4\';
ges_list=["ABOUT", "AND", "CAN", "COP", "DEAF", "DECIDE", "FATHER", "FIND","GO-OUT", "HEARING"];
count = 0;
for j=3:length(listing)
    fold=listing(j).name;
    fold_path=strcat(pathie,fold);
    fold_listing=dir(fold_path);
    for i=3:length(fold_listing)
        file=fold_listing(i).name;
        file_path=strcat(fold_path,'\',file);
        if length(fold_listing) == 12
            count = count+1;
            if count <= 100
                opfolderName = strcat(pathie1,'DM');
            else
                opfolderName = strcat(pathie1,fold);
            end
            if ~exist(opfolderName,'dir')
                mkdir(opfolderName);
            end
            opfilename=strcat(opfolderName,'\',strtok(file,'.'),'_fm','.csv');
            if count <= 100
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
                mat6 = findRMS(x);
                M = [mat1 mat2 mat3 mat4 mat5 mat6];
                dlmwrite(opfilename,M,'-append')
            else
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
                mat6 = findRMS(x);
                M = [mat1 mat2 mat3 mat4 mat5 mat6];
                dlmwrite(opfilename,M,'-append')
            end
            
        end
    end
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