PRO T_Hanning, H, filename
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
 filename='d:\rsi\lidar\Ray_data\T2001ja16.txt'  ;array ~10x915
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
T_mean=T_mean[0:n-1]
y=T_mean
ht=H[0,*]
plot,y,ht, color=15;background=-2;,/nodata ;color green
xa=[190,200]
ya=[2,2]
plots,xa,ya, color=15, thick=2
xyouts,205,2,'blue:Mean T profile'


stop
;oplot,T_mean,ht,color=2
;oplot,smooth(y,100),ht,color=-10 ,linestyle=1,thick=3 ; red color
;stop
;oplot,T1,ht,color=100,linestyle=2; color=green
;stop
oplot,smooth(y,200),ht,color=75 ,linestyle=3,thick=5; thick green
xa=[190,200]
yb=[3,3]
plots,xa,yb, color=75
xyouts,205,3,'thick green:Mean T + smooth 200 points'


stop
;;;test Hanning filter
;k=hanning(50)
;z=convol(y,k,/edge_truncate,/normalize)
;oplot,z,ht,color=2,thick=4 ;blue thick
;stop
;;;;;;;;Progressive Hanning filter from 50 to 200 below
jn=0
;first 300 point using Haning(50)
while (jn LT 299) do begin   ; #1
k1=hanning(50)
z1=convol(y[0:299],k1,/edge_truncate,/normalize)
jn=jn+1
endwhile
; next:300 to 500 doing Hanning(100) 100 points about 1km
while (jn GE 299) and (jn LT 499) do begin;  #2
k2=hanning(100)
z2=convol(y[300:499],k2,/edge_truncate,/normalize)
jn=jn+1
endwhile
; next 300 points using Hanning (150)
while (jn GE 400) and (jn LT 699) do begin
k3=hanning(150)
z3=convol(y[500:699],k3,/edge_truncate,/normalize)
jn=jn+1
endwhile
; next 300 using Hanning(200) about 3 km filter
while (jn GE 699) and (jn LT 915) do begin
k4=hanning(200)
z4=convol(y[700:914],k4,/edge_truncate,/normalize)
jn=jn+1
endwhile
;endwhile
;endwhile
Z=fltarr(915)
Z=[z1,z2,z3,z4]
Y2=transpose(z)
oplot,Y2,ht,color=-45, thick=3
stop
yc=[5,5]
plots,xa,yc, color=-45
xyouts,205,5,'red color= Hanning spatial filter'

;END

DEVICE, GET_DECOMPOSED=old_decomposed
 DEVICE, DECOMPOSED=0
 fnm=''
 read,fnm,prompt='filename to output'
filename ='d:\RSI\Lidar\Ray_data\'+fnm+'.png'

WRITE_PNG, filename, TVRD(/TRUE)
stop
end





;FOR n=0,999 DO BEGIN
    ;READF,1,S    ;Read a line of data
   ; PRINT,S      ;Print the line
;   ; H[*,n]=S     ;Store it in H
;ENDFOR
;CLOSE,1
;END