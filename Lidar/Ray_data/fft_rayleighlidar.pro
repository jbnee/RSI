Pro FFT_RayleighLidar
close,/all
read,col, prompt='number of columns, 0 is the ht,1~x temperature: '
Tdata=fltarr(col,918)
yo=fltarr(col-1,900)
y=fltarr(col-1,900)
line=''
openr,1,"d:\rsi\lidar\Ray_data\Lidar_T2000JN07.txt"
readf,1,line
READF,1,Tdata
close,1
x=Tdata(0,*); height as x
yo=Tdata(1:col-1,0:899); T as y
for L1=0,col-2 do begin
  y[L1,*]=smooth(yo[L1,*],30)
endfor

; find average for every column
Y_av=fltarr(col-1)
sumy=0
    for  n1=0,col-2 do begin
      Y_av[n1]=total(y[n1,*])
      sumy=sumy+1
    endfor
Y_av=Y_av/900.
plot,Y_av[0:14]
stop
n1=col-1  ; number of temperature columns
n2=900
cx=findgen(n1)
cy=findgen(n2)
Y2=fltarr(15,900)
  for j1=0,14 do begin
     for j2=0,899 do begin
       Y2[j1,j2]=y[j1,j2]-Y_av[j1]
      endfor

  endfor
;divide data into 10-30 in each km group
loadct,39
contour,Y2,cx,cy,/fill
stop



Ho=10 ; starting height
h1=findgen(20)+10
; find average temperature per km
ht=x
h0=fltarr(23)+8
k=0
T_temp=fltarr(col-1,50)
T1=fltarr(col-1,22)
;sum over all data in 8km to 9 km as one and so on
sumT=fltarr(col-1,5)  ;at most 5 data for every km
sumT[0]=0
J=0  ;count from 8 km to 30 km
k=0  ; count from data number
for i1=1, 900 do begin
  h0=round(ht[i])
   while (ht[i1] LT h0[J+1]) and (ht[i] GT h0[J]) do begin
    ;tempT[i1,*]=Tdata[1:14,i1]
    sumT[0:14,i1]=sumT[0:14,i1-1]+Tdata[1:14,i1-1]
    k=k+1
  endwhile
     T1[0:14,k]=sumT/k
     J=J+1
endfor
stop
;
loadct,39
contour,T1,cx,cy,/fill
stop




;WINDOW, XSIZE=540, YSIZE=540
LOADCT, 39
contour,z,cx,cy,/fill
;TVSCL, z, 10,270
stop
; Compute the two-dimensional FFT.
f = FFT(z)
logpower = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
Lpower=logpower[*,450:899]
cy2=cy[450:899]

contour,Lpower,cx,cy2,/fill
 ;TVSCL, logpower, 270,270
stop
; Compute the FFT only along the first dimension.
f1 = FFT(z, DIMENSION=1)
logpower1 = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
;TVSCL, logpower1, 10, 10
contour,logpower1,cx,cy,/fill
stop
; Compute the FFT only along the second dimension.
f2 = FFT(z, DIMENSION=2)
logpower2 = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
;TVSCL, logpower2, 270, 10
contour,logpower2,cx,cy,/fill
stop
end