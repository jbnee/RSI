Pro auto_search_ASC
; program to search filename and size of ASC data
xpath='D:\Lidar_data\2022\*'  ; assign month
f_list=file_search(xpath)
nf=size(f_list)
;s=strarr(nf[1])
;sf=strarr(nf[1])
;A=intarr(nf[1])
;k=0  ;file indicator
;n=0  ;sub-file indicator
;m=0  ;file counter
;s(k)=strmid(f[k],22,8)
print,nf
stop
FOR  i=0,nf[1]-1 do begin
  fName=strmid(f_list[i],19,12)    ;reference file is the first file

  fx= f_list[i]+'\a*'
  Nx=file_search(fx)
  Sz=size(Nx)
   print,fname,Sz[1]
endfor
stop

AM_files=strmid(f_list[23:69:2],19,11)
PM_files=strmid(f_list[24:69,2],19,11)
stop
end


