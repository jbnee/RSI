% This program is to change the file name
clear all;
close all;
clc;
a=1; 
c=1;

%%%%%%%%%%%%%%%%%% Reading the data %%%%%%%%%%%%%%%%

ddd=dos('dir *.txt /b/o >file_name.dat');   % To create batch file in dos promt. If there is no text file then ddd=1
ddd=0;                                      % If create batch file then ddd=0
if ddd==0
    file=fopen('file_name.dat','r');        % file_name.dat is the batch file which contain the information ofall the file
        while(feof(file)~=1)                % to read all the files
            f2 = fgets(file);
            y=strcat(f2);                   % string concatenation
            f1 = fopen(y,'r');              % to open a specified file
                for i=1:1
                    header=fgets(f1);       % to remove the header information
                end
            data = fscanf(f1,'%20f',[4 inf]);% Reading numeric data; Total 4 columns
            a1=data(1,:);                   % to read first coloumn which is analog mode of perpendicular channel
            p1=data(2,:);                   % to read second coloumn which is photon counting mode of perpendicular channel
            a2=data(3,:);                   % to read third coloumn which is analog mode of parallel channel
            p2=data(4,:);                   % to read fourth coloumn which is photon counting mode of parallel channel
            d1=a1+p1;                       % adding parallel channel
            d2=a2+p2;                       % adding perpendicular channel
            d3=d1+d2;                       % adding perpendicular+parallel channel
            
%%%%%%%%%%%%%%%%%%%%% Saving data %%%%%%%%%%%%%%%%%%%%%%

            f_mon=y(4:4);                   % file name for month
                if f_mon=='1' 
                    f_ext1='ja';
                end
                if f_mon=='2' 
                    f_ext1='fe';
                end
                if f_mon=='3' 
                    f_ext1='mr';
                end
                if f_mon=='4' 
                    f_ext1='ap';
                end
                if f_mon=='5' 
                    f_ext1='ma';
                end
                if f_mon=='6'
                    f_ext1='jn';
                end
                if f_mon=='6'
                    f_ext1='jn';
                end
                if f_mon=='7' 
                    f_ext1='jy';
                end
                if f_mon=='8'
                    f_ext1='au';
                end
                if f_mon=='9' 
                    f_ext1='se';
                end
                if f_mon=='A' 
                    f_ext1='oc';
                    f_mon='10';
                end
                if f_mon=='B' 
                    f_ext1='no';
                    f_mon='11';
                end
                if f_mon=='C' 
                    f_ext1='de';
                    f_mon='12';
                end
            f_mon1(a)=str2num(f_mon);           % to convert string to number
            f_date=y(5:6);                      % file name for date
            f_hour=y(7:8);                      % file name for hour
            f_min=y(10:11);                     % file name for min
            f_date1(a)=str2num(f_date);
            f_hour1(a)=str2num(f_hour);
            f_min1(a)=str2num(f_min);
                if a>1                          % to check from the second file
                    if f_mon1(a)==f_mon1(a-1);  % checking month of the present file equal to the month of thr previous file
                        if f_date1(a)==f_date1(a-1) | f_date1(a)==f_date1(a-1)+1 & f_hour1(a)<=5 % to compare the date of present and previous file
                            if f_date1(a)==f_date1(a-1)&f_hour1(a)>f_hour1(a-1)& abs(f_hour1(a)-f_hour1(a-1))>2%to check if the calculation is for the same day
                                c=1;
                            end
                            if f_date1(a)==f_date1(a-1)&f_hour1(a)==f_hour1(a-1)& abs(f_min1(a)-f_min1(a-1))>5
                                c=1;
                            end
                            if f_date1(a)==f_date1(a-1)&f_hour1(a)>f_hour1(a-1)& abs(f_min1(a)-f_min1(a-1))<55
                                c=1;
                            end
                            if c==1
                                f_ext3=f_ext1;
                                f_date3=y(5:6); %file name for date
                                f_hour3=y(7:8); %file name for hour
                                f_min3=y(10:11); %file name for min
                            end
                            fnam1=strcat(f_date3, f_hour3,f_min3);
                            ext1='.';
                            ext5='D';% perpendicular channel
                            ext3='\';
                            ext2='M';% parallel channel
                            data1=[d1];
                            fid1 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext2),'w');  
                            fprintf(fid1,'%.3f\n',data1);
                            fclose(fid1); 
                            data2=[d2];
                            fid2 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext5),'w');  
                            fprintf(fid2,'%.3f\n',data2);
                            fclose(fid2); 
                            fclose(f1);
                            c=c+1;
                        end %%%% This end is for f_date1(a)==f_date1(a-1) | f_date1(a)==f_date1(a-1)+1 & f_hour1(a)<=5
                    end % % This end is for f_mon1(a)==f_mon1(a-1);
                if f_mon1(a)==f_mon1(a-1)& f_date1(a)~=f_date1(a-1)& abs(f_hour1(a)-f_hour1(a-1))<23
                    c=1;
                    f_ext3=f_ext1;
                    f_date3=y(5:6); %file name for date
                    f_hour3=y(7:8); %file name for hour
                    f_min3=y(10:11); %file name for min
                    fnam1=strcat(f_date3, f_hour3,f_min3);
                    ext1='.';
                    ext5='D';% perpendicular channel
                    ext3='\';
                    ext2='M';%parallel channel
                    data1=[d1];
                    fid1 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext2),'w');  
                    fprintf(fid1,'%.3f\n',data1);
                    fclose(fid1); 
                    data2=[d2];
                    fid2 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext5),'w');  
                    fprintf(fid2,'%.3f\n',data2);
                    fclose(fid2);  
