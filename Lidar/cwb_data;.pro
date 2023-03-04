Pro  CWB_data;,H, filename
;PRO READ_LidarT, H, filename
filename='d:\RSI\Ja16_radiosonde.txt';  \testidl\Lidar_T2001ja16.txt'
OPENR,1,filename
H=FLTARR(9,100) ;A big array to hold the data
S=FLTARR(9,1)      ;A small array to read a line
R=1.38104e-025


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
Ht=H2[3,*]
P=H2(2,*)
T=H2(4,*)
;T=fltarr(n)
T2=fltarr(n)
den=fltarr(n)
m=0
x=intarr(20)
For j=0,n-1 do begin;finding element of 999
  ;For k=0,8
  if(H2[4,j] GT 998) then begin
  x[m]=j
  m=m+1
  endif
endfor

;nx=sx[1]
for k=0,n-1 do begin
  IF (T[k] NE 999.9) THEN BEGIN
   T2[k]=T[k]
  ENDIF ELSE BEGIN
   T2[k]=T2[k-1]

  ENDELSE
 ;ENDIF
endfor
   den=P/(R*(T2+273))
 plot,T2
stop
plot,den, Ht

stop
q1=poly_fit(ht,den,4)
 qden1=q1[0]+q1[1]*ht+q1[2]*ht^2+q1[3]*ht^3+q1[4]*ht^4
oplot,qden1,ht,psym=1
;q2=curvefit(ht,den)
 ;qden2=q2[0]+q2[1]*ht+q2[2]*ht^2+q2[3]*ht^3+q2[4]*ht^4
;oplot,qden2,ht,psym=3
stop
END

