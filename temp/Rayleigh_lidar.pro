;pro Rayleigh_lidar

path1='d:\RSI\lidar\data\'                      ; 'F:\lidar\teminver\'
path2='d:\rsi\lidar\'

filename1=FILE_SEARCH(path1 +'ja17.txt',count=numfiles1)    ;(path1+'test_ja170115.txt',count=numfiles1)

ind1=file_lines(filename1)
n1 = ind1-1
rawdata=make_array(2,n1,/float)

OPENR,lun,filename1,/get_lun
line=''
readf,lun,line
readf,lun,rawdata
CLOSE,lun &free_lun,lun
s=rawdata[1,*]
smz=smooth(s,20)
rawdata[1,*]=smz

stop
help,rawdata


Tz1   = make_array(1001)
A     = make_array(1001)
B     = make_array(1001)
C     = make_array(1001)

resol  = 24  ;m
Tz2    = -42.5 + 273.15  ;K
Z2     = 30000 ;m
Z2_grid= 1000-1               ; Z2 / resol - 1
g      = 9.8       ;m/s2
M      = 28.9644  ;kg/kmol   air molecules�
R      = 8314    ;J/(K*kmol)  普适气体常数

print,Z2_grid


for i = Z2_grid,624, -1 do begin  ;Z2_grid-10
     A[i - 1] = ( rawdata[0,i]^(2.0)*rawdata[1,i] + rawdata[0,i-1]^(2.0)*rawdata[1,i-1] ) * resol /2.0
endfor

for i = 624, Z2_grid-1 do begin
     B[i]= total(A[i:Z2_grid-1]) * g * M / (R * rawdata[0,i]^(2.0)*rawdata[1,i])

     C[i] = Tz2 * rawdata[0,Z2_grid]^(2.0)*rawdata[1,Z2_grid] / (rawdata[0,i]^(2.0)*rawdata[1,i])
     Tz1[i] = C[i] + B[i] -273.15
      print,B[i],C[i],Tz1[i]
endfor


stop

openw,lun,path2+'T.dat',/get_lun
for i = 624, Z2_grid do begin
    printf,lun,rawdata[0,i],Tz1[i],format='(2f14.6)'
endfor
close,lun &free_lun,lun

;sonddata = make_array(2,71)
;OPENR,lun,path1+'PART_TOO1.txt',/get_lun
;readf,lun,sonddata
;CLOSE,lun &free_lun,lun

;print,sonddata
;TEK_COLOR
;DEVICE,DECOMPOSED=0
;set_plot,'ps'

;!P.charsize=1
;!P.thick=2
;!P.charthick=2
;!X.thick=2     & !Y.thick=2
;device,filename=path2+'T.ps'
      ; plot,rawdata[0,624:Z2_grid],Tz1[624:Z2_grid],yrange=[-100,-40]
      ; oplot,sonddata[0,39:69]/1000.0,sonddata[1,39:69],linestyle=0
;device,/close_file
plot,TZ1,xrange=[600,1000]

print,'finish'
stop
end

