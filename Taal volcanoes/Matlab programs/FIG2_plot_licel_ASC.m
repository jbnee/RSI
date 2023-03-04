%this program plot ASC data starting file F1 - F2
clc
clf
clear all
reset(gca);
fclose('all')
%dd=datenum([2019 12 25]);

yr=input('year?:');
path='e:\lidar_data\'
%yr=2019
yr=num2str(yr);
filename=input('filename as 0806 PM ASC: ','s');
fPath=strcat(path,yr,'\ASC\',filename);
DAY=filename(1:5);

f1=strcat(fPath,'\a*');
%dr=dir('F:\lidar_data\2016\20160728_4\parallel_5\e*');
flist=dir(f1);
Sz=size(flist)
L=Sz(1)
files=strvcat(flist.name);
%a1=flist(1).name
datasize=L
F1=input('starting file number as 1: ');
F2=input('end file number as 500: ');

i0=1;
%for i=1:L;
for i=F1:F2;
fi=strcat(fPath,'\',flist(i).name); %fi is the name of files
fid=fopen(fi,'r');
for m=1:6;   %first 6 lines are header 
line=fgetl(fid) ; %header 
end

XA0=importdata(fi);  

A(:,i0)=XA0.data(:,1); %analog signal parallel + perpendicular 
P(:,i0)=XA0.data(:,2); %photon counting; parallel+ perpendicular
i0=i0+1;
end
SA=size(A);
LA=length(A);
%% divide parallel and perpendicular
J=1;       %   count file
   % for k=1:2:L-1 ;
   for k=1:2:F2-F1;
     A1(:,J)=A(:,k);  % Parallel
     A2(:,J)=A(:,k+1); %Perpend 

     P1(:,J)=P(:,k);    %Perp
     P2(:,J)=P(:,k+1);   %Parallel
     J=J+1;
    end ; 

bnum=6000; %bin number
NF=F2-F1
NF2=round(NF/2)
A1=zeros(bnum,NF2);
A2=zeros(bnum,NF2);
P1=zeros(bnum,NF2);
P2=zeros(bnum,NF2);
%% divide parallel and perpendicular

J=1;       %   count file
    for k=1:2:NF ;
     A1(1:bnum,J)=A(1:bnum,k);  % Parallel
     A2(1:bnum,J)=A(1:bnum,k+1); %Perpend 

     P1(1:bnum,J)=P(1:bnum,k);    %Parallel
     P2(1:bnum,J)=P(1:bnum,k+1);   %perpend
     J=J+1;
    end ; 

c=3.0e8 ;%speed of light
dt=25;  %bin width 50 nsec
ns=1.e-9  %ns
dz=c*dt*ns/2  %height resolution is 7.5 m
 %take 15 km 
ht=(1:bnum)*dz;  % height range
figure(1)
hold
A12=A1+A2;
TA12=sum(A12,2)/NF;

bkA=mean(TA12(4000:5000));
maxA=max(TA12(1000:3000)-bkA);
plot(TA12-bkA,ht)
axis([0 maxA 3000 8000]); 
title('Total analog')
figure (2)
hold
for j2=1:NF2 ;
plot(P1(:,j2)+P2(:,j2)+j2*10,ht);
end
title('photon counting');
figure (3)
axis([1 100 3 8]);   
subplot(2,1,1)
NT=1:NF2;
%PR1=P1.*(ht'.^2);
km=ht/1000;  %in km
[xx,yy]=meshgrid(NT,km);
pcolor(xx,yy,P1);
colorbar
caxis([0 100]);
axis([0 100 3 8]);
shading interp;
title('Perpendicular')
%xlabel('Time interval (min)')
 ylabel('Height (km)');
subplot(2,1,2)
    
 pcolor(xx,yy,P2);
 colorbar
 caxis([0 100]);
 axis([1 100 3 8])
 shading interp;
 title('Parallel')
 xlabel('Time interval (min)')
 ylabel('Height (km)');
figure (4)
subplot(2,1,1)
NT=1:NF2;
%AR1=A1.*(ht'.^2);
km=ht/1000;  %in km
[xx,yy]=meshgrid(NT,km);
pcolor(xx,yy,A1);
colorbar
shading interp;
title('A_Perpendicular');
subplot(2,1,2)
%AR2=A2.*(ht'.^2);
 pcolor(xx,yy,A2);
 colorbar
 shading interp;
 axis([1 100 3 8])
title('A_parallel');
caxis([0 100]);
