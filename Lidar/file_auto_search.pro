Pro file_auto_search
year=''
read,year,prompt='year of data: '
mon=''
read,mon,prompt='month of data as fe:  '
f2=year+'\'+mon+'\'+mon+'*'
bpath='f:\lidar_data\'
xpath=bpath+f2
;stop
;bpath='f:\Lidar_data\2003\fe\fe*'  ; assign month
f=file_search(xpath)
nf=size(f)
s=strarr(nf[1])
sf=strarr(nf[1])
A=intarr(nf[1])
k=0  ;file indicator
n=0  ;sub-file indicator
m=0  ;file counter
s(k)=strmid(f[k],22,8)

FOR  i=0,nf[1]-1 do begin
  s0=strmid(f[k],22,8)    ;reference file is the first file
  x=strmid(f[i],22,8)
  m=m+1
   Result = STRMATCH(x, s0)  ;file compared

  if (Result eq 0) then begin  ;if different file
     print,x,'result= ',result,m
     sf[n]=x                   ;list file
     A[n]=m/2
      n=n+1                    ; next file
      k=i                      ;change reference
      m=0                      ;reset counter

  endif
  endfor
  A[n]=(m+1)/2
 XF=Make_Array(2,n+1,/string,type=7)
 XF[0,*]=[s[0],SF[0:n-1]]
 XF[1,*]=A[0:n]

;stop
f2='
outfile=bpath+'\'+year+'\'+'filelist\'+year+'_'+mon+'_list.txt'
openw,1,outfile
printf,1,XF
close,1
stop

end


