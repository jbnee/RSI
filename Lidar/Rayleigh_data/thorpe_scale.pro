Pro Thorpe_scale
 ; doing Thorpe analysis for cwb temperature data
; In the first part we will read data and sort data;
;  next arrage in descending order upto tropopause
 loadct,5

;!P.MULTI = [0,2,1]
   ;PL1 = [0.1,0.15,0.45,0.95];
  ; PL2 = [0.6,0.15,0.98,0.95];
CLOSE,/ALL
;fnm='cwb20010117.txt'
fnm='HCWB20090712B.txt'
path1='F:\RSI\lidar\Rayleigh_data\';'fnm;cwb20010117.txt'
F1=path1+fnm
line=''
;D=fltarr(9)
;A=fltarr(9,70)
QX=fltarr(8,600)

Q0=read_ascii(F1)
Qx=Q0.(0)

SQ=SIZE(Qx)
A1=SQ[1] ;COL
A2=SQ[2]  ;:RAW
Q1=QX[*,5:A2-1]  ;remove head lines
;Temperatue=Qx[2,*]
;Ht=Qx[4,x]
STOP
;;;;;remove 999 data by assign it to previous data
 For i=0,A1-1  do begin; ith column
   For j=0,A2-6 do begin  ;jth raw
   ; A[j,i]=Q[j,i]
    ; if (Q1[i,j] eq 999.9) then Q1[i,j]=Q1[i,j-1];+Q1[i,j+1])/2.;
     if (Q1[i,j] eq 999.9) then Q1[i,j]=Q1[i,j-1]-(Q1[3,j]-Q1[5,j-1])*(6.5/1000.)

   endfor   ;j
endfor  ;i
z1=Q1[4,*]
T1=Q1[2,*]
plot,T1,z1/1000,yrange=[0,30],color=2,background=-2, title=fnm
stop
;;;;;;LOCATE TROPOPAUSE;;;;;;;;;;;;;;;;;;;
m1=min(T1)
N1=where(T1 eq m1)
print,N1
stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s2=sort(T1[0:n1[0]]);sort T BELOW tropopause
XT2=T1(s2)

T3=REVERSE(xT2)  ;for descending order

OPLOT,T3,Z1/1000,COLOR=50,psym=4
stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

n10=n1[0]
Z10=Z1[0:n10]

DT=T3-T1
m2=where(DT gt 0)
m3=where(DT lt 0)

print,m2,m3
H3A=T3[M2]
Z3A=Z10[m2]
H3B=T3[M3]
Z3B=Z10[m3]
PRINT,'T3 temperature of m2: ',H3A
print,' height of m2: ',Z3A;

PRINT,'T3 temperature of m3: ',H3B
print,'Height of m3: ',Z3B

N2=n_elements(m2)
N3=n_elements(m3);

Thorp1=fltarr(N2+1)
For Ip=0,N2-1 do begin  ;;for m2 position

  m1A=where(T1 eq H3A[Ip]) ;;  Height in T3
  Z1A=Z10[m1A]   ;;  Height in T1

  DZA= Z1A -Z3A[IP]             ;;difference
print,ip,'m1A,z(T3), z(T1), DZA',m1a,z1A,DZA
Thorp1[Ip]=DZA
endfor
Thorp2=fltarr(N3+5)
 For Iq=0,N3-1 do begin   ;;for m3 position
  m1B=where (T1 eq H3B[Iq])   ;;Height in T3
  Z1B=Z10[m1B]    ;;Height in T1
  DZB= Z1B-Z3B[Iq]              ;;difference
print,iq,' M1B,Z1B,DZB  ',M1B,Z1B,DZB
Thorp2[Iq]=DZB
endfor

stop
print,'Mean values:',mean(thorp1),mean(thorp2)
plot,thorp1,color=2,background=-2,yrange=[-1000,1000],title=fnm,ytitle='Thorp scale'
oplot,thorp2,color=2,psym=2
stop
F2=path1+'ThorpScale,bmp'
write_bmp,F2,tvrd()
end
