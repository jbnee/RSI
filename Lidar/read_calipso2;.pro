PRO READ_CALIPSO2; read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
;fpath='d:\rsi\cirrus\';   ;35data.txt'
;data1='ASM_10_20km.txt'
fname='d:\rsi\test\cirrus2008_12Ht.txt'
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

    print,'js, i, m ',js1,i,m,' sum1:=  ',sum1
    sumwinter[m,js1]=sum1 ;
    sum1=0

  endfor
  js1=js1+1

endif

;js=0
sum1=0
if (mn[i] eq 3) or (mn[i] eq 4) or (mn[i] eq 5) then begin
  for m=1,6 do begin
  sum2=sum2+H[m,i]+H[m,i+1]+H[m,i+2]
  sumspring[m,js2]=sum2
   print,'iy, i, m  ',iy,i,m,' sum2:=  ',sum2
   sum2=0
  endfor
    js2=js2+1
endif
sum2=0
 if (mn[i] eq 6) or (mn[i] eq 7) or (mn[i] eq 8) then begin
  for m=1,6 do begin
  sum3=sum3+H[m,i]+H[m,i+1]+H[m,i+2]
   print,'iy,i,m ',iy,i,m, ' sum3:=  ',sum3
  sumsummer[m,js3]=sum3; H[i,m]+sumspring;H[i+1,m]+H[i+2,m]
   sum3=0
  endfor
   js3=js3+1
endif; else begin
js=0
sum3=0
if (mn[i] eq 9) or (mn[i] eq 10) or (mn[i] eq 11) then begin
  for m=1,6 do begin
  sum4=sum4+H[m,i]+H[m,i+1]+H[m,i+2]
  sumfall[m,js4]=sum4;H[i,m]+H[i+1,m]+H[i+2,m]
   print,'iy,i m  ',iy,i,m, ' sum4:=  ',sum4
   sum4=0
  endfor
    js4=js4+1
  sum4=0
endif
;js=0
  sum4=0
  while (iy LE 2) do  iy=iy+1
 ; endwhile
endfor
;js=js+1
stop

SS1=fltarr(6)
SS2=fltarr(6)
SS3=fltarr(6)
SS4=fltarr(6)


for jj=0,5 do begin
SS1[JJ]=total(sumwinter[JJ+1,*])/4
SS2[JJ]=total(sumspring[JJ+1,*])/3
SS3[JJ]=total(sumsummer[JJ+1,*])/3
SS4[JJ]=total(sumfall[JJ+1,*])/3
endfor

stop
END