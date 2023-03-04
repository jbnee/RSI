Pro Lidar_md_ratio_SR430

; this program plot ratio of d to m channels in normalized PR2/max-----------------------------
;start with a colour table, read in from an external file hues.dat

;device, decomposed=0
 Year=''
 read,year,prompt='Input year:  '

 ;year=2009;   year\month
 YR=string(year,format='(I4.4)')

 dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja152233;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4);file_basename1='d:\LidarPro\1997\au\';mr312023.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 bw=160.e-9;50.e-9  ;bin width=50 ns
 dz=24; 7.5
 bnum=1000;4000
 T=findgen(bnum)
 ht=dz*T/1000

; ht=3.0E8*bw*T/2./1000.   ;convert ht to km


;fx=file_basename1+dnm+'.'
read,n1,n2, prompt='Initial and file number as 1,99: '

read,h1,h2, prompt='height range in km 1,6 km,,,,'
bn1=round(h1*1000./dz)
bn2=round(h2*1000./dz)
dbn=bn2-bn1
  nx=n2-n1+1
 s1=strtrim(fix(n1),2)
 s2=strtrim(fix(n2),2)
 S='                                       file:'+s1+'_'+s2
   bnum=1000

  pr2m=fltarr(nx,bnum)
  Npr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  Npr2d=fltarr(nx,bnum)
  dm_ratio=fltarr(nx,dbn)
   bk1=fltarr(nx)
   bk2=fltarr(nx)

   !P.multi=[0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]


   cnt_sig1=fltarr(bnum)
   cnt_sig2=fltarr(bnum)

   ;sig2=fltarr(nx-1,bnum)
   data_path='f:\lidar_data\
   out_path='f:\lidar_data\out_2018\'
   close,/all

;;;;;;;;;;;;NORMALIZATION OF D/M SIGNALS ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fbk=fltarr(nx)
   For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+Jr ;file index starting from n1
      ni=strcompress(fix(jf),/remove_all)
    fn1=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'
    fn2=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'

    ;openr,1,fn1;
   ; readf,1,cnt_sig1;
   ; close,1
   ; openr,2,fn2
   ; readf,2,cnt_sig2;
   ; close,2
     cnt_sig1=read_binary(fn1, DATA_TYPE=2)  ; cnt_sig  ;read binary file
      cnt_sig2=read_binary(fn2, DATA_TYPE=2)  ; cnt_sig  ;read binary file

    ; plot,cnt_sig
    bk1[jr]=min(cnt_sig1[bnum-1000:bnum-1])
    mn1=mean(bk1)
    bk2[jr]=min(cnt_sig2[bnum-1000:bnum-1])
    mn2=mean(bk2)
    fbk[jr]=(mn2/mn1)/0.014;;;NORMALIZATION FACTOR
   ;print,'fbk: ',fbk
   ; sig1=cnt_sig1[bn1:bn2-1]-bk1[jr]
     sig1=cnt_sig1[0:999]-bk1[jr]
     sig2=cnt_sig2[0:999]-bk2[jr]
   ; sig2=cnt_sig2[bn1:bn2-1]-bk2[jr]

   ; pr2m[jr,bn1:bn2-1]=smooth(sig1,10)*ht^2
   ;pm=where(pr2m[jr,bn1:bn2] LT 0)
    ;pr2d[jr,bn1:bn2-1]=smooth(sig2,10)*ht^2
   ; pd=where(pr2d[jr,bn1:bn2] LT 0)
    pr2m[jr,*]=smooth(sig1,10)*ht^2
    pm=where(pr2m[jr,*] LT 0)

    pr2d[jr,*]=smooth(sig2,10)*ht^2
    pd=where(pr2d[jr,*] LT 0)

   ; print,jr,PM,PD
  endfor;jr
 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]

 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title


    s0=strtrim(fix(ni),2)

   ; read,hx,prompt='input height of  cloud presence as 2 km: '
    ;ichn=round(hx/0.0075)  ; chnn number

    plot,pr2d[0,*],color=2,background=-2,position=plot_position1
    oplot,pr2m[0,*],color=2
    for ix=1,nf-ni do begin
      ;sn=strtrim(fix(ix1),2)

       oplot,pr2d[ix,*],color=2
    ;wait,2
    endfor;ix
    ;stop
     dmratio=fltarr(nx)
     dmratio=pr2d[*,bnum-500:bnum-1]/pr2m[*,bnum-500:bnum-1]
    ;plot,smooth(dmratio0,5),color=2,position=plot_position2;yrange=[0,0.2]
    plot,dmratio,color=2,background=-2
    oplot,mbk,color=100

    print, 'mean bk: ',mean(mbk)
  ;   print,'mean ratio: ',mean(dmratio)
   ; print,'normalizatin: ',mean(dmratio)/0.0104;
   ; print,'STD dev: ', stddev(dmratio)
   ; print,'STD/mean:  ',stddev(dmratio)/mean(dmratio)
   ; print,'mean fbk, STDV :',mean(fbk),stddev(fbk)

     stop
   end