Pro PLOT_CWB_TONGA
;
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
 FNMD='CWB_KH_Jan15_20.txt'
 ;FNMD='CWB_YU_2022011520.txt';
 ;FNMD='HC_2022011520.txt'
 ;path='D:\Lidar_DATA\'+year+'\';
 fx=filepath+FNMD;  bpath='G:\0425B\'
 ;fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
   stop

    A=read_ascii(fx)
    B=A.(0)
    help,B

stop

  ;  stop
    Nx=B[1,*]
    P1=B[2,*]
    T1=B[3,*]
    help,P1,T1

;;******Remove NA by eliminating the raw      *****
 ;   q1=where(~finite(P1));
 ;   nq1=n_elements(q1);
 ;    P1[q1[0]]=P1[q1[0]-1]

 ;     for j=1,nq1-1 do begin
 ;      P1[q1[j]]=P1[q1[j-1]]
 ;     endfor
;
 ;     q2=where(~finite(T1));
 ;   nq2=n_elements(q2);
 ;     T1[q2[0]]=T1[q2[0]-1]
;
 ;     for k=1,nq2-1 do begin
 ;      T1[q2[k]]=T1[q2[k-1]]
 ;     endfor
;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     y1=1010.
     y2=1025.0
  window,0
   !p.multi=[0,1,2]

   SmP1=smooth(P1,100)

   plot,P1,color=2,background=-2,xrange=[0,1439],yrange=[y1,y2],title='Yu San Pressure'

   oplot,smp1,color=90
   stop

   DP1=P1-SmP1
   plot,DP1,color=2,background=-2;  ,yrange=[638,645]

   stop
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

