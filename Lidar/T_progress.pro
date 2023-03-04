PRO T_Progress, H, filename
device, decomposed=0
;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'d:\rsi\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
;Loadct,13
;!P.BACKGROUND= 1 ; 0 = black, 1 = white
  ; TVLCT,  255, 255, 255, 254 ; White color
  ; TVLCT, 0,0, 0, 255       ; Black color
  ; !P.Color = 30
  ; !P.Background = 240
;filename='d:\rsi\testidl\Lidar_T2001ja16.txt'  ;array ~10x915
 filename='d:\rsi\temp\Lidar_T2001ja16.txt'  ;array ~10x915
OPENR,1,filename
H=FLTARR(10,1000) ;A big array to hold the data
S=FLTARR(10,1)      ;A small array to read a line
T_mean=fltarr(1000)
ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a count
WHILE n LT 1000 DO BEGIN
    READF,1,S    ;Read a line of data
    ;PRINT,S      ;Print the line
    H[*,n]=S     ;Store it in H
    T_mean[n]=mean(H[1:9,n])
     n=n+1      ;Increment the counter

ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]

T1=H[2,*]
ht=H[0,*]
plot,smooth(T1,100),ht,yrange=[10,30],xtitle='Temperature',ytitle='Height km';, color=25,;background=-2;,/nodata ;blue color

For i=3, 9 do begin
Ti=H[i,*]
oplot,smooth(Ti,100),ht;, color=20*(n-5)
endfor
stop

T_mean=T_mean[0:n-1]
y=T_mean
oplot,y,ht,thick=2;color=-35
oplot,smooth(y,100),ht,thick=4
stop

 DEVICE, GET_DECOMPOSED=old_decomposed
 DEVICE, DECOMPOSED=0
 fnm=''
 read,fnm,prompt='filename to output'
filename ='d:\RSI\TEMP\'+fnm+'.png'

WRITE_PNG, filename, TVRD(/TRUE)
end

