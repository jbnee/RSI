pro aerosolandcloud
;将标高选在20km处，对卷云反演，看对结果有没有大的影响


 path1='F:\data\LIDAR\allmpl\' & filename1='20070607'
 path2='D:\IDL\LIDAR\MPL\data\e.g\' & filename2='\200706\20070607\'
 
rawdata=make_array(1440,800,/float) 
openr,lun,path1+filename1+'.dat',/get_lun
readf,lun,rawdata
close,lun & free_lun,lun
alpha_r=make_array(1,300,/float)
openr,lun,'D:\IDL\LIDAR\MPL\extinction coefficient of 20km molecules.txt',/get_lun
readf,lun,alpha_r
close,lun & free_lun,lun
beta_r=make_array(1,300,/float)
openr,lun,'D:\IDL\LIDAR\MPL\backscattering coefficient of 20km molecules.txt',/get_lun
readf,lun, beta_r
close,lun & free_lun,lun









;determine the height grid which below grid is valid   
 DataCredibility,rawdata,75,Cred


;determine the height of cloud base and top
 num='1st'& time1=1215 & time2=1215 & samint=10 & range1=9 & range2=11.5
 
 cloudheight,rawdata,num,time1,time2,samint,range1,range2,Cred,75,Zb,Zc,Zt,GTc,path2,filename2
 


LR=make_array(1440,/float) 
sigma1=make_array(1440,300,/float)
beta1=make_array(1440,300,/float)    
Re=make_array(1440,300,/float)
CODfer=make_array(1440,/float)
Terr=make_array(1440,/float)
Tfer=make_array(1440,/float) 
sigmaAVE=make_array(1440,/float)
eta=make_array(1440,/float)

print,'----------------------------------------single-backscatter--------------------------------------------'
OPENW,lun,path2+'backscatter.txt',/get_lun 
;       printf,lun,'Time','Zb','Zt','Zc','GTc','Sc','sigmaAVE','CODfit','CODfer','Tfit','Tfer','Terr','dtmax','range1','range2','elevation',format='(a4,15a10)'

  
   for j=time1,time2,samint do begin
    
               fitting, rawdata, Zb, Zt, num, time1, time2, samint, Tfit, CODfit,  Xfit, rt, 75, path2, filename2,dtmax
               ;elevation,rawdata(j,*), beta_r(0,*), Cred(j), 75.0, Ze
               
;        if Zt[j] ge 10.0 then  Zelim=Zt[j]  
;        if Zt[j] lt 10.0 then  Zelim=10.0   
         Ze = 15
         for i=Ze*10,Ze*10,-1 do begin   
               k = 5
               Ze = i/10
              while (k le 70) do begin
                 
                         top=uint((Zt(j))*1000.0/75.0-1) & resol=0.075 & ndata=300 & init_beta=beta_r(top)
               fernaldj, rawdata(j,*), alpha_a, beta_a, alpha_r, beta_r, k, ndata, resol, top, Ze $
                       ,init_beta = init_beta, R
                       
                         sigma1(j,*)=alpha_a
                         beta1(j,*)=beta_a 
                         Re(j,*)=R 
                         
               sinpson, sigma1(j,*), Zb(j), Zt(j), S, AVE, resol
                         sigmaAVE(j)=AVE
                         CODfer(j)=S
                         Tfer(j)=exp(-CODfer(j))
                         Terr(j)=ABS(Tfer(j)-Tfit(j))
  
                if (Terr(j) lt 0.001) then break
                if (Terr(j) ge 0.001) then k=k+0.01 
                
              endwhile 
              
                   print,'    time','          S','         sigmaAVE','      CODfit','       CODfer','          Tfit','        Tfer','       Terr   ','      dtmax','     elevation'
                   print,j,k,sigmaAVE(j),CODfit(j),CODfer(j),Tfit(j),Tfer(j),Terr(j),dtmax,Ze
                   printf,lun,j,Zb(j),Zt(j),Zc(j),GTc(j),k,sigmaAVE(j),CODfit(j),CODfer(j),Tfit(j),Tfer(j),Terr(j),dtmax,range1,range2,Ze,format='(i4,4f10.3,11f10.6)'    
         endfor                    

         betaratio, Re, sigma1, beta1, num, time1, time2, samint, path2, filename2    
               
   endfor
CLOSE,lun & free_lun,lun                       
end