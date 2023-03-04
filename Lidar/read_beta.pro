Pro READ_beta
; Read Licel converted ascii txt files then plot 4 channels
  CLOSE,/ALL
;!p.multi=[0,1,2]
;!p.background=255

 dnm=''
 READ,dnm,PROMPT='DATE name:'
  bpath='f:\RSI\lidar\Fernald\new2019\';

  fx=bpath+dnm+'.txt';
 ; fls=file_search(fx)
   ; nf=size(fls)
  ;  PRINT,'NUM OF FILES: ',NF
   ;STOP

;   dayf=''
 ; read,dayf,prompt='input day of interest:'
  ;fi_date=strmid(fls[0],33,2)
 ; dayx=where(strmid(fls,33,2) eq DA)
 ; print,dayx

 openr,1,fx
 line=''
 readf,1,line
 print,line
 readf,1,line
 print,line

;stop
dz=24;

;ht=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
    read,N,prompt='numer of files: '
    read,b1,b2,prompt='b1,b2, lo and hi: '
    ;h1=1.0
   ; h2=4.0
   h1=round(b1*1000./dz)  ;in km
   h2=round(b2*1000./dz)  ;ch
   nbin=b2-b1+1
   ht=indgen(nbin)*dz
   beta=fltarr(N,nbin)
    readf,1,beta
    plot,beta[0,*],ht,color=2,background=-2
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  stop
  for j=0,N-1 do begin
  oplot,beta[j,*]+j*2,ht,color=2
  endfor


  stop
 ; !p.multi=[0,4,1]
;p1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; p2 = [0.1,0.6,0.90,0.95]

  ; film=dnm+'.'+strtrim(I,2)+'m'



  end
