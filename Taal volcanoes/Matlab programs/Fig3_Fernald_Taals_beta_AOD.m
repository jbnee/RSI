clc
clf
clear all
reset(gca);
fclose('all')
%dd=datenum([2019 12 25]);
%%%Part I data input (ASC Analog only) and plots,
%%part II is the Inversion based on Fernald 1984
%$Part II is derivation of beta,  depolarization ratio, and extinction,
%ht in meter; Ht in km; z
%average 5 data with set by avex=5;
%% data input
yr=input('year?:2020:  ');2020

path='E:\lidar_data\'
%yr=2019
yr=num2str(yr);2020


filename=input('filename:','s');
fnm=strcat(path,yr,'\ASC\',filename);
DAY=filename(1:5);
drx=dir(fnm);
L=length(drx)
Total_files=L
bnum=4000;
F1=input(' starting file number as 401: ');
F2=input('end file number as 760: ');
filelist=dir(strcat(fnm,'\a*'));
%files=strvcat(filelist.name);
%filesize=size(filelist)
%L=length(filelist)
i0=1;
Lx=F2-F1+1
%for i=1:L;
for i=1:F2-F1+1;
fi=strcat(fnm,'\',filelist(i).name); %fi is the name of files
fid=fopen(fi,'r');
for m=1:6;   %first 6 lines are header 
line=fgetl(fid) ; %header 
end

XA=importdata(fi);
TS=XA.textdata{1}(7:11);
Time=str2num(TS);
T(i0)=datenum(Time);
A(:,i0)=XA.data(:,1); %analog signal parallel + perpendicular 
P(:,i0)=XA.data(:,2); %photon counting; parallel+ perpendicular
i0=i0+1;
end
SA=size(A);
SA1=length(A);
fclose(fid);
 
hold
n=1 
for k=1:2:Lx-1;
C1(:,n)=A(:,k);  % Parallel
C2(:,n)=A(:,k+1); %Perpend 
n=n+1;
end
c=3.0e8 ;%speed of light
dt=25;  %bin width 50 nsec
ns=1.e-9  %ns
%dz=c*dt*ns/2  %height resolution 3.75 m
dz=3.75
dz1000=dz/1000; %dz in km
  %4000=15 km
Ht=(1:bnum)*dz1000; 

figure (1)
subplot(2,1,1)
N0x=1:Lx/2;

[xx1,yy1]=meshgrid(N0x,Ht(1:bnum/2));
pcolor(xx1,yy1,C1(1:bnum/2,:));
shading interp;
colorbar
caxis([0 20])
title('C1for Parallel')

subplot(2,1,2)
pcolor(xx1,yy1,C2(1:bnum/2,:));
shading interp;
colorbar
caxis([0 20])
title('C1for Perpend')
Total_file=Lx
%F1=input('first file: as20?')
%F2=input('last file:as 300?')



%% divide parallel and perpendicular
J=1;       %   count file
   % for k=1:2:L-1 ;
   %for k=1:2:F2-F1;
    for k=1:2:F2-F1
     A1(:,J)=A(:,k);  % Parallel
     A2(:,J)=A(:,k+1); %Perpend 

     P1(:,J)=P(:,k);    %Perp
     P2(:,J)=P(:,k+1);   %Parallel
     J=J+1;
    end ; 


     %height in km
LA=(F2-F1+1);

 S2=size(A2)
 
title('analog @every 5 plot ');
axis([0 100 0 5])

figure (2)
subplot(2,1,1)
%NT=1:L/2;
NT=1:(F2-F1+1)/2;
y=Ht(1:bnum/2);
[xx,yy]=meshgrid(NT,y);

pcolor(xx,yy,P2(1:bnum/2,:));

shading interp;
colorbar
caxis([0 70])
title('P2:Parallel')
%title('P2 channel');
subplot(2,1,2)
 pcolor(xx,yy,P1(1:bnum/2,:));
 %datenum(datex);
 %time_x=1:N;
 %datetick(time_x);
 colorbar
 shading interp;
title(strcat(DAY,'P1 channel'));
caxis([0 70]);
%axis([0 L/2 0 4])
%%%%%%%%%%%%%%%%%%%%%%%Fernald Inversion%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%avex=5  %average 5 profiles 
%avex=input('for average files number to sum as one file.=(all)');
%if isempty(avex)
 %  avex=num;
%end
h1=0.  %km
%z1=input('Starting lower height in km  :');
h2=input('top level km   0806  3 .: ');
b1=ceil(h1*1000/dz)+1;  %starting bin number for z1
b2=floor(h2*1000/dz)+1;
Nb=b2-b1+1;

%W =50;% window size for filter was 42, now40

%N=density(H);
%num=L/2; % number of files
 %number of files
%avex=5 % number files to average
%Ng=floor(num/avex);  %number of average groups
Sa=50  %lidar ratio for cirrus
Sr=8*pi/3;  %lidar ratio for Rayleigh
 
%
%%%%%%%%%%%%%%%Rayleigh backscattering %%%%%%%%%
%N is the density of air from fitting 2010-15 data
%Ht in km to calculate density of air
 
N=1.E25*(2.4498-0.22114*Ht+0.00701*Ht.^2-7.75225E-5*Ht.^3);

Br=5.45e-32*(550/532)^4*N; %(1/m-sr) backscatt coeff of air
L0=length(Br);

tau(L0)=0;
%below is integration of beta to get optical thickness for Lidar
%transmission, tau is the optical thickness 
%kext=Br*Sr  %total extinction
for j0=L0-1:-1:1;
   tau(j0)=tau(j0+1)+dz*Sr*(Br(j0+1)+Br(j0))/2;
end

%lidar transmission: Tair=1 at ground and ~90% at 10 km
Tma=exp(-2*tau); %atmospheric transmission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hb=8.0;% 6.0input('background base height km: ');
bz=ceil(hb*1000/dz);
%k=1
%blk=blackman(12); %Blackman filter
%blk=blk/sum(blk);
 for n0=1:floor(LA/2)
 
    %for f=1:5:(F2-F1)/2;
     % tmp_a=A1(1:bnum,n0) ;   %sum 5=Avex
     % tmp_b=A2(1:bnum,n0)  ; 
  %f

sgn_a=A1(1:bnum,n0)';   %tmp_a';
sgn_b=A2(1:bnum,n0)';   %tmp_b';
%bz=input('background base height: ')

bg_a=min(sgn_a(bnum-500:bnum-1));
sgn_1=sgn_a-bg_a;
%sgn_1=sgn_1-min(sgn_1);

bg_b=mean(sgn_b(bnum-500-500:bnum-1));
sgn_2=sgn_b-bg_b;
%sgn_2=sgn_2-min(sgn_2);
%PPD(n0,:)=sgn_2;  %S_d;perpend
sgn(n0,:)=sgn_1+sgn_2;
sgn(n0,:)=smooth(sgn(n0,:),30); 
sgn(n0,:)=sgn(n0,:)-min(sgn(n0,:));
%sgn(n0,:)filtfilt(blk,1,sgn(n0,:));
%q1=find(sgn_1 > 0);  % remove negative by finding positive data
%sgn_ax=sgn_1(q1);   % keep positive only
%z1=Ht(q1); % height of positive data
%sgn_1(n0,:)=interp1(z1,sgn_ax,Ht,'linear'); % interpolation to fill removed data 


%q2=find(sgn_2 > 0);
%sgn_bx=sgn_2(q2);
%z2=Ht(q2);
%sgn_2(n0,:)=interp1(z2,sgn_bx,Ht,'linear');  % interpolation to fill perpendicular
 end

%Tmx=Tma(b1:b2);    %transmission of b1 to b2
%%%%%%%%%%%%%%%%%  Fernald core program %%%%%%%%%%%%%%%%%%%%%%%%%%
h0=Ht(b1:b2)*1000;  % height in meters

% PLL(n0,:)=PLL(n0,:)-mean(PLL(n0,bnum-100:bnum)); %remove more background 
% PPD(n0,:)=PPD(n0,:)-mean(PPD(n0,bnum-100:bnum)); %remove more background

%sgn=sgn_1+sgn_2;

z=(b1:b2)*dz;
btop=4000;  %1200 starting 4.5 km
for n0=1:LA/2
Pr2(n0,:)=(sgn(n0,:)).*(Ht.^2);
B(b2)=0;                  %initial condition of the top ht
BTM1(n0)=(mean(Pr2(n0,b2-20:b2)))/(Br(b2)+B(b2));    %X1 the 1st term in the denominator
 %BTM2(n0,bnum)=0 ; %2*Sa*A(n0,bnum);   %X2 is the second term in the denominator
beta(n0,bnum)=0;

  for ja=btop:-1:2;
      A(ja)=(Sa-Sr)*(Br(ja)+Br(ja-1))*dz;
      V1(n0,ja)=Pr2(n0,ja).*exp(A(ja));
     %  X2(n0,ja)=X2(n0,ja+1)+(Sa*dz)*(A(n0,ja)+A(n0,ja+1));;    %  +A(j-1));% change to - after X2(n0+1)
       BTM2(n0,ja)=Sa*dz*(Pr2(n0,ja)+Pr2(n0,ja-1).*exp(A(ja)));
   
     %  B(n0,:)=V1(n0,ja)./XX2(n0,:);     %total beta in Fernald formula B=beta_r+beta_a
    beta(n0,ja)=V1(n0,ja)/(BTM1(n0)+BTM2(n0,ja));
    err_beta(n0,ja)=std(beta(n0,ja));
  end;% ja
%Ratio(n0,:)=X(n0,:)./Br(1:bnum);   %Backscatter Ratio R=1+ beta_a/beta_r
end
% top level correction
BTM2(:,btop)=BTM2(:,btop-1);
V1(:,btop)=V1(:,btop-1);
beta(:,btop)=beta(:,btop-1);
bkratio=beta(1:btop)./Br(1:btop);
%maxd=mean(max(depratio));
% plot(r(1,:),H,r(2,:),H,r(3,:),H,r(4,:),H)
figure (3)
hold
for i3=1:2:LA/2;
plot(beta(i3,50:b2),Ht(50:b2))
%plot(err_beta(i3,:)+i3*0.00001,Ht(b1:b2)),err);
end
title('beta')
%axis([0 0.005 0  h2])

