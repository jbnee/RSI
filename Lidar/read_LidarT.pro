PRO READ_LidarT, H, filename
filename='d:\rsi\testidl\Lidar_T2001ja16.txt'
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
T_mean=T_mean[0:n-1]
ht=H[0,*]
T1=H[5,*]
;T_sum=
plot,T1,ht,background=-2,color=1
oplot,T_mean,ht,color=3,psym=1
stop
END



;FOR n=0,999 DO BEGIN
    ;READF,1,S    ;Read a line of data
   ; PRINT,S      ;Print the line
;   ; H[*,n]=S     ;Store it in H
;ENDFOR
;CLOSE,1
;END