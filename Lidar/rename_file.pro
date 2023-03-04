pro rename_file
 fpath=''
 kpath=''
 dnm=''
 read,fpath,prompt='file path as c:\test\';
 read,kpath,prompt='new path as c:\test\new';
 read,dnm,prompt='data filename as mr022018'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
 knm=kpath+dnm+'.'
read,ni,nf, prompt='Initial and file number as 1,20: '
read,ki,kf,prompt='change to file number as 41,60';
  nx=nf-ni+1
  j=0

 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
   sk=strtrim(fix(ki-1+n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'M'
   kn1=knm+strtrim(sk,2)+'M

   fn2=fnm+strtrim(sn,2)+'D'
   kn2=knm+strtrim(sk,2)+'D'

  file_copy,fn1,kn1
  file_copy,fn2,kn2

ENDFOR
stop
end