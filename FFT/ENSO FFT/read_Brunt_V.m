%A=load('20090225_12.txt')
%999 data 外插法，即在後面之參數加上'extrap'，並且要表示所使用之方法，例如'linear
%USING previous data to extrapolate

%  XI=interp1(a,b,80,'linear','extrap')
clc
%T0(T999(j))=interp1(htj,tj,H(T999(j)),'linear','extrap')
path1='E:\radiosonde\'
data1='H20020318_00.txt'
data2='H20020318_12.txt'
file1=strcat(path1,data1);
file2=strcat(path1,data2);
fidA=fopen(file1);
fidB=fopen(file2);
for IA=1:5
    LA=fgetl(fidA);
    LB=fgetl(fidB);
end
A=fscanf(fidA,'%9g',[9 inf]);
 
B=fscanf(fidB,'%9g',[9 inf]);
M=size(A);
L1=M(1);
L2=M(2);
 for i1=5:7;
    for j1=1:L2;
     % qA=find(A(i1,j1) > 900);
      while (A(i1,j1) > 900)  ;
         
        A(i1,j1)=A(i1,j1-1);
      end
      
    end
    
 end
 
for i2=5:7;
    for j2=1:L2;
     % qB=find(B(i2,j2) > 900);
      while (B(i2,j2) > 900)  ;
        
          B(i2,j2)=B(i2,j2-1); 
      end
    end
      
end


HA=A(4,:);
PA=A(3,:);
T0A=A(5,:);
RHA=A(6,:);
WDA=A(8,:);
WSA=A(9,:);
HB=B(4,:);
PB=B(3,:);
T0B=B(5,:); 
RHB=B(6,:);
WDB=B(8,:);
WSB=B(9,:);
 
PPA=1.293*(T0A+273)*287;% Pp=dRT
PPB=1.293*(T0B+273)*287;% Pp=dRT

figure (1)
subplot(2,1,1)
plot(T0A,HA,'rx-')
hold
plot(T0B,HB)
xlabel('temperature')
ylabel('height-m')
legend('red:daytime; blue nighttime')
title(data1)
subplot(2,1,2)
plot(RHA,HA,'-rx')
hold
plot(RHB,HB)
xlabel('Relative humidity %')
ylabel('height m')
legend(data2);
figure (2)
subplot(2,1,1)
plot(WDA,HA,'rx')
legend('blue:night time; red: daytime')
hold
plot(WDB,HB)
ylabel('height')
xlabel('wind direction')
title(data1)
subplot(2,1,2)
plot(WSA,HA,'rx')
hold
plot(WSB,HB)
xlabel('wind speed')
ylabel('height')
Cp=1001  %KJ/kg-K
g=9.8   % m/s2
PotenTm=(T0B+273.15).*(PB(1)./PB).^0.286;
 
figure (3)
plot(PotenTm,HB)

%NB2=g*gradient(PotenTm); %+(g/Cp)*(g./(T0B+273));
NB2=g*(diff(PotenTm))./diff(HB);
figure (4)
ht=HB(1:34);
plot(NB2,ht)

