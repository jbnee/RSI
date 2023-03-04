pro fil_rename


Path1='f:\Radiosonde\2010\T2010*'; +'T201012g_20101211_00z*'
path2='f:\Radiosonde\2010\C\'

RS = FILE_SEARCH(Path1)

s=size(RS)
L=s[1]

for i=0,L  do begin
  f1=RS[i]
  N1=strmid(f1,21,18)
  f2=path2+N1+'.txt' ; define a new file name
  file_move,f1,f2

endfor
stop
end