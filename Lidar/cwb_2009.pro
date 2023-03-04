pro CWB_2009
;search CWB 2009 and separate into monthly files T0901 etc


;read,mm,prompt='Month as ap: '
close,/all
Path1='F:\radiosonde\2009\cwb2009.txt'

;rs = FILE_SEARCH(Path1)

A=''
OPENR,1,Path1
READF,1, A
CLOSE,1
print,A

i=0
  line=''
  array=''
  OPENR, lun, path1, /GET_LUN
  WHILE (i lt 99) do BEGIN ;& $
  READF, lun, line ;& $
  ;WHILE (LINE NE A) DO BEGIN
  array = [array, line] ;& $
  i=i+1
  print,line
  if (array[i] eq array[1]) then begin
  k=i


  endif

  ENDWHILE

 free_lun,lun
;print,array
 print,'last line',k
 head1=array[20:22]
 head2=array[6:19]
 x=strarr(k-23)
 j=0
 for i=24,k-1 do begin
 x[j]=array[i]  ; x is the radiosonde data array
 j=j+1
 endfor
 B1=strarr(20,2)
 B1[0:2,0]=head1
 B1[0:13,1]=head2
 Y=strarr(k-24,1)
 for i=0,k-25 do begin
 Y[i]=strmid(array(24+i),0,45)
 endfor
stop
  y=transpose(y)


end

