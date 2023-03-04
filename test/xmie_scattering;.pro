Pro XMie_scattering; Mie scattering cross section
;based on Mie Program Mieplot4503
addx='D:\Light Scattering\MiePlot4503\'
;XMIE='XMie532_10um_water.txt'
;XMIE='XMie550_2um_water.txt'
X550='XMie550_2um_water.txt'
cols=4
rows=20
;filex='D:\Light  Scattering\MiePlot4503\XMie550_2um_water.txt'
filex=addx+X550

openr,1,filex
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=1000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line

ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter
WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H
    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
stop
XS=fltarr(2,rows); cross section
Theta=H[0,*]
Y=size(H)
N=Y[2]   ;number of angles
XS=fltarr(N)
theta=H[0,*]
wavel=0.550E-6
for m=0,N-1 do begin

XS[m]=H[1,m]*(wavel^2/(4*3.14^2))*10000 ;
endfor

plot,Theta,Alog10(XS),background=-2,color=1,psym=2,xtitle='degree',ytitle='log10(Cross Sec)'
;openw,2,adds+',MIEXS.txt'
print,theta,XS
;close,2
stop
END

