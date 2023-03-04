Pro Linear_Eq; input two points to get linear eq y=mx+p
read,x1,y1,prompt='input x1,y1:  '
read,x2,y2,prompt='input x2,y2:  '
m=(y1-y2)/(x1-x2)
p=y1-x1*(y1-y2)/(x1-x2)
print,m,p
stop
read,xtest,prompt='test point:  '
y=m*xtest+p
print,'y=  :',y
stop
end
