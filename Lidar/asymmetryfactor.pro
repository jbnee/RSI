Pro AsymmetryFactor

a=0.01
tau=0.1
;R=sqrt(3)*(1-g)*tau/(2+sqrt(3)*(1-g)*tau)
;print,R
;stop

;read,tauX, prompt='input optical thickness:  '
;read,R, prompt='Input reflectance: '
for i=1,10 do begin
R=a*i
g=1-2*R/(sqrt(3)*tau*(1-R))
print,R,'g= ',g
endfor
end