Pro Thorpe_scale
 ; doing Thorpe analysis for cwb temperature data
; In the first part we will read data and sort data;
;  next arrage in descending order upto tropopause
 loadct,5
 device,decomposed=0
;!P.MULTI = [0,2,1]
   ;PL1 = [0.1,0.15,0.45,0.95];
  ; PL2 = [0.6,0.15,0.98,0.95];
fnm='cwb20010117.txt'
f1='F:\RSI\lidar\Rayleigh_data\'+fnm;cwb20010117.txt'
Q0=read_ascii(F1)
Qx=Q0.(0)

SQ=SIZE(Qx)
A1=SQ[1] ;COL
A2=SQ[2]  ;:RAW
Q1=QX[*,5:A2-1]  ;remove head lines
STOP
;;;;;remove 999 data by assign it to previous data
 For i=0,A1-1  do begin; ith column
   For j=0,A2-6 do begin  ;jth raw
   ; A[j,i]=Q[j,i]
     if (Q1[i,j] eq 999.9) then Q1[i,j]=(Q1[i,j-1]);

   endfor   ;j
endforvvvvvv ;i
z1=Q1[3,*]
T1=Q1[4,*]
plot,T1,z1/1000,yrange=[0,30],color=2,background=-2, title=fnm
stop
m1=min(T1)
N1=where(T1 eq m1)
print,N1
stop
s2=sort(T1[0:n1]);sort upto tropopause
T2=T1(s2)

T3=REVERSE(T2)  ;for descending order

OPLOT,T3,Z1/1000,COLOR=50
stop
A1=[Z1,T1[0:m1]]
A3=[Z1,T3]
DA=[A3-A1]
m2=where(DA[1,*] gt 0)
m3=where(DA[1,*] lt 0)
m=[m2,m3]
print,m
stop
end
