Pro Lomb_CWB2020Jan_15

CLOSE,/ALL
ERASE


year='2022'
;FNMD='PT_Jan1_14.txt'
FNMD='CWB_KH_20220115.TXT'
print,'filename: ',FnmD

mon='Jan'
filepath='E:\RSI\Tonga_Volcano\'

 fx=filepath+FNMD;  bpath='G:\0425B\'
    A=read_ascii(fx)
    B=A.(0)
    help,B
   nB=fix(n_elements(B)/3.);.;.;length of B
stop
    ;NX=B[0,*]
    P1=B[2,*]
    T1=B[3,*]
    help,P1,T1

   ; stop
nx=indgen(1440)
plot,nx,P1,color=2,background=-2,yrange=[1010,1025],title='Pressure Jan 15',xtitle='min',ytitle='hPa'
stop
x=transpose(nx)
y=transpose(P1)
;y=y0[i1:i2]
lomb_Sg= LNP_TEST(nx, y,OFAC=16, WK1 = freq, WK2 = ampx, JMAX = jmax)
;lomb_Sg=LNP_TEST(x,y,WK1=wk1,WK2=wk2,JMAX=jmax)

plot,freq,ampx,color=2,background=-2,xrange=[0,0.003],title='Lomb in freq'
Peri=1/freq ; change to Period
;T=1/wk1
;plot,wk1,wk2,color=2,background=-2
 plot,Peri,ampx,xrange=[0,100000],color=2,background=-2,xtitle='Period',ytitle='power',title='Lomb-Scarle '
print,JMAX, Peri(Jmax)  ; index of Peak period
;Lomb_P[j,

stop
end