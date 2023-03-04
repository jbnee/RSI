Pro Remove_elements
; we want to remove 5 from A
A=[1,2,3,4,5,6,7,8,9,5,4,3,5,6,5,8,9,0,5,1,0,12,4]
 nA=n_elements(A)
 print,na; 23

q1=where(A eq 5)
 help,q1
;Q1              LONG      = Array[5]
 nq=n_elements(q1)
stop
for i=0,nq-1 do begin
;i=0
q1=where(A eq 5)
nq1=n_elements(q1);
A=[A[0:q1[0]-1],A[q1[0]+1:(nA-1)-i]]
print,A
endfor
stop
end
