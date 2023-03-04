Pro READ_Licel_ASCII
; Read Licel converted ascii txt files then plot 4 channels
  CLOSE,/ALL
;!p.multi=[0,1,2]
;!p.background=255
 mon='AP'
 DA=''
 READ,DA,PROMPT='DATE OF DATA SUCH AS 08:'
  bpath='f:\Lidar_data\2007\'+mon+'\'+mon+'_TEX';
  fx=bpath+'\t*'
  fls=file_search(fx)
    nf=size(fls)
    PRINT,'NUM OF FILES: ',NF
   ;STOP

;   dayf=''
 ; read,dayf,prompt='input day of interest:'
  ;fi_date=strmid(fls[0],33,2)
  dayx=where(strmid(fls,33,2) eq DA)
  print,dayx
  S1=n_elements(dayx)
  print,';;;;;;;'
  print,'number of files:',S1
  stop
    ;;;;;;;;;;SEARCH FOR DATE
   ; dayx=where(strmid(fls,33,2) eq DA)
    print,'Number of files of this date:',n_elements(dayx)

    read, N0,prompt='number of files to read, such as first 50:'
   sdnm=strmid(fi,30,10)
da=strmid(sdnm,3,2)
hr=strmid(sdnm,5,2)
minute=strmid(sdnm,8,2)
dnm=mon+da+hr+minute  ; this is the file name

print,dnm


  for  J=0,N0-1  do begin

   fi=fls[J]

   fi_date=strmid(fls[J],33,2)
   if (fi_date eq da) then begin
   ;print,J
   endif else begin
   J=J+1
   endelse
   ;stop
   dayx=where(strmid(fls,33,2) eq DA)
   ENDFOR
  ; PRINT,DAYX
   ;STOP

  S1=n_elements(dayx)
  ;print,'total number of files of the DATE:',S1
  stop

stop
 N=2500;  4000
T=findgen(N)

ht=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
  FX=BPATH+'\T*';    e*'
  ;fx=bpath+'\t09726*';  yr+'\'+month+'\'+dnm+'.'
  ; read,h1,h2,prompt='Initial and final height as ,1,5 km:'

 nx=nf[1]
    read,h1,h2,prompt='Height region as 1, 5  km: '
    ;h1=1.0
   ; h2=4.0
    n1=round(h1*1000./7.5)  ;channel number
    n2=round(h2*1000./7.5)  ;ch
   ;s1=strtrim(fix(ni),2)
   ;s2=strtrim(fix(nf),2)
   ;Sw ='                                       file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,N);n2-n1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,N)
    pr2d=fltarr(nx,N)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''
    m=S1

    read,m2,prompt='additional files to add:This means add files of the next day:  '
    m=m+m2
    DATAB=FLTARR(4,N)
    APM=fltarr(m,N)
    BPM=fltarr(m,N)
    APD=fltarr(m,N)
    BPD=fltarr(m,N)
    close,/all
   FOR I=0,m-1 DO BEGIN
    OPENR,1,fls[I]
    readf,1,hd
    READF,1, DATAB
    APM[i,*]=datab[0,*] ; DIGITAL channel
     bk1=mean(APM[i,N-200:N-1]) ; take background
    APM[i,*]=APM[i,*]-bk1

    BPM[i,*]=datab[1,*] ; ANALOG channel
     bk2=mean(BPM[I,N-200:N-1])
    BPM[i,*]=BPM[i,*]-bk2

    APD[i,*]=datab[2,*] ; analog channel
     bk3=mean(APD[i,N-200:N-1]) ; take background
    APD[i,*]=APD[i,*]-bk3

    BPM[i,*]=datab[1,*] ; ANALOG channel
     bk3=mean(BPM[I,N-200:N-1])
    BPM[i,*]=BPM[i,*]-bK3

    BPD[i,*]=datab[3,*] ; digital channel
     bk4=mean(BPD[I,N-200:N-1])
    BPD[i,*]=BPD[i,*]-bk4
    ; sig=fltarr(nx,40000)
    close,1

   ENDFOR
  ;;;end part 1
  stop
  !p.multi=[0,4,1]
;p1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; p2 = [0.1,0.6,0.90,0.95]

  ; film=dnm+'.'+strtrim(I,2)+'m'

;STOP
plot,APM[0,*],ht,color=2, background=-2,xrange=[0,5000],yrange=[h1,h2];position=p1

FOR J=0,M-1,5 DO BEGIN
oplot,APM[J,*]+J*40,ht, color=5+j
ENDFOR
stop

plot,BPM[0,*],ht,color=2, background=-2,xrange=[0,5000],yrange=[h1,h2];position=p1

FOR J=0,M-1,5 DO BEGIN
oplot,BPM[J,*]+J*40,ht, color=5+j
ENDFOR
stop

plot,APD[0,*],ht,color=2, background=-2,xrange=[0,5000],yrange=[h1,h2];position=p1

FOR J=0,M-1,5 DO BEGIN
oplot,APD[J,*]+J*40,ht, color=5+j
ENDFOR
stop
plot,BPD[0,*],ht,color=2,background=-2,position=p2,yrange=[h1,h2],xrange=[0,5000]

FOR K=0,M-1,5 DO BEGIN
oplot,BPD[K,*]+K*40,ht,color=5+K
ENDFOR

stop
TAPM=total(APM,1)/N0
TBPM=total(BPM,1)/N0
TAPD=total(APD,1)/N0
TBPD=total(BPD,1)/N0
window,1
plot,TAPM,ht,color=2,background=-2, position=p1,yrange=[h1,h2],xrange=[0,200]

plot,TBPM,ht,color=2,background=-2,position=p2,yrange=[h1,h2],xrange=[0,200]

plot,TAPD,ht,color=2,background=-2,position=p3,yrange=[h1,h2],xrange=[0,200]

plot,TBPD,ht,color=2,background=-2,position=p4,yrange=[h1,h2],xrange=[0,200]

stop

  end
