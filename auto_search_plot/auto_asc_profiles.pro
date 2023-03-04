Pro AUTO_ASC_profiles
; AUTO contour plot for several  ascii txt files

;;**************;PART 1: search for data  ***************

CLOSE,/ALL
ERASE
bnum=8000; total bin number  6000x3.75=22.5 km
T=findgen(bnum)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

 year=''

  read,year, prompt='year as 2003: ?  '
  yr=string(year,format='(I4.4)')
 PATH0='D:\LIDAR_DATA\'+YEAR+'\';

 FILES=''

 read,FILES,prompt='name of the list file: as FILES2004July.txt'
 PATH1='D:\LIDAR_DATA\DATA_LIST\'+FILEs;
 LN1=''


 READ,Nz, PROMPT='INPUT NUMBER OF FILES AS 9 '
 ;NFLS=STRARR(Nz)
 ;Fik=strarr(2,20)
 fls=strarr(Nz)  ; data name
 YNM=INTARR(nz)  ; number of data
 OPENR,1,path1
  LN1=''

 for ns=0,nz-1 do begin

     READF,1,LN1
      PRINT,LN1
       FLS[ns]=strmid(LN1,0,11);  +'ASC'  ;filename
      YNM[ns]=strmid(LN1,20,3) ;file number


;
     endfor ;Ns
   print,FLS,Ynm
 close,1
 ;STOP
h1=15000.0
bn1=fix(h1/dz);
h2=25000.0
bn2=fix(h2/dz);
;;$ PART 2 READ DATA ******************************
   datab=fltarr(2,bnum)
read,n0,prompt='starting file as 9'
   HD='';
   FOR i1=n0,NZ-1 DO BEGIN ; open file to read
      ;fx='D:\LIDAR_DATA\2022\'+FLS[i]+'\a*'
      F2=PATH0+FLS[i1]+'\a*'
      ;fNM=PATH0+FLS[NS]
       Px=file_search(F2)  ; FINDING how many data are there
       nx=n_elements(px);


     AS=FLTARR(NX,BNUM)
     PS=FLTARR(NX,BNUM)

     FOR j0=0,nx-1 do begin
      OPENR,1,Px[j0]
         FOR h=0,5 do begin ;;;read licel first 5 head lines
         readf,1,hd
        ;print,hd
         endfor   ;h
       ;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
     ; AS[J0,*]=datab[1,*];*(ht*1000)^2; PR2
      PS[J0,*]=datab[0,*];*(ht*1000)^2

      close,1
     ENDFOR; J0


 ;
   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    m=fix(NX/2)
    nbin=bn2-bn1+1
    PS1=fltarr(m/2,Nbin) ; parallel

    PS2=fltarr(m/2,Nbin) ;perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     Ps1[J,*]=Ps[k,bn1:bn2]
     bk1=min(PS1[J,nbin-200:nbin-1])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,bn1:bn2]
     bk2=min(PS2[j,Nbin-200:Nbin-1])
     PS2[j,*]=PS2[j,*]-bk2

     J=J+1
    endfor; k


Total_Ps=total(Ps1,1)+total(PS2,1)
z=ht(bn1:bn2)
z1=h1/1000.
z2=h2/1000.
plot,smooth(Total_PS,50),z,color=2,yrange=[z1,z2],title=fls[i1]
;oplot,smooth(total_PS1,40),z,color=90
DATA_path='D:\Lidar_data\2022\OUTPUTS_20km\'
     ;out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"
     out_file=DATA_path+fls[i1]+'_25km.png'

    write_png,out_file,tvrd(/true)
;stop
endfor;I1
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;s1


xx=indgen(Nx)
yy=ht(bn1:bn2);

stop
;;contour_plot
end