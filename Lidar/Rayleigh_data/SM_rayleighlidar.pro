Pro SM_RayleighLidar
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



end