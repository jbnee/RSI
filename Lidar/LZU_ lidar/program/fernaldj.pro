pro fernaldj, x, alpha_a, beta_a, alpha_r, beta_r, s1, ndata, resol, top, Ze $
              ,init_beta = init_beta, R

s2 = 8 * !pi / 3

beta_a = fltarr(ndata)
alpha_a = fltarr(ndata)
R = fltarr(ndata)


Zeg=uint(Ze*1000.0/75.0-1)
 
beta_a[Zeg] = init_beta
alpha_a[Zeg] = s1 * beta_r[top]
R[Zeg] = 1.0 + beta_a[top] / beta_r[top]

 ;print,'   alpha_a   ','    beta_r   ','   beta_a     ','    Re      ','     s1'
 for i=Zeg,1,-1 do begin

      A = (s1 - s2) * ( beta_r[i - 1] + beta_r[i] ) * resol
      B = X[Zeg] / ( (beta_a[Zeg] + beta_r[Zeg]) )
      C = s1 * ( X[i - 1] *exp( A )+ X[i] )  * resol
      beta_a[i - 1] = X[i - 1] * exp( A ) / (B + C) - beta_r[i - 1]
      

      alpha_a[i - 1] = s1 * beta_a[i - 1] 
      R[i - 1] = 1.0 + beta_a[i - 1] / beta_r[i - 1]
     
    ;print,alpha_a(i),beta_r(i),beta_a(i),R(i)
    
 endfor


return
end

