PRO READ_CALIPSO2; read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
;fpath='d:\rsi\cirrus\';   ;35data.txt'
;data1='ASM_10_20km.txt'
fname='d:\rsi\test\cirrus 08_12Ht.txt'
;read,data1,prompt=' where is data? AS d:\rsi\test\Lidar_T2001ja16.txt'
;fname=fpath+data1
OPENR,1,fname
line=''
cols=7
rows=1000
readf,1,line
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=1000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line

ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter
Mnth=''
WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H

    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
mnths=strcompress(H[0,*])
mn=strmid(mnths,5,2)
stop
sumwinter=fltarr(7,4)
sumspring=fltarr(7,4)
sumsummer=fltarr(7,4)
sumfall=fltarr(7,4)
sum1=0
sum2=0
sum3=0
sum4=0
iy=0
js1=0
js2=0
js3=0
js4=0
for i=0,38,3 do begin
;;sum over winter months
if (mn[i] eq 12) or (mn[i] eq 1) or (mn[i] eq 2) then begin
  for m=1,6 do begin
  sum1=sum1+H[m,i]+H[m,i+1]+H[m,i+2]
  print,'js ',js1,' sum1:=  ',sum1
  sumwinter[m,js1]=sum1 ;
  sum1=0
  while (js1 LE 2) do js1=js1+1
  endfor


endif
;js=0
sum1=0
if (mn[i] eq 3) or (mn[i] eq 4) or (mn[i] eq 5) then begin
  for m=1,6 do begin
  sum2=sum2+H[m,i]+H[m,i+1]+H[m,i+2]
  sumspring[m,js2]=sum2
   print,'iy ',iy,' sum2:=  ',sum2
   sum2=0
  endfor
   while (js2 LE 2) do js2=js2+1
endif
sum2=0
 if (mn[i] eq 6) or (mn[i] eq 7) or (mn[i] eq 8) then begin
  for m=1,6 do begin
  sum3=sum3+H[m,i]+H[m,i+1]+H[m,i+2]
   print,'iy ',iy,' sum3:=  ',sum3
  sumsummer[m,js3]=sum3; H[i,m]+sumspring;H[i+1,m]+H[i+2,m]
   sum3=0
  endfor
   while (js3 LE 2) do js3=js3+1
endif; else begin
js=0
sum3=0
if (mn[i] eq 9) or (mn[i] eq 10) or (mn[i] eq 11) then begin
  for m=1,6 do begin
  sum4=sum4+H[m,i]+H[m,i+1]+H[m,i+2]
  sumfall[m,js4]=sum4;H[i,m]+H[i+1,m]+H[i+2,m]
   print,'iy ',iy, ' sum4:=  ',sum4
   sum4=0
  endfor
   while (js4 LE 1) do js4=js4+1
  sum4=0
endif
;js=0
  sum4=0
  while (iy LE 2) do  iy=iy+1
 ; endwhile
endfor
;js=js+1
stop
SS1=fltarr(4,6)
ss1[0,*]=sumwinter[1:6]
ss1[1,*]=sumspring[1:6]
SS1[2,*]=sumsummer[1:6]
SS1[3,*]=sumfall[1:6]
;Ht=H[9,*]
;Tempr=meanH[1,*]
;plot,Tempr,Ht,background=-2,color=1
;openw,2,'d:\rsi\temp\Tav_ja16.txt'
;printf,2,meanH
;close,2
stop
END