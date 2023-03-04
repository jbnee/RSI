 pro DataCredibility, rawdata, resol, Cred

;*input*
;rawdata=lidar raw return
;Cred=below the Credible grid is the usefull lidar data 
;IDL子程序不能将外部程序中定义过的要用到子程序中的量再定义一遍，e.g.rawdata
;判断连续三个间隔小于0，i=0,266,所以一旦判断出来即停止，要不新算出来的值会覆盖以前的值

Cred=make_array(1440,/float)

HEIGHT=MAKE_ARRAY(800,/FLOAT) 
 
for i=0L,799L do begin
     HEIGHT[i]=(resol*(i+1))/1000.0         
endfor 

if resol eq 75.0 then begin
for j=0,1439 do begin
     for i=0,200 do begin 
          if (rawdata[j,i] lt 0.0) and (rawdata[j,i+1] lt 0.0) and (rawdata[j,i+2] lt 0.0) then break
             Cred(j)=(i+1)*resol/1000.0   
     endfor
endfor
endif else begin
for j=1,1440 do begin
     for i=0,200 do begin 
          if (rawdata[j,i] lt 0.0) and (rawdata[j,i+1] lt 0.0) and (rawdata[j,i+2] lt 0.0) then break
             Cred(j-1)=(i+1)*resol/1000.0   
     endfor
endfor
endelse

return
end