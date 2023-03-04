pro InterK; layer of Fessen and Hays
kn=intarr(20)
i=18
j=8
Jmax=19
For m=1,jmax do begin
kn(m)=round((m+m+1)/4+0.5)
P1=(i+kn(m))
P2=j+m
Q1=i-kn(m)
Q2=j+m
if P1 GE 0 and P2 GE 0 and Q1 GE 0 and Q2 GE 0 then $
if P1 LE jmax and P2 LE jmax and Q1 LE jmax and Q2 LE jmax then $
print,'m=  ',m,"  k",P1,P2,'  k',Q1,Q2
endfor
end