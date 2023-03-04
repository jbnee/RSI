Pro RayleighIterasion
;success_teminversion.pro 中是直接用温度公式进行反演的
;而new_teminversion.pro是按照曹哲章论文第二部分中“（C）密度与温度的计”算来做的

path1='d:\rsi\lidar\data\'
;path2='d:\rsi\lidar\data\'

filename1=FILE_SEARCH(path1+'simu.txt',count=numfiles1)

ind1=file_lines(filename1)
n1 = ind1
rawdata=make_array(2,n1,/float)

OPENR,lun,filename1,/get_lun
readf,lun,rawdata
CLOSE,lun &free_lun,lun

help,rawdata

;------------数据平滑------------------
smooth_data = make_array(2,n1,/float)
smooth_data[0,*] = rawdata[0,*]
smooth_data[1,*] = smooth(rawdata[1,*],60)
help,smooth_data

;------------由探空资料得到起始高度的气压、温度，代入理想气体方程------------使用的资料是D:\IDL\LIDAR\MPL\teminversion\T0001  里面的 1月3日00Z
resol  = 24  ;m
g      = 9.8       ;m/s2
M      = 28.9644 * 10^(-3.0)  ;kg/mol   大气平均分子量
R      = 8.314    ;J/(K*mol)  普适气体常数
K      = 1.38 * 10^(-23.0) ;J/K    波尔兹曼常数


Z1     = 10008. ;15000  m
Z2     = 33984. ; 30000 m
Z1_grid= Z1 / resol - 1
;Z2_grid= Z2 / resol - 1
Z2_grid= (Z2 / resol - 1)-z1_grid
stop
Tz2  = -42.5 + 273.15  ;K
Pz2  = 10.0 * 100      ;mb
Rouc2 = Pz2  / K / Tz2     ;P = nKT (K为波尔兹曼常数)
Rouc2 = Pz2 * 6.02 * 10^(23.0) / R / Tz2    ;起始高度的数密度 单位为：mol/m3
const2 = Rouc2 / smooth_data[1,Z2_grid] / smooth_data[0,Z2_grid]^(2.0)


pi     = 3.1415926
Rouc   = make_array(n1,/float)
beta_r = make_array(n1,/float)
Ta     = make_array(n1,value=1.0,/float)
A      = fltarr(n1)

k = 0
while k ge 0  and k le 3 do  begin

print,k
print,Ta[Z1_grid+500:Z1_grid+510]

;----------得到所求范围内的激光雷达大气密度及后向散射系数---------------
for i = Z1_grid, Z2_grid do begin  ;
    Rouc[i]   = const2 * smooth_data[1,i] * smooth_data[0,i]^(2.0) / Ta[i]
    beta_r[i] = Rouc[i] * 6.226 * 10^(-32.0)
endfor

;----------求大气穿透系数---------

for i = Z2_grid,Z1_grid, -1 do begin
     A[i - 1] = ( beta_r[i] + beta_r[i-1] ) * resol /2.0
     Ta[i - 1]= exp(-2.0 * 8.0 * pi * A[i - 1] / 3.0)
endfor

k = k + 1
endwhile

;print,Rouc[Z1_grid:Z1_grid+10]

;--------将密度代入方程求温度----------
A1      = fltarr(n1)
B1      = fltarr(n1)
C1      = fltarr(n1)
new_Tz1 = fltarr(n1)

for i = Z2_grid,Z1_grid, -1 do begin
     A1[i - 1] = ( Rouc[i] + Rouc[i - 1]  ) * resol /2.0
endfor

for i = Z1_grid, Z2_grid-1 do begin
     B1[i]= total(A1[i:Z2_grid-1]) * g * M / (R * Rouc[i])

     C1[i] = Tz2 * Rouc[Z2_grid] / Rouc[i]
     new_Tz1[i] = C1[i] + B1[i] -273.15
;     PRINT, Rouc[i],a1[i],B1[i],C1[i],new_Tz1[i]
endfor

;------------直接用信号计算温度，没有经过改进----------
Tz1   = make_array(8192)
A     = make_array(8192)
B     = make_array(8192)
C     = make_array(8192)

for i = Z2_grid,Z1_grid, -1 do begin
     A[i - 1] = ( smooth_data[0,i]^(2.0)*smooth_data[1,i] + smooth_data[0,i-1]^(2.0)*smooth_data[1,i-1] ) * resol /2.0
endfor

for i = Z1_grid, Z2_grid-1 do begin
     B[i]= total(A[i:Z2_grid-1]) * g * M / (R * smooth_data[0,i]^(2.0)*smooth_data[1,i])

     C[i] = Tz2 * smooth_data[0,Z2_grid]^(2.0)*smooth_data[1,Z2_grid] / (smooth_data[0,i]^(2.0)*smooth_data[1,i])
     Tz1[i] = C[i] + B[i] -273.15
;      print,B[i],C[i],Tz1[i]
endfor
;stop
;end
;sonddata = make_array(2,71)
;OPENR,lun,path1+'PART_TOO1.txt',/get_lun
;readf,lun,sonddata
;CLOSE,lun &free_lun,lun


set_plot,'ps'

!P.charsize=1
!P.thick=2
!P.charthick=2
!X.thick=2     & !Y.thick=2
device,filename=path1+'simulation.ps'
       ;plot,sonddata[0,39:69]/1000.0,sonddata[1,39:69],linestyle=0,yrange=[-100,-20]
       plot,smooth_data[0,Z1_grid:Z2_grid],Tz1[Z1_grid:Z2_grid],linestyle=1
       oplot,smooth_data[0,Z1_grid:Z2_grid],new_Tz1[Z1_grid:Z2_grid],linestyle=2

device,/close_file

stop
end