%                     fclose(f1);
                    c=c+1;
                end % % f_mon1(a)==f_mon1(a-1)& f_date1(a)~=f_date1(a-1)& abs(f_hour1(a)-f_hour1(a-1))<23
                if f_mon1(a)~=f_mon1(a-1)& abs(f_hour1(a)-f_hour1(a-1))==23;
                    fnam1=strcat(f_date3, f_hour3,f_min3);
                    ext1='.';
                    ext5='D';% perpendicular channel
                    ext3='\';
                    ext2='M';%parallel channel
                    data1=[d1];
                    fid1 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext2),'w');  
                    fprintf(fid1,'%.3f\n',data1);
                    fclose(fid1); 
                    data2=[d2];
                    fid2 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext5),'w');  
                    fprintf(fid2,'%.3f\n',data2);
                    fclose(fid2); 
                    c=c+1;
                end
            if f_mon1(a)~=f_mon1(a-1)& abs(f_hour1(a)-f_hour1(a-1))<23;
                c=1;
                    if c==1
                        f_ext3=f_ext1;
                        f_date3=y(5:6); %file name for date
                        f_hour3=y(7:8); %file name for hour
                        f_min3=y(10:11); %file name for min
                    end
                fnam1=strcat(f_date3, f_hour3,f_min3);
                ext1='.';
                ext5='D';% perpendicular channel
                ext3='\';
                ext2='M';%parallel channel
                data1=[d1];
                fid1 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext2),'w');  
                fprintf(fid1,'%.3f\n',data1);
                fclose(fid1); 
                data2=[d2];
                fid2 = fopen(sprintf('%s%s%s%d%s',f_ext3,fnam1,ext1,c,ext5),'w');  
                fprintf(fid2,'%.3f\n',data2);
                fclose(fid2); 
                c=c+1;
            end %%%% f_mon1(a)~=f_mon1(a-1)& abs(f_hour1(a)-f_hour1(a-1))<23;
        end%%%% this end is for a
       a=a+1;
end %% this end is for while
fclose(file);
 clear all
close all
clc
delete('*.txt')
delete('*.dat')
recycle on;
end %%%% this end is for ddd
% delete('*.dat')
 fprintf('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
 fprintf('      YOUR PROGRAM HAS RUN SUCCESFULLY\n')
 fprintf('        THANKS FOR USING THE PROGRAM\n')
 fprintf('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')