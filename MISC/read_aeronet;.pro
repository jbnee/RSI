PRO READ_aeronet; read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
close,/all

fname='d:\aeronet\NCU2009AOT2_0.txt' ;NCUAOT500_1020.txt';  \rsi\cirrus 08_12Ht.txt'
;ª`·N: N/A in data must be delted
OPENR,1,fname
line=''
cols=8;5
rows=2000
readf,1,line
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=2000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line
G1=FLTARR(8,1500)

ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter
j=0
k=0
WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H
      A1=H[4,n]
    if (A1 LT 0.5) then begin
    G1[0,j]=H[0,n]
    G1[1,j]=H[4,n]
    j=j+1
    endif

    if  (A1 GT 0.5) then begin
    G1[2,k]=H[0,n]
    G1[3,k]=H[4,n]
    k=k+1
    endif
    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
;A500=strcompress(H[0,*])
;mn=strmid(mnths,5,2)

JDay=H[0,*]
A1020=H[1,*]
A870=H[2,*]
A675=H[3,*]
A500=H[4,*]
A440=H[5,*]
A380=H[6,*]
A340=H[7,*]
;stop

;;sum over winter months
 AE=A500/A1020
  Alpha1=-alog(A500/A870)/(alog(500./870.))
 Alpha2=-alog(A500/A1020)/(alog(500./1020.))

 plot,A500,alpha1,psym=2,background=-2,color=2,xtitle='AOD 500', ytitle='AE500_870_1020'
 stop
 oplot,A500,alpha2,psym=4,COLOR=6
 stop

 ;WRITE_bmp,'D:\Aeronet\AE_vs_AOD2009all.bmp',tvrd()


close,1
END