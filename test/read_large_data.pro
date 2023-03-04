Pro READ_large_DATA
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
    X=''
    openr,1,fx
    P1=fltarr(10000)
    T1=fltarr(10000)
    for I=0,9999 do begin

    readf,1,x
    ;print,H
    P1[I]=fix(strmid(x,15,7));
    T1[i]=fix(strmid(x,22,6));
    endfor


   ; P1=B[2,*]
    ;T1=B[3,*]
    help,P1,T1

   ; stop

    plot,p1,color=2,background=-2,yrange=[1016,1022],xrange=[0,10000]
    plot,t1,color=2,background=-2,yrange=[15,30],xrange=[0,10000]

   stop
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



stop
end

