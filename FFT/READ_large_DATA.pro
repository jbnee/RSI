Pro CWB_FFT_2022Jan
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
  FNMD='CWB_KaoHisung_202201-202202.txt '
 ;FNMD='CWB_KH_20220115.txt'
;FNMD='CWB_YU_2022011520.txt';
 ;path='D:\Lidar_DATA\'+year+'\';
 fx=filepath+FNMD;  bpath='G:\0425B\'
 ;fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
   stop

    A=read_ascii(fx)
    B=A.(0)
    nB=size(B)
    Length=NB[2]
    H=fltarr(4)

    openr,1,fx
    P1=fltarr(length)
    T1=fltarr(length)
    for I=0,Length do begin

    readf,1,H
    ;print,H
    P1[I]=H[2]
    T1[i]=H[3]
    endfor


   ; P1=B[2,*]
    ;T1=B[3,*]
    help,P1,T1

   ; stop




     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    LB=n_elements(B)   ; number of files

   ;  print,'Number of data,: ',LB
   ;  stop
    ;Read,nf1,nf2,prompt='starting and ending file nf1, nf2: '
    nf1=1.0;fix(nf1);
    nf2=1440; fix(nf2);
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    ;stop
    ;DATAB=FLTARR(2,Nbin)
    ;Ps=fltarr(m,Nbin) ;Ps photon counting signal


    ;read,ap, prompt='input 0 for analog,1 for counting:'
    ;a_p=fix(ap)



   ;

;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

!p.multi=[0,1,2]
plot,P1,color=2, background=-2,yrange=[1016,1022],$; KH
;plot,P1,color=2,background=-2,yrange=[635,645],$
xtitle='min ',ytitle='Pressure', title='CWB  pressure/Tenperature ' ;,charsize=1.2,position=pA
plot,T1,color=2,background=-2,yrange=[16,26];
;plot,T1,color=2,background=-2,yrange=[-10,10],ytitle='Temperature';
stop
Y1=FFT(P1)
Y2=FFT(T1)

PLOT,real_part(Y1),imaginary(Y1)
PLOT,Y2

 ;Y1=FFT(Ias1) ;  FFT only the parallel part
 NS=fix(n_elements(Y1)/2);
 ;Y1=Y1[1:NS-1];  remove the first term
 xpower=2*abs(Y1)^2;
 power=xpower[1:NS-1]; REMOVE DC COMPONENT
 plot,power


 stop
 ;
 nyquist=0.5
 ;read,mtime,prompt='Times in minutes of data : '
 ;DT=mtime/N0
 ;;;Timeperdata=DT/N0
 freq=nyquist*(findgen(ns)/ns)
 plot,freq,power,xtitle='frequency',ytitle='power'
 ;plot,freq,power[2:148],xrange=[0,0.1]
 stop
 xfreq=freq[1:(Ns-1)]
 T=1/xfreq; period
 ;power=powerx[1:fix((ns-1)/2)]
 plot,xpower,xrange=[0,ns-1];
 print,strmid(fls[nf1],20,30)
 print,strmid(fls[nf2-1],20,30)

 read,DT,prompt='time span as=240 min.; '
 MT=DT/(nf2-nf1+1)
 print,MT
 np=n_elements(xpower)
 peri=MT*T;   /freq
  !p.multi=[0,1,1]
 plot,peri,xpower,color=2,background=-2,title=DA+' FFT power',$
 xtitle='time min',ytitle='Power',charsize=1.3

 px=max(power);
 pdev=stddev(power)
 pmn=mean(power)

 power_data=[px,pdev,pmn]
; ERR=stddev(power)/mean(power)
; print,'ERR=  ',ERR
stop

print,'Peak and mean Power, std power: ',power_data;

read,x0,y0,prompt='xyouts power data position as 30,10'

 xyouts,x0,y0,power_data,color=2;

  stop
 ;xyouts,x0,y0-dy,'mean(power)',color=2
  ;xyouts,x0*1.2,y0-dy,mean(power),color=2
  ;stop
 ; xyouts,x0,y0-2*dy,'stddev(power)',color=2
; xyouts,x0*2,y0-2*dy,stddev(power),color=2




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

