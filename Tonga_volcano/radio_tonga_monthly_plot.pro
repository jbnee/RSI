pro Radio_Tonga_monthly_plot
;note:Gravity wave of temperature anomaly below 10 km
close,/all
erase

;Path0='E:\Aerosol_dust\Taal_volcano\'
 ; path0='E:\Tonga volcano 2022\radioSound\47186Jan10_17\';*'

 ;fx='91765 NSTU Pago Pago JAN15Z.txt'
 ; fx='47918 ROIG IshigakijimaJAN15_12Z.txt';
  path0='47678 HachijyojimaJAN10_20.txt';
  ;fx='47186 National Typhoon Centre JAN10_00z.txt '
 ; fx='98433_May1z12_2021.txt'

  path1=path0+'*';
 Fx=file_search(path1);   path0+fx; input single CWB data file as T2003may.txt
nf=n_elements(Fx)
stop



for ifiles=0,nf-1 do begin
CLOSE,1
F1=FX[ifiles]
Station='47186'
date=strmid(F1,77,9)
OPENR,1,F1;  fname
;stop
line=''
dateline=''
readf,1,dateline

for L=0,3 do begin
readf,1,line
print,line
endfor;L
;STOP
cols=11
rows=100;
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
;stop
A=size(H)
A1=A[1]  ;column #
A2=A[2]   ;row #
ndata=A2-1
 For j=0,A1-1  do begin
   For i=0,ndata do begin
   ; A[j,i]=H[j,i]
     if (H[j,i] EQ 999) then H[j,i]=H[j,i-1]
     if (H[j,i] EQ 999) then H[j,i]=H[j,i-1]
   endfor   ;i
   endfor   ;j
;   take only <10 km
Sz=size(H)
L1=Sz[2]-1
;L1=59;  pick 60 data
Ht=H[1,0:L1]
P=H[0,0:L1]
Temp=H[2,0:L1]
;RH=H[4,0:L1]
WS=H[7,0:L1]*0.514;   knots to m/s
WD=H[8,0:L1]
km=Ht/1000.
h1=1.0;
h2=max(km); 10.0
p1=where(km GT h1)
b1=MIN(p1)
p2=where(km eq h2)
b2=min(p2)
TEMP=TEMP[b1:b2-1]
km=km[b1:b2-1]
!P.MULTI = [0,2,2]
 plot_position1= [0.1,0.1,0.45,0.45];
  plot_position2= [0.6,0.1,0.95,0.45]
  plot_position3=[0.1,0.6,0.45,0.95]
  plot_position4=[0.6,0.6,0.95,0.95]

!p.background=255
plot,WS,km,color=2,background=-2, xtitle='WIND SPEED',ytitle='km',charsize=1.5,title=date;position=plotposition3
plot,WD,km,background=-2,color=2,yrange=[h1,h2],xtitle='WIND DIRECTION',ytitle='km',charsize=1.3,title=date,position=plotposition4

plot,Temp,km,background=-2,color=1,yrange=[h1,h2],xtitle='Temperature',ytitle='km',charsize=1.3,position=plotposition1

plot,P,km,color=2,background=-2,xtitle='Pressure hPa',yrange=[h1,h2],position=position2

;STOP
fout=station+date+'TPDS.bmp';
;read,outfile,prompt='name of the outfile as Taals: '
figout=path0+fout
write_bmp,figout,tvrd()
;printf,2,meanH
close,/all
print,ifiles
wait,2
endfor; i
;read,h1,h2,prompt='height range h1 to h2 in km 1,10 :'



stop
;
end
