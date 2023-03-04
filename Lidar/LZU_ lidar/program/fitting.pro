pro fitting, rawdata, Zb, Zt, num, time1, time2, samint, Tfit, CODfit,  Xfit, rt, resol, path1, filename1,dtmax

;***input***
;result1=云顶以上一段距离最小二乘法拟合曲线的系数的结果
;result2=云底以下一段距离最小二乘法拟合曲线的系数的结果
;yt=云顶以上一段距离拟合曲线所得到回波信号值
;yb=云底以下一段距离拟合曲线所得回波信号的拟合值
;crt=云顶以上这段距离拟合曲线得到的回波信号与原来的回波信号的相关系数
;crb=云底以下这段距离拟合曲线得到的回波信号与原来的回波信号的相关系数
;PZt=得到最优拟合曲线之后将云顶高度代入拟合曲线得到的云顶处回波信号
;PZb=得到最优拟合曲线之后将云底高度代入拟合曲线得到的云底处回波信号  
;Tfit=云的透过率
;CODfit=云的光学厚度
;Xfit=云顶以上拟合得到的回波信号（本来想用来选取标高时提供一个更好的回波信号，但是不好用）

result1=make_array(2,/float)
result2=make_array(2,/float)
Xfit=make_array(500,/float)
yt=make_array(500,/float)
yb=make_array(500,/float)
crt=make_array(21,/float)
crb=make_array(21,/float)
PZt=make_array(1440,/float)
PZb=make_array(1440,/float)   
Tfit=make_array(1440,/float) 
CODfit=make_array(1440,/float)

HEIGHT=MAKE_ARRAY(800,/FLOAT)
   for i=0L,799L do begin
       HEIGHT[i]=(resol*(i+1))/1000.0         
   endfor
   
   
   for j=time1,time2,samint do begin
        ht = uint(Zt(j) * 1000.0 / resol-1.0)                   
        hb = uint(Zb(j) * 1000.0 / resol-1.0)
        
        
        for k=3,20,1 do begin
            dt=k*0.1
            db=k*0.1
            dtfit=uint(dt*1000.0/75.0-1.0)
            dbfit=uint(db*1000.0/75.0-1.0)
            rt=ht+dtfit                                     
            rb=hb-dbfit
            
            result1=LINFIT(height(ht:rt),rawdata(j,ht:rt))
            result2=LINFIT(height(rb:hb),rawdata(j,rb:hb))
            ;print,k
          for i=ht,rt do begin
               yt[i]=result1[0]+result1[1]*height[i]
          endfor 
           
               At=total((yt[ht:rt]-mean(yt[ht:rt]))*(rawdata[j,ht:rt]-mean(rawdata[j,ht:rt])))
               Bt=sqrt(total((yt[ht:rt]-mean(yt[ht:rt]))^2))*sqrt(total((rawdata[j,ht:rt]-mean(rawdata[j,ht:rt]))^2)) 
              ; print,AT,BT,At/Bt
               crt[k]=At/Bt 
          for i=rb,hb do begin
               yb[i]=result2[0]+result2[1]*height[i]
          endfor
               Ab=total((yb[rb:hb]-mean(yb[rb:hb]))*(rawdata[j,rb:hb]-mean(rawdata[j,rb:hb])))
               Bb=sqrt(total((yb[rb:hb]-mean(yb[rb:hb]))^2))*sqrt(total((rawdata[j,rb:hb]-mean(rawdata[j,rb:hb]))^2))
               crb[k]=Ab/Bb
               ;print,Ab,Bb,Ab/Bb
        endfor
        
        crtmax=crt[10]
        crbmax=crb[10]
          for k=10,15,1 do begin
             if (crt[k] gt crtmax) then begin
                 crtmax=crt[k] 
                 dtmax=k*0.1
             endif
             if (crb[k] gt crbmax) then begin
                 crbmax=crb[k]
                 dbmax=k*0.1
             endif
          endfor
         ;print, 'dtmax',dtmax,'dbmax',dbmax
;        
       rt = ht + uint(dtmax * 1000.0 / resol - 1.0)                                     
        rb = hb - uint(dtmax * 1000.0 / resol - 1.0)
         
        result1 = LINFIT(height(ht:rt),rawdata(j,ht:rt))
        result2 = LINFIT(height(rb:hb),rawdata(j,rb:hb))
        
        PZt(j) = result1[0] + result1[1] * Zt(j)
        PZb(j) = result2[0] + result2[1] * Zb(j) 
               
        Tfit(j) = sqrt(PZt(j) / PZb(j))
        CODfit(j) = - alog(Tfit(j))
        

   endfor
   
 ;若画图验证云顶云底无误，则输入到文件中
    set_plot,'ps'

               !P.charsize=1.2
               !P.thick=3
               !P.charthick=3
               !X.thick=3     & !Y.thick=3
          for j=time1,time2,samint do begin

               device,filename=path1+filename1+strmid(strtrim(string(j),2),0,4)+'fitting.ps'
                      plot,rawdata(j,*),height,ystyle=1,yrange=[0,16],yticks=8,$
                            ytickname=['0','2','4','6','8','10','12','14','16'],xstyle=1,xrange=[-0.5,1],xticks=3,$
                            xtickname=['-0.5','0','0.5','1'],$
                            xtitle='signal P(z)Z!U2!N(arb. units)',ytitle='Altitude Z (km)';,/ ylog
                      oplot,result1[0]+result1[1]*height,height,linestyle=4
                      oplot,result2[0]+result2[1]*height,height;,linestyle=2
               device,/close_file
          endfor
  
;   openw,lun,path1+filename1+num+'fitting.txt',/get_lun
;          for j=time1,time2,samint do begin
;              printf,lun,j,Tfit(j),CODfit(j),format='(2f10.6)'
;          endfor
;   free_lun,lun

end