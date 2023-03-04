Pro FFT_2DFRayleigh
close,/all
Tdata=fltarr(16,918)
yb=fltarr(900,900)
z=fltarr(15,900)
line=''
openr,1,"d:\rsi\lidar\Ray_data\Lidar_T2000JN07.txt"
readf,1,line
READF,1,Tdata
close,1
x=Tdata(0,*); height as x
y=Tdata(1:15,0:899); T as y

n1=15
n2=900
cx=findgen(n1)
cy=findgen(n2)
loadct,39
contour,y,cx,cy,/fill
stop


 ;normalize Z with max(z)=1, min(z)=0 using eq. y=az+b a=1/(max-min), b=1-max/(max-min)
p=max(y)
q=min(y)
dpq=p-q;
;Normalize data to 0-1
for i=0,n1-1 do begin
  for j=0,899 do begin
   z(i,j)=y(i,j)*(1./dpq)+(1.00-p/dpq)
  end
end
; Add two different rotations to simulate a crystal structure.
;z = ROT(z, 10) + ROT(z, -45)

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