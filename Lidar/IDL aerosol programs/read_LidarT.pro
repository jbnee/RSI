PRO TREAD_LidarT, H, filename

Loadct,13
;!P.BACKGROUND= 1 ; 0 = black, 1 = white
  ; TVLCT,  255, 255, 255, 254 ; White color
  ; TVLCT, 0,0, 0, 255       ; Black color
   !P.Color = 30
   !P.Background = 240
filename='d:\rsi\temp\Lidar_T2001ja16.txt'
OPENR,1,filename
H=FLTARR(10,1000) ;A big array to hold the data
S=FLTARR(10,1)      ;A small array to read a line
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
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
T1=H[2,*]
T_mean=T_mean[0:n-1]
ht=H[0,*]
plot,T_mean,ht, color=5,background=-2;,/nodata
;oplot,T_mean,ht,color=2
oplot,smooth(T_mean,100),ht,color=4 ,linestyle=1,thick=2
oplot,T1,ht,color=46,linestyle=2
stop
oplot,smooth(T_mean,200),ht,color=4 ,linestyle=3,thick=5
stop
END



;FOR n=0,999 DO BEGIN
    ;READF,1,S    ;Read a line of data
   ; PRINT,S      ;Print the line
;   ; H[*,n]=S     ;Store it in H
;ENDFOR
;CLOSE,1
;END