pro THORP_LENGTH



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;Radiosonde data plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnm='cwb20010117.txt'
 ;read,dnm,prompt='Input filename: '
;fname2='f:\radiosonde\test\'+dnm+'.txt'; rsi\cirrus\';   ;35data.txt'
path2='f:\RSI\lidar\rayleigh_data\'
f2=path2+dnm

close,/all
openr,1,f2
line=''
for L=0,4 do begin
readf,1,line
print,line
endfor
Q=readf,1 ,
;X=read_ascii(f2)

s=size(Q)
A1=s[1]  ;column #
A2=s[2];   A[2]   ;row #
Q=Q[*,4:A2-1]
A3=A2-4
;;;;remove bins-1
A1=s[1]  ;column #
A2=s[2];   A[2]   ;row #
;;;;remove bins-1
 For i=0,A1-1  do begin; ith column
   For j=0,A2-1 do begin  ;jth raw
   ; A[j,i]=Q[j,i]
     if (Q[i,j] eq 999.9) then Q[i,j]=(Q[i,j-1]);+Q[i,j-2])/2
         ;if (Q[i,j] eq 999.) then Q[i,j]=(Q[i,j-1]+Q[i,j-2])/2
   endfor   ;j
endfor ;i
Ht1=Q[3,*]/1000
;P=Q[2,*]
T1=Q[4,*]
;RH=Q[5,*]
;WD=Q[7,*]

 plot,T1,HT1,color=2,background=-2,yrange=[0,30],title='CWB',position=PL2
T2=sort(T1)
oplot,T2,HT1,color=100


stop

end




