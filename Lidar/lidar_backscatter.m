clear all
clc

HRES=0.0075; % 7.5 m
z1_km=1;
z2_km=6;
Sa=60;
R1=1.05;
wavl=532;

%% load data
path='E:\lidar_data/2019/1212/a*';
dr=dir(path);
L=length(dr);
for i=1:L

    data=licel_rd(['E:\lidar_data\2019\1212\' dr(i).name]);
    for j=1:length(data)
        p{j}(:,i)=data{j};
      %  q{j}(1:2000,i)=data{j}(1:2000);
    end
end
%% remove background
%sgn=mean(p{2}(:,:),2);
%sgn0=mean(p{2}(:,1:5:120),2)
P_sgn0=mean(p{2}(:,1:L),2);  %photon counting
A_sgn0=mean(p{1}(:,1:L),2);  %analog

%sgn=mean(p{2}(:,2:5:120),2);
%sgn=mean(p{2}(:,3:5:120),2);
%sgn=mean(p{2}(:,4:5:120),2);
%sgn=mean(p{2}(:,5:5:120),2);
bgP=mean(P_sgn0(4000:5000));
bgA=mean(A_sgn0(4000:5000));
sgnP=P_sgn0-bgP;
sgnA=A_sgn0-bgA;

%%
%[R, Ba, H]=ra_ratio(sgnP,HRES,z1_km,z2_km,Sa,R1,wavl);
[R, Ba, H]=ra_ratio(sgnA,HRES,z1_km,z2_km,Sa,R1,wavl);
figure (2)
hold on
plot(R,H,'r','LineWidth',2)
xlabel('Backscattering Ratio','Fontsize',20,'FontWeight','b','LineWidth',2)
%xlabel('Backscatter')
%xlabel('Extinction')
ylabel('Height (km)','Fontsize',20,'FontWeight','b','LineWidth',2)
%set(gca, 'xtick', [0:1:50])
%legend('no filter','135 degree','45 degree','0 degree','90 degree',1)
set(legend,'Fontsize',20,'FontWeight','b','LineWidth',2);
set(gca,'Fontsize',20,'FontWeight','b','LineWidth',2);
%legend('no filter','0+90 degree',1)
