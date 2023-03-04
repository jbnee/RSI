Pro readCWB;,H, filename
;PRO READ_LidarT, H, filename
filename='d:\RSI\Ja16_radiosonde.txt';  \testidl\Lidar_T2001ja16.txt'
OPENR,1,filename
H=FLTARR(9,100) ;A big array to hold the data
S=FLTARR(9,1)      ;A small array to read a line

 ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a count
line=''
for l=0,4 do begin
readf,1,line;
print,line
endfor

WHILE n LT 100 DO BEGIN
    READF,1,S    ;Read a line of data

    PRINT,S      ;Print the line
    H[*,n]=S     ;Store it in H
    ;T_mean[n]=mean(H[1:9,n])
     n=n+1      ;Increment the counter
     ;stop
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is dete
H2=H[*,0:n-1]
Ht=H2[3,0:n-1]
T=fltarr(n)
T2=fltarr(n)
m=0
x=intarr(20)
For j=0,n-1 do begin;finding element of 999
  ;For k=0,8
  if(H2[4,j] GT 998) then begin
  x[m]=j
  m=m+1
  endif
endfor
T=H2(4,*)
;sx=size(x)
;nx=sx[1]
for k=0,n-1 do begin
  IF (T[k] NE 999.9) THEN BEGIN
   T2[k]=T[k]
  ENDIF ELSE BEGIN
   T2[k]=T2[k-1]
  ENDELSE
 ;ENDIF
endfor
 plot,T2
 ;oplot,T

;T1[n]=(H[4,n-1]+H[4,n+1]/2
;T_mean=T_mean[0:n-1]
;ht=H[0,*]
;plot,T_mean,ht;,£background=-2,color=3,psym=1


stop
END

