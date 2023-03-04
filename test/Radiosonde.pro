pro Radiosonde
;PRO READ_RADIODATA;
filename='d:\lidar systems\lidarpro\Rayleigh\1993\radio930901.txt'
Hdata=read_ascii(filename)  ;
A=Hdata.(0)
;stop
x=size(a)
col=x(1)
row=x(2)
Rdata=fltarr(col,row)

  For jcol=0,col-1  do begin
   For irow=0,row-1 do begin
    ;A[jCOL,irow]=Rdata[jcol,irow]
     if (A[jcol,irow] eq 999.9) then A[jcol,irow]=A[jcol,irow-1]
     if (A[jcol,irow] EQ 999) then A[jcol,irow]=A[jcol,irow-1]
   endfor   ;irow
   endfor   ;jcol
   pr=A[2,*]

   km=A[3,*]/1000.0
   T=A[4,*]
   RH=A[5,*]
   Dew=A[6,*]
   WD=A[7,*]
   WS=A[8,*]


;ENDWHILE
plot,pr,km,background=-2,color=2,yrange=[0,30],psym=1,xtitle='pressure',ytitle='km'
;write_bmp,'D:\lidar systems\lidarpro\1993\Radio_press.bmp',tvrd()
stop

;plot,T,km,background=-2,color=2,yrange=[0,30],psym=1,xtitle='Temperature C',ytitle='km'
;write_bmp,'D:\RSI\TEST\Radio_temperature.bmp',tvrd()
;stop

plot,RH,km,background=-2,color=2,yrange=[0,30],psym=1,xtitle='RHumidity',ytitle='km'

write_bmp,'D:\RSI\TEST\Radio_humidity.bmp',tvrd()
plot,ws,km,background=-2,color=2,yrange=[0,30],psym=1,xtitle='ws (m/s)',ytitle='km'
stop
write_bmp,'D:\RSI\TEST\Radio_WS.bmp',tvrd()
plot,wd,km,background=-2,color=2,yrange=[0,30],psym=1,xtitle='wind direction(degree)',ytitle='km'
write_bmp,'D:\RSI\TEST\Radio_WD.bmp',tvrd()

stop
; Close the file:



stop
END