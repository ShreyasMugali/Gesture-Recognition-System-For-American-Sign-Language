clc;clear all;close all;
listing = dir('C:\Data\Spring 2018\DM\CSE572_A2_data');
pathie='C:\Data\Spring 2018\DM\CSE572_A2_data\';
ges_list=["ABOUT", "AND", "CAN", "COP", "DEAF", "DECIDE", "FATHER", "FIND", "HEARING"];
for j=1:length(ges_list)
    act_count=0;
    for i=3:length(listing)
        fold=listing(i).name;
        fold_path=strcat(pathie,fold);
        fold_listing=dir(fold_path);
        ges_name=ges_list(j);
        opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles\',ges_name,'.csv');
        for k=3:length(fold_listing)
            pre_file=fold_listing(k).name;
            pre_file_path=strcat(fold_path,'\',pre_file);
            if contains(pre_file,ges_name,'IgnoreCase',true)
                pre_file_path
                ges_name
                act_count=act_count+1;
                try
                    opt= detectImportOptions(pre_file_path);
                    opt.SelectedVariableNames=[1:34];
                    opt.VariableNamesLine=1;
                    file_csv=readtable(pre_file_path,opt,'ReadVariableNames',true);
                    file_csv= file_csv(: , 1:34);
%                     ind_m=file_csv.Properties.VariableNames;
%                     ind_m=convertCharsToStrings(ind_m);
%                     act_str=strcat(ges_name,{' '},int2str(act_count),{' '});
%                     ind_m=strcat(act_str,ind_m);
%                     ind_m=transpose(ind_m);
                    if size(file_csv,1) <= 55
                        M=table2array(file_csv);
                        M=transpose(M);
                        s = size(M,2);
                        s1 = 55 - s;
                        if s1 > 0
                            M = padarray(M,[0,s1],0,'post');
                        end
                        dlmwrite(opfilename,M,'-append')
                    else
                        continue
                    end
                catch
                    continue
                end
            end
        end
    end 
end
ges_list=["go_out", "go out", "go-out", "go.out"];
for j=1:length(ges_list)
    act_count=0;
    for i=3:length(listing)
        fold=listing(i).name;
        fold_path=strcat(pathie,fold);
        fold_listing=dir(fold_path);
        ges_name='GO_OUT';
        opfilename=strcat('C:\Data\Spring 2018\DM\CSVFiles\',ges_name,'.csv');
        for k=3:length(fold_listing)
            pre_file=fold_listing(k).name;
            pre_file_path=strcat(fold_path,'\',pre_file);
            if contains(pre_file,ges_name,'IgnoreCase',true)
                pre_file_path
                ges_list(j)
                act_count=act_count+1;
                try
                    opt= detectImportOptions(pre_file_path);
                    opt.SelectedVariableNames=[1:34];
                    opt.VariableNamesLine=1;
                    file_csv=readtable(pre_file_path,opt,'ReadVariableNames',true);
                    file_csv= file_csv(: , 1:34);
%                     ind_m=file_csv.Properties.VariableNames;
%                     ind_m=convertCharsToStrings(ind_m);
%                     act_str=strcat(ges_name,{' '},int2str(act_count),{' '});
%                     ind_m=strcat(act_str,ind_m);
%                     ind_m=transpose(ind_m);
                    if size(file_csv,1) <= 55
                        M=table2array(file_csv);
                        M=transpose(M);
                        s = size(M,2);
                        s1 = 55 - s;
                        if s1 > 0
                            M = padarray(M,[0,s1],0,'post');
                        end
                        dlmwrite(opfilename,M,'-append')
                    else
                        continue
                    end
                catch
                    continue
                end
            end
        end
    end 
end