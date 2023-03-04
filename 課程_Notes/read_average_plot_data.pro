PRO  read_average_plot_data
 bT=50     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 4000  ;30 km
   ; binx=2500
   dz=bt*ns*c/2 ;7.5;   24;  bT*ns*c/2  ;increment in height is dz=24 m
    z=dz*findgen(bnum+1)+dz;   Height in m
   ht=z/1000.  ; height in km

  path1='f:\lidar_data\test\';
   yr=''
   read,year, prompt='input year? '
   yr=string(year,format='(I4.4)')

   dnm=''
   Read, dnm, PROMPT='Enter filename to plot dnm:;'
   close,/all
   filename=path1+dnm+'.txt'
   line=''
   print,line
  OPENR,1,filename
  readf,1,line
  print,line
  read,dx,dy,prompt='dimension as 15, 200:  '
  xdata=fltarr(dx,dy)
  readf,1,xdata

stop
plot,xdata[0,*],ht,color=1,background=-2
  AV=5
  PL=fltarr(dx/av,dy)
   For i=0,dx/av-1,5 do begin
     for J=0,dy-1 do begin
        pl[i,*]=total(xdata[i:i+4,*],2)
        oplot,pl[i,*],ht,color=55

     endfor;j
   endfor;i

stop

END