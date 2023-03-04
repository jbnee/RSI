Pro Fernal_SR430m_ev
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   bT=160      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 1000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
      density=fltarr(bnum+1);air density
      density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

     plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
  Sa=50; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air

   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction

for j=bnum-2,0,-1 do begin
    tau[j]=tau[j+1]+(kext[j]+kext[j+1])*dz1000/2
    Tm[j]=exp(-2*tau[j])
 endfor
plot,tau,ht,xtitle='opt,thick and transmission',xrange=[0,1]
xyouts,0.1,15, 'optical thickness'
oplot,Tm,ht; ,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.5,10,'atmospheric transmission'

 stop
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=0
FOR I1=bnum-1,1,-1 do begin

 INTB[I1]=INTB[bnum]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)
ENDFOR
plot,INTB,ht
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=0
FOR I1=bnum-1,1,-1 do begin

 INTB[I1]=INTB[bnum]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)
ENDFOR
plot,INTB,ht,xtitle='integrated beta_r top down', ytitle='km'

stop
;Part 2 Read data
  close,/all

  Data_path="E:\lidar_data\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  year=''
  Read,year,  prompt='Enter  Year as 2003: '

  yr=strtrim(year,2);  remove white space


  event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''

  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  m0=2;5  ;number of data to average usually 5
  n5=nx/m0
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS='                                       file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm


   sg=fltarr(n2-n1+1,bnum)
   sumsg=0
  PR2M=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2
  ;V1=fltarr(nx,bnum)  ;  分子項 upper term in Fernald
  beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 0, 6 km  '
  ; input data
   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
    ; openr,1,fn; data_file;
    ; readf,1,cnt_sig
     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1
      cnt_sig=cnt_sig(0:bnum-1)
      sm_sig=smooth(cnt_sig,5)
     bk=min(sm_sig[bnum-200:bnum-1]);  treat background
    ; sg[Jr,*]=smooth(cnt_sig,5)-bk;smooth signal
       sg[Jr,*]=sm_sig-bk
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg
     ;for mr=0:bnum-1 ; to remove negative
      if min(sg[jr,*]) le 0 then sg[jr,*]=sg[jr,*]-min(sg[jr,*])

     ;endfor;mr

     PR2M[jr,*]=sg[jr,*]*(z^2);*Tm

     if (Jr eq 0) then begin
        plot,PR2M[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
     endif else begin

   endelse
   endfor


 stop  ; section 1
;;;;;

;average 5 profiles
 j2=0
FOR i=0,nx-m0,m0 do begin; average 2, 5 profiles

For iy=0,bnum-1 do begin
X[J2,iy]=MEAN(PR2M[i:i+m0-1,iy])

endfor
j2=j2+1
endfor
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged
 lo_bin=round(h1/dz)
 hi_bin=round(h2/dz)
 ;Izt= 840; bnum-            ;top beam at 20 km which is 840

 BTM=dblarr(n5,bnum)  ; 分母  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V1=fltarr(n5,bnum)
 sumbtm2=fltarr(n5)
 ;Initial condition
    ;BTM1[*]=0; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
    BTM2[*,bnum-1]=0; Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
    BTM[*,bnum-1]=0; BTM1[*,0]+BTM2[*,0]

     beta_a(*,hi_bin)=0;10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a


  ; stop
; evaluation of the second bottom term below
  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   sumBTM2[nj]=0
   b2=hi_bin
   BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    while (BTM1[nj] eq 0) do begin
      b2=b2-1
      BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    endwhile


   For k =hi_bin-1 ,1,-1 do begin   ;calculation start from hi_bin
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V1[nj,k]=X[nj,k]*exp(+A[k])
     ;BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]))*dz1000
      BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]))*dz1000
     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V1[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    maxa=max(beta_a[0,*])
    plot,beta_a[0,0:hi_bin],ht,yrange=[h1,h2],xrange=[0,2*maxa],background=-2,color=1,xtitle='beta_a',TITLE=FTITLE+FS
    oplot,beta_r,ht,color=150

    stop; section IIA

    For k=0,n5-1 do begin
         oplot,beta_a[k,0:hi_bin]+k*0.000005,ht,color=2  ;ht[100:hi_bin-100]

    ENDFOR ;k

      stop
    out_path='f:\RSI\\lidar\Fernald\new2019\';
   READ,N,PROMPT='FILE NUMBER TO PLOT: '
    plot,beta_a[N,0:hi_bin],ht,yrange=[h1,h2],xrange=[0,1*maxa],background=-2,color=1,xtitle='beta_a',TITLE=FTITLE+N
    oplot,beta_a[N+1,0:hi_bin],ht,color=2
    ;oplot,beta_r,ht,color=150
 stop
    ; Fernald_out\'; lidarPro\output\yrmn"
      fnm=strmid(dnm,0,4)
      out_plot1=OUT_path+fnm+'M_beta'+'.png'
      write_png,out_plot1,tvrd()


      close,2

      outdata1=out_path+fnm+'M_beta.txt'
      hd='lo_bin,hi_bin,nx(total file)'

      hd1=lo_bin
      hd2=hi_bin
      hd3=nx ;size(beta_a)
      hds=string(hd1)+string(hd2)+string(nx)
      openw,2,outdata1
      printf,2,hd
      printf,2,hds
      printf,2,beta_a[*,0:hi_bin]
      stop
      km=1000.0
      Ba_km=km*beta_a[*,0:hi_bin-1]; in km unit
      Av_EXT=SA*total(Ba_km,1)/n5 ; exinction in km
      plot,AV_ext-min(AV_ext),ht,color=2,yrange=[h1,h2],background=-2,xtitle='extinction 1/km',ytitle='km'
      oplot,km*SR*beta_r,ht,color=180

      stop
      out_plot2=OUT_path+fnm+'M_EXT'+'.png'
      write_png,out_plot2,tvrd()


      close,2

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      stop ;secion IIB
       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

    bratio[0,0:hi_bin]=1+smooth(beta_a[0,0:hi_bin]/beta_r[0:hi_bin],10)
     plot,bratio[0,0:hi_bin],ht,xrange=[0,300],yrange=[h1,h2],background=-2,color=1,title=FTITLE+FS,xtitle='bacattering ratio 0',ytitle='km'

      ;bbratio=bratio
      stop  ;IIC

       For L=1,n5-1 do begin;  n2-n1 do begin
       bratio[L,0:hi_bin]=1+smooth(beta_a[L,0:hi_bin]/beta_r[0:hi_bin],10)
       oplot,bratio[L,0:hi_bin],ht,color=1  ;hi_bin-100

       endfor
     stop

     avratio=total(bratio,1)/(L+1)
     plot,avratio,ht[0:hi_bin],color=4,background=-2,linestyle=2,thick=5,xtitle='ave m backscatt ratio',ytitle='km',TITLE=FTITLE+FS
     stop    ;Section III
      out_file2=out_path+fnm+'M_BK_ratio.'+'png'
     write_png,out_file2,tvrd()

     stop


     end



