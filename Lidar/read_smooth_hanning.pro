PRO read_smooth_Hamming, H, filename
device, decomposed=0
;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'F:\rsi\hues.dat'
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

filename='F:\rsi\test1\Lidar_T2001ja16.txt'  ;array ~10x915
 ;filename='d:\rsi\temp\Lidar_T2001ja16.txt'  ;array ~10x915
;filename='F:\rsi\TEST1
;A=read_ascii(filename)
;B=A.(0)

A=FLTARR(10,1000) ;A big array to hold the data
S=FLTARR(10,1)      ;A small array to read a line
T_mean=fltarr(1000)
ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=1 ; Create a count
openr,1,filename
WHILE n LT 1000 DO BEGIN
    READF,1,S    ;Read a line of data
    PRINT,S      ;Print the line
    A[*,n]=S     ;Store it in H
    T_mean[n]=mean(A[1:9,n])  ; The mean of all 9 profiles
     n=n+1      ;Increment the counter

ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
stop
A=A[*,0:n-1]
;T1=A[2,*]
T_mean=T_mean[0:n-1]
y=T_mean
ht=A[0,*]
plot,y,ht, color=5;background=-2;,/nodata ;blue color
;oplot,T_mean,ht,color=2
oplot,smooth(y,100),ht,color=1 ,linestyle=1,thick=2
;oplot,T1,ht,color=100,linestyle=2; color=green
;stop
oplot,smooth(y,200),ht,color=-10 ,linestyle=3,thick=5; Negative is red
stop
k=hamming(50)
z=convol(y,k,/edge_truncate,/normalize)
oplot,z,ht,color=2,thick=4  ;blue thick
stop
jn=0

while (jn LT 299) do begin   ; #1
k1=hamming(50)
z1=convol(y[0:299],k1,/edge_truncate,/normalize)
jn=jn+1
endwhile

while (jn GE 299) and (jn LT 499) do begin;  #2
k2=hanning(100)
z2=convol(y[300:499],k2,/edge_truncate,/normalize)
jn=jn+1
endwhile

while (jn GE 400) and (jn LT 699) do begin
k3=hanning(150)
z3=convol(y[500:699],k3,/edge_truncate,/normalize)
jn=jn+1
endwhile

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

;END

DEVICE, GET_DECOMPOSED=old_decomposed
 DEVICE, DECOMPOSED=0
 fnm=''
; read,fnm,prompt='filename to output'
;filename ='d:\RSI\Lidar\Ray_data\'+fnm+'.png'

;WRITE_PNG, filename, TVRD(/TRUE)
stop
end

