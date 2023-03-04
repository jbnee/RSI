
PRO Richardson;
close,/all
;read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
;fpath='d:\rsi\cirrus\';   ;35data.txt'
;data1='ASM_10_20km.txt'
fname='F:\rsi\test\Radioson2000_120612.txt'
;read,data1,prompt=' where is data? AS d:\rsi\test\Lidar_T2001ja16.txt'
;fname=fpath+data1
OPENR,1,fname
;line=''
cols=9
rows=1000

IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=1000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line
A=FLTARR(cols,rows)
ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter

WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H

    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
;mnths=strcompress(H[0,*])
;mn=strmid(mnths,5,2)
stop
A=size(H)
A1=A[1]  ;column #
A2=A[2]   ;row #
 For j=0,A1-1  do begin
   For i=0,A2-1 do begin
   ; A[j,i]=H[j,i]
     if (H[j,i] eq 999.9) then H[j,i]=H[j,i-1]
     if (H[j,i] EQ 999) then H[j,i]=H[j,i-1]
   endfor   ;i
   endfor   ;j
Ht=H[3,*]
P=H[2,*]
T=H[4,*]
RH=H[5,*]
WD=H[7,*]

WS=H[8,*]
plot,T,Ht,background=-2,color=1
;openw,2,'d:\rsi\temp\Tav_ja16.txt'
;printf,2,meanH
close,1


stop


PT=(T+273.15)*(1000./P)^0.286
N=100
WSH=interpo1(Ws,N);(:,1),Ws(:,2),R(:,1));
WDH=interp1(Wd,N);(:,1),Wd(:,2),R(:,1))/180*pi;
u=WSH*sin(WDH);
v=WSH*cos(WDH);
DZ=Deriv(T,z);
;R(:,2)=9.8.*DZ/PT(:,2)/((u-u(1))^2+(v-v(1))^2)*(PT(:,2)-PT(1,2));
;R(:,2)=9.8/PT/WSH^2*(PT(*,2)-PT(1,2))*DZ;
stop
end