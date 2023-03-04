function read_ASC_file,year,filename;

;A_P=0 for analog 1 for photon
;read,year,prompt='Input year of data as 2019:'
;read,FnmD,PROMPT='NAME OF THE FILE AS 0415ASC: '
FnmD=filename;filename as:'0115 ASC'
;print,'filename: ',FnmD
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
;path='E:\temp\'
mon=''
;path='E:\LiDAR_DATA\'+year+'\ASC\';
 fx=string('D:\Lidar_DATA\'+year+'\'+FNMD+'\a*');;

  ;bpath=path+FNMD;
 print,'filename:  ',fx

 ;fx=''
 ; fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
;stop
    Fno=Sf[1]
    T0=strmid(fls[0],41,5)
    T9=strmid(fls[Fno-1],41,5)
  ; SEARCH files of the day, starting with 0
  JF=0

;da=strmid(fnmd,0,4)

;print,da  ;day of data


    nx=Sf[1]


    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
    Nb=bn2-bn1

    sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)

    Pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]   ; number of files
    ;nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    ;nf2=NF-1
    print,'Number of files,: ',NF
    stop
    Read,nf1,nf2,prompt='starting and ending file nf1, nf2: '
    nf1=fix(nf1);
    nf2=fix(nf2);
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular

    DATAB=FLTARR(2,Nbin)
    ;Ps=fltarr(m,Nbin) ;Ps photon counting signal
    ;PSB=fltarr(m); background
    ;AS0=fltarr(m,Nbin) ;original As  Analog signal
    AS=fltarr(m,Nbin); treated AS signal
    ;BAS=fltarr(m);  AS background
    close,/all
    J=0;nf1-1
    read,ap, prompt='input 0 for analog,1 for counting:'
    a_p=fix(ap)

   FOR IDx=nf1-1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[IDx]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd

        ;print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
      AS[J,*]=datab[a_p,*];*(ht*1000)^2; PR2
      ;BAS[j]=min(AS[J,5500:5999]); background

    close,1
    J=J+1
   ENDFOR; IDx

  return,AS
  end
   ; AS1=fltarr(m/2,Nbin) ;PS1=fltarr(m/2,Nbin) ; parallel
    ;AS2=fltarr(m/2,Nbin) ; perpendicular
   ; i=0;          count file
    ;for k=0,m-2,2 do begin
    ; As1[i,*]=As[k,*] ; parallel signal
    ; As2[i,*]=As[k+1,*] ;perpendicular

   ; i=i+1
   ; endfor;, ; k
;return, AS1;,AS2
;end
