PRO TREAD_LidarT, H, filename
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
close,/all
 filename='d:\rsi\temp\ja17_01.dat'  ;array ~10x915
read,col,prompt='number of columns:  '
OPENR,1,filename
H=FLTARR(col,1000) ;A big array to hold the data
S=FLTARR(col,1)      ;A small array to read a line
T_mean=fltarr(1000)


ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected


n=0 ; Create a count

WHILE n LT 1000 DO BEGIN
    READF,1,S    ;Read a line of data
    PRINT,S      ;Print the line
    H[*,n]=S     ;Store it in H
    T_mean[n]=mean(H[1:9,n])
     n=n+1      ;Increment the counter

ENDWHILE          ;End of while loop
stop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
T1=H[2,*]
T_mean=T_mean[0:n-1]
y=T_mean
ht=H[0,*]
plot,y,ht, color=25;background=-2;,/nodata ;blue color
stop
;oplot,T_mean,ht,color=2
oplot,smooth(y,100),ht,color=10 ,linestyle=1,thick=3
stop
oplot,T1,ht,color=100,linestyle=2; color=green
;stop
oplot,smooth(y,200),ht,color=-10 ,linestyle=3,thick=5; Negative is red
stop
k=hanning(50)
z=convol(y,k,/edge_truncate,/normalize)
oplot,z,ht,color=25,thick=4

stop
END



;FOR n=0,999 DO BEGIN
    ;READF,1,S    ;Read a line of data
   ; PRINT,S      ;Print the line
;   ; H[*,n]=S     ;Store it in H
;ENDFOR
;CLOSE,1
;END