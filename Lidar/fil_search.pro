pro fil_search
;search lidar files and numbers
;enter month below

mm=''
read,mm,prompt='Month as ap: '

Path1='F:\lidar_data\2007\'+mm+'\t*'

rs = FILE_SEARCH(Path1)

s=size(rs)
Lfile=strarr(2,100)
TF=1
; input k0 here using last run for first time k0=0
k=0
n=0
 k0=k
jump1: k=k0
  while (TF eq 1) do begin
   f1=strmid(rs[k],31,8)
     if (k+1 eq s[1]) then begin
          f2=f1
          goto,Jump2
    endif else begin

   f2=strmid(rs[k+1],31,8)
   endelse
   TF = STRCMP( f1, f2)
   k=k+1
 endwhile
 Jump2: print,'end search'
 print,k,'=',f1
  print,k+1,'= ',f2
  print,'file name: ',f1,'number of files: ',(k)/2
  ;Lfile=MAKE_ARRAY(k,f1,'string)
  m=k
  Lfile[1,n]=(m-k0)/2
  Lfile[0,n]=f1
  n=n+1
  k0=k
  TF=1
;endwhile
goto, jump1
stop
end

