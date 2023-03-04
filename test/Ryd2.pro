Pro Ryd2
close,/all
;IE1=17.31  ; 'IE for N2+(A)
IE1=18.07
;IE3=19.41
L=7
n=fltarr(L)
EG=fltarr(L)
wv=fltarr(L)
m=fltarr(L)
d=fltarr(L)
data=fltarr(L)
dfc=fltarr(L,L)
file='H:\RSI\VUV\CO2IEBS.txt'
;data=read_ascii(file)
openr,1,file
;WHILE ~ EOF(1) DO BEGIN
 ;line=''
readf,1,data
    A=data
  ;print,A, y
  Eg = 1239.8 / A   ;convert to eV
  AK = 1E+08 / A     ;wavenumber

  ;D = N - SQRT(109737. / (IK1 - AK))

  ;close,1
;IE=IE1
;IE=IE2
;if EG(i)>IE1 then IE=IE2
For J=0, L-1 do begin
IE=IE1-0.05*j
For I=0, L-1 do begin
n(I)=sqrt(13.6/(IE-EG(i)))
d(I)=n(i)-floor(n(i))
r=floor(n(i))
m(I)=n(i) mod r

print,J,IE, EG(i),1239.8/eg(i),n(i),d(i),m(i)
plot,n,d,psym=7 ,background=-2, color=2,yRANGE=[0.2,1.2],xRANGE=[0,10],xtitle='principle n',ytitle='defect',TITLE='IE'
dfc(j,*)=d
print,dfc(j,*)
stop
endfor

oplot,n,d,psym=J
endfor ;J
;write_bmp,'h:\rsi\vuv\RydCO2C1.bmp',tvrd()
stop
end