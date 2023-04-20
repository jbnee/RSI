Pro auto_list_files
; serch number of data files in a month
xpath='D:\Lidar_data\2009\AU\au*'
f=file_search(xpath)
nf=size(f)
s=strarr(100)  ;max file is 100
s[0]=strmid(f[0],22,8)
stop
sf=strarr(100)
A=intarr(100); file size 200
k=0  ;file indicator
n=0  ;sub-file indicator
m=0  ;file counter

XFile=strarr(2,100)
FOR  i=0,nf[1]-1 do begin
  s0=strmid(f[k],22,8)    ;reference file is the first file
  x=strmid(f[i],22,8)
  m=m+1
   Result = STRMATCH(x, s0)  ;file compared

  if (Result eq 0) then begin  ;if different file
     print,x,'result= ',result,m
     xfile[0,n]=X
     xfile[1,n]=m
     sf[n]=x                   ;list file
     A[n]=m/2
      n=n+1                    ; next file
      k=i                      ;change reference
      m=0                      ;reset counter

  endif
  endfor; i
  stop
  A[n]=(m+1)/2
; XF=Make_Array(2,n+2,/string,type=7)
 ;XF[0,*]=[s[0],SF[0:11]]
 ;XF[1,*]=A[0:12]
print,xfile
stop
;outfiles=bapth
;openw,2,outfiles
;printf,2,Xfile
;close,2



end


