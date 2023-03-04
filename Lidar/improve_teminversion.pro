pro improve_teminversion


path1='F:\lidar\teminver\'
path2='F:\lidar\teminver\'

filename1=FILE_SEARCH(path1+'test_ja170115.txt',count=numfiles1)

ind1=file_lines(filename1)
n1 = ind1
rawdata=make_array(2,n1,/float)

OPENR,lun,filename1,/get_lun
readf,lun,rawdata
CLOSE,lun &free_lun,lun

resol  = 24  ;m
B1     = 70000
B2     = 120000 ;m
B1_grid= B1 / resol - 1
B2_grid= B2 / resol - 1
Back_return = mean(rawdata[1,B1_grid:B1_grid])
print,Back_return

no_back_rawdata = make_array(2,n1,/float)
no_back_rawdata[0,*] = rawdata[0,*]
for i = 0, n1[0]-1 do begin
    no_back_rawdata[1,i] = rawdata[1,i] - Back_return
endfor


smooth_data = make_array(2,n1,/float)
smooth_data[0,*] = no_back_rawdata[0,*]
smooth_data[1,*] = smooth(no_back_rawdata[1,*],40)
help,smooth_data
set_plot,'ps'

!P.charsize=1
!P.thick=2
!P.charthick=2
!X.thick=2     & !Y.thick=2
device,filename=path2+'smooth_data.ps'
       ;plot,rawdata[1,0:1249],rawdata[0,0:1249],psym=-1;,xrange=[-10,100]
       plot,smooth_data[1,0:2499],smooth_data[0,0:2499];,xrange=[-10,100]
device,/close_file
openw,lun,path2+'smooth_data.dat',/get_lun
for i = 0, n1[0]-1 do begin
    ;printf,lun,smooth_data[0,i],smooth_data[1,i],format='(2f14.6)'
endfor
close,lun &free_lun,lun



;----------改善前----------
Tz1   = make_array(8192)
A     = make_array(8192)
B     = make_array(8192)
C     = make_array(8192)


Tz2    = -45.15 + 273.15  ;K
g      = 9.8       ;m/s2
M      = 28.9644  ;kg/kmol   大气平均分子量
R      = 8314    ;J/(K*kmol)  普适气体常数

resol  = 24  ;m
Z1     = 15000 ;m
Z2     = 30000 ;m
Z1_grid= Z1 / resol - 1
Z2_grid= Z2 / resol - 1

for i = Z2_grid,Z1_grid, -1 do begin  ;Z2_grid-10
     A[i - 1] = ( smooth_data[0,i]^(2.0)*smooth_data[1,i] + smooth_data[0,i-1]^(2.0)*smooth_data[1,i-1] ) * resol /2.0
endfor

for i = Z1_grid, Z2_grid-1 do begin
     B[i]= total(A[i:Z2_grid-1]) * g * M / (R * smooth_data[0,i]^(2.0)*smooth_data[1,i])

     C[i] = Tz2 * smooth_data[0,Z2_grid]^(2.0)*smooth_data[1,Z2_grid] / (smooth_data[0,i]^(2.0)*smooth_data[1,i])
     Tz1[i] = C[i] + B[i] -273.15
;      print,B[i],C[i],Tz1[i]
endfor

;-------------改善后--------------
imp_Tz1 = make_array(8192)
Ta      = make_array(8192,value=1.0,/float)
Rou     = make_array(8192)
Beta_a  = make_array(8192)
D       = make_array(8192)
A1      = make_array(8192)
B1      = make_array(8192)
C1      = make_array(8192)

Rou2    = 0.2615 * 10^(25.0)
pi      = 3.1415926

for k = 0,1 do begin
;    print,Ta[Z1_grid:Z2_grid]
    for i = Z2_grid-1 ,Z1_grid, -1 do begin
        Rou[ i ] = Rou2 * Tz2 * smooth_data[1,i]* smooth_data[1,i]^(2.0) / (smooth_data[1,Z2_grid] * smooth_data[1,Z2_grid]^(2.0) * Ta[ i ])
        Beta_a[ i ] =  Rou[ i ] * 6.226 * 10^(-32.0)
;        print, Rou[ i ], Beta_a[ i ]
    endfor
    for i = Z2_grid,Z1_grid,-1 do begin
         D[ i - 1 ] =  (Beta_a[ i ] +  Beta_a[ i - 1]) * resol / 2.0
         Ta[ i - 1 ] = exp(-2.0 * 8.0 * pi * D[ i - 1 ] / 3.0 )
;         print,D[ i - 1 ],-2.0 * 8.0 * pi * D[ i - 1 ] / 3.0,Ta[ i - 1 ]
    endfor
endfor

;print,Rou[Z1_grid:Z2_grid]

for i = Z2_grid,Z1_grid, -1 do begin  ;Z2_grid-10
     A1[i - 1] = ( Rou[ i ] + Rou[i-1]) * resol /2.0
endfor

for i = Z1_grid, Z2_grid-1 do begin
     B1[i]= total(A1[i:Z2_grid-1]) * g * M / (R * Rou[ i ])
     C1[i] = Tz2 * Rou2 / Rou[ i ]
     imp_Tz1[i] = C1[i] + B1[i] -273.15
      print,B1[i], Tz2,Rou2,Rou[ i ],C1[i],imp_Tz1[i]
endfor





openw,lun,path2+'T.dat',/get_lun
for i = Z1_grid, Z2_grid do begin
    printf,lun,smooth_data[0,i],Tz1[i],format='(2f14.6)'
endfor
close,lun &free_lun,lun

sonddata = make_array(2,71)
OPENR,lun,path1+'PART_TOO1.txt',/get_lun
readf,lun,sonddata
CLOSE,lun &free_lun,lun

;print,sonddata

set_plot,'ps'

!P.charsize=1
!P.thick=2
!P.charthick=2
!X.thick=2     & !Y.thick=2
device,filename=path2+'improve_T.ps'

;       plot,sonddata[0,39:69]/1000.0,sonddata[1,39:69],linestyle=0,yrange=[-100,-40]
;       oplot,smooth_data[0,Z1_grid:Z2_grid],Tz1[Z1_grid:Z2_grid],linestyle=1
       plot,smooth_data[0,Z1_grid:Z2_grid],imp_Tz1[Z1_grid:Z2_grid],linestyle=2
device,/close_file



end

