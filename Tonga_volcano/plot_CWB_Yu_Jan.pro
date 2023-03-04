Pro PLOT_CWB_YU_Jan
; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
CLOSE,/ALL
ERASE

FNMD='';  file name
year='2022'
;read,year,prompt='Input year of data as 2019:'
;read,FnmD,PROMPT='NAME OF THE dataFILE  C: '
;FnmD='0115 PM ASC'
print,'filename: ',FnmD

mon='Jan'
filepath='E:\RSI\Tonga_Volcano\'
  ;FNMD='CWB_KaoHisung_202201-202202.txt '
 ;FNMD='CWB_KH_Jan15_20.txt'
   FNMD='CWB_YU_Jan.txt';
 ;FNMD='CWB_HC_Jan15_20.txt'
 ;path='D:\Lidar_DATA\'+year+'\';
 fx=filepath+FNMD;  bpath='G:\0425B\'
 ;fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
   stop
    nA=44640;
    A=fltarr(3,nA)
    CWBJ15=filepath+FNMD

   B=read_ascii(fx)
   A=B.(0)
    ; close,1

  ;  stop
    Nx=A[0,1:nA-1]
    P1=A[1,1:nA-1]
    T1=A[2,1:nA-1]
    help,P1,T1
    Nx=Nx-Nx[0]
    mp=n_elements(P1)
    mT=n_elements(T1)
    stop
;;******Remove NA by setting P1/T1=0     *****
   q1=where(~finite(P1));
   nq1=n_elements(q1);
   ;while (nq1 NE 0) do begin
   ; P1[q1[0]]=P1[q1[0]-1]
     P1[q1]=0
     T1[q1]=0;


  window,0
   !p.multi=[0,1,2]

   SmP1=smooth(P1,100)
   ;for iday=0,4 do begin
   ;nmin=[iday*1500,(iday+1)*1500]
   ;Px=P1[nmin[0]:nmin[1]]
   plot,Nx,P1,color=2,background=-2,xrange=[0,1500],yrange=[630,650],xtitle='min Jan 1 ',ytitle='hPa',$
   title=FNMD
   ;meanP1=mean(Px)
   oplot,Nx,smp1,color=90
   stop

    plot,Nx,T1[0:1500],color=2,background=-2,xrange=[0,1440],yrange=[-10,20];title='KH Temperature'
    SmT1=smooth(T1,100)
    oplot,Nx,SmT1,color=99
  ; NP1=n_elements(P1)
  ; DP1=P1-SmP1
   ;plot,Nx,DP1+meanP1,color=2,background=-2,title='pressure anomaly hPa',xrange=[0,1500]

   stop
   ;endfor
   outpath='E:\Tonga volcano 2022\CWB_plot_output\'
   station_name=''
   read,station_name,prompt='station name,KH, HC, YU? '
   out1=outpath+station_name+'Pressure Jan15.txt';
   P_Jan15=fltarr(3,1500)
   P_Jan15[0,*]=Nx[0:1499]
   P_Jan15[1,*]=P1[0:1499]
   P_Jan15[0,*]=DP1[0:1499]
   openw,2,out1
   printf,2,P_Jan1
   ;;;;***************************************
   out2=outpath+station_name+'_plot Press Jan15.png'
   write_PNG,out2,tvrd()
   close,2

   stop


   plot,P1,color=2,background=-2,xrange=[1440,2880],yrange=[y1,y2]; title='Yu San Pressure'
   P2=P1[1441:2860]
   smP2=smooth(P2,100)
   oplot,smP2,color=120

   plot,P1,color=2,background=-2,xrange=[2880,4320],yrange=[y1,y2];title='Yu San Pressure'
   p3=P1[2881:4320]
   smP3=smooth(P3,100)
   oplot,smp3,color=120

   plot,P1,color=2,background=-2,xrange=[4320,5760],yrange=[y1,y2];,title='Yu San Pressure'
   P4=p1[4321:5760]

   smp4=smooth(P4,100)
   oplot,smp4,color=90


   stop

   window,1
    !p.multi=[0,1,4]
    plot,T1,color=2,background=-2,xrange=[0,1440],title='KH Temperature'
    plot,T1,color=2,background=-2,xrange=[1441,2880]

     plot,T1,color=2,background=-2,xrange=[2881,4320]

     plot,T1,color=2,background=-2,xrange=[4321,5760]
;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;


STOP

outpath='E:\Tonga volcano 2022\Lidar outputs\'
xx=''
read,xx,prompt='add description such as files'
outplot=outpath+'FFT'+xx+da+'.png';
write_png,outplot,tvrd()
close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
outs=fltarr(2,ns-1)
outs[0,*]=peri
outs[1,*]=power
outdata=outpath+'power FFT'+da+'.txt'
openw,2,outdata
printf,outs
close,2


stop
end

