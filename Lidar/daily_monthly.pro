pro Daily_Monthly

;read,series daily data and convert to monthly average;
;convert daily series data into columnwise monthly format

Path1='F:\cirrusHP\'
DATAX=PATH1+'PrecipitationRate.txt';radiosonde\cwb1985_2006\';cwb2009.txt'
 ; SUM=FLTARR(12,4)
  MDAY=[31,28,31,30,31,30., 31,31,30,31,30,31]

  A=READ_ASCII(DATAX)
  B=A.(0)
  P=B[1,*]
  JDAY=0
   J=0
   JD=0
   PRmonth=FLTARR(12,31)
   ;Pmon=fltarr(12)
   ;PR[*,0]=0
   stop
 SUM=FLTARR(12,4)
FOR IY=0,3 DO BEGIN
CLOSE,/ALL
J=JD
FOR M=0,11 DO BEGIN ; M is the month count
 ;
FOR I=0,MDAY[m]-1 DO BEGIN ;I is the day count
   ;I2=I+1

  PRmonth[M,I]=P[I+J+1];

endfor
J=J+I
PRINT,I,J,M,  PRMONTH[M,I-1]
endfor
;OPENU,2,PATH1+'YR1.TXT';APPEND FILE
;PRINTF,2,PRMONTH
;CLOSE,2
SUM[*,IY]=TOTAL(PRMONTH,2)
JD=J
OPENW,2,PATH1+'test.TXT'
PRINTF,2,SUM
CLOSE,2
ENDFOR ;IY
stop
CLOSE,/ALL
SUMPRCP=TOTAL(SUM,2)
YUE=INDGEN(12)+1
PLOT,YUE,SUMPRCP,PSYM=2,COLOR=2,BACKGROUND=-2
STOP
;PRECIP

end

