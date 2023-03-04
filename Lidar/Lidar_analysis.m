clear all
clc
HRES=0.003750; % 3.75 m
z1_km=1;
z2_km=6;
b1=round(z1_km/HRES);
b2=round(z2_km/HRES);
Nb=b2-b1+1;
Ht=(1:Nb)*HRES;
Sa=45;
R1=1.05;
wavl=532;

%% load data
yr=input('year?:');
path0='E:\lidar_data\'
%yr=2019
yr=num2str(yr);
path1=strcat(path0,yr);
date=input('file name as 1225:' )

dax=num2str(date)
%dax=strcat(da,'ASC')
path2=strcat(path1,'\',dax,'\')
fP=strcat(path2,'a*')

dr=dir(fP);
L=length(dr);
for i=1:L
   %data=licel_rd(['E:\lidar_data\2019\1210\' dr(i).name])
   data=licel_rd([path2 dr(i).name]);
    for j=1:length(data)
        p{j}(:,i)=data{j};
      %  q{j}(1:2000,i)=data{j}(1:2000);
    end
end

%%plot data 
for n=1:L
P(:,n)=p{2}(:,n);  %photon counting
P(:,n)=smooth(P(:,n),20);
A(:,n)=p{1}(:,n);  %analog
A(:,n)=smooth(A(:,n),20);
end
figure (1);
hold
subplot(2,1,1)
title('Photon counting');
for n1=1:L;
plot(P(b1:b2,n1),Ht);

end;% n1
subplot(2,1,2)
hold
title('Analog');
for n2=1:L;
    plot(A(b1:b2,n2),Ht);
end
%% remove background
%sgn=mean(p{2}(:,:),2);
%sgn0=mean(p{2}(:,1:5:120),2)
P_sgn0=mean(smooth(p{2}(:,1:L),20),2);  %photon counting
A_sgn0=mean(smooth(p{1}(:,1:L),20),2);  %analog

bgP=min(P_sgn0(4000:5000));
bgA=min(A_sgn0(4000:5000));
sgnP=P_sgn0-bgP+1; %remove background
sgnA=A_sgn0-bgA;

%% use photon counting or analog
ANS=input('photon counting input 1 analog input 0: ANS= ');
if ANS ==1  ;
[R, Ba, H]=ra_ratio(sgnP,HRES,z1_km,z2_km,Sa,R1,wavl);
elseif ANS==0  ;
[R, Ba, H]=ra_ratio(sgnA,HRES,z1_km,z2_km,Sa,R1,wavl);
end
figure (2)
hold on
plot(R,H,'b','LineWidth',2)
xlabel('Backscattering Ratio','Fontsize',20,'FontWeight','b','LineWidth',2)
%xlabel('Backscatter')
%xlabel('Extinction')
ylabel('Height (km)','Fontsize',20,'FontWeight','b','LineWidth',2)
%set(gca, 'xtick', [0:1:50])

%set(legend,'Fontsize',20,'FontWeight','b','LineWidth',2);
set(gca,'Fontsize',20,'FontWeight','b','LineWidth',2);