figure (4)
 % time interval of profiles
tmin=(1:LA/2);
betaX=beta(:,1:b2); %reduce height
[xx, yy]=meshgrid(tmin,Ht(b1:b2));  
 pcolor(xx,yy,betaX');
   shading interp;
  caxis([0,0.001]);
   colorbar;
   title('Backscatter coeffcient 1/m') 

xlabel('Minutes')
ylabel('Height(km)')
%%%%%%%%%%AOD%%%%%%%%%Fig 5  sum 5 beta %%%%%%%%%%%%%%%%%%%
SB=size(beta);
j5=1;
for i5=1:5:(LA/2)-5
    B5(j5,1:b2)=mean(beta(i5:i5+4,1:b2),1);
    std_5(j5,1:b2)=std(beta(i5:i5+4,1:b2),1);
    
    j5=j5+1;
end
 
figure (5)
hold
 
 opt1=sum(B5(:,b2/2:b2),2)*8*(3.1416/3)*3.75; % AOD 4-8 km  
 opt2=sum(B5(:,1:b2),2)*8*3.1416*3.75/3;  %AOD 1-8 km
 plot(opt2,'o-')
 hold
 plot(opt1,'x')
 ylabel('AOD')
 xlabel('time')
Err_1=std(opt1,1);
Err_2=std(opt2,1);
title('AOD');
AOD=mean(opt1)
%errorbar(B1,ht,errB1);
%plot(B(10,:),ht,'k');
%%%%%%%%%%%%%%backscattering ratio%%%%%%%%%%%%%%%%
BKr=1+beta./Br;
Bk=BKr(:,b1:b2);

figure (6);
pcolor(xx,yy,Bk');
shading interp;
colorbar;
title('BK ratio')
AOD=mean(opt1)
Err_AOD=std(opt1)
