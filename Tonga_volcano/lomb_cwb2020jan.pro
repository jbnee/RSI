Pro Lomb_CWB2020Jan

CLOSE,/ALL
ERASE


year='2022'
FNMD='PT_Jan1_14.txt'
;FNMD='CWB_KH_20220115.TXT'
print,'filename: ',FnmD

mon='Jan'
filepath='E:\RSI\Tonga_Volcano\'

 fx=filepath+FNMD;  bpath='G:\0425B\'
    A=read_ascii(fx)
    B=A.(0)
    help,B
   nB=fix(n_elements(B)/3.);.;.;length of B
stop
    NX=B[0,*]
    P1=B[1,*]
    T1=B[2,*]
    help,P1,T1
!p.multi=[0,1,2]
plot,NX, P1,color=2,background=-2,yrange=[1010,1030],title='Pressure Jan1-14'
    stop
plot,NX,T1,color=2,background=-2,yrange=[15,30],title='Temperature Jan1-14'

stop
x=transpose(nx)
y=transpose(P1)
Tmp=transpose(T1)
;y=y0[i1:i2]
lomb_Sg= LNP_TEST(x, y,OFAC=16, WK1 = freq, WK2 = ampx, JMAX = jmax)
;lomb_Sg=LNP_TEST(x,y,WK1=wk1,WK2=wk2,JMAX=jmax)

plot,freq,ampx,color=2,background=-2,xrange=[0,0.003],title='Lomb in freq'
Peri=1/freq ; change to Period
;T=1/wk1
;plot,wk1,wk2,color=2,background=-2
 plot,Peri,ampx,xrange=[0,100000],color=2,background=-2,xtitle='Period',ytitle='power',title='Lomb-Scarle Pressure'
print,JMAX, Peri(Jmax)  ; index of Peak period
stop  ;

;;;***********Lomb Temperature **********************8
window,1
!p.multi=[0,1,1]
lomb_Sg= LNP_TEST(x,Tmp,OFAC=16, WK1 = freq, WK2 = ampx2, JMAX = jmax2)
plot,Peri,ampx2,color=2,xrange=[0,10000],background=-2,title='Lomb temperature
stop
end