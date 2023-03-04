Pro auto_search_file_2009
;file data file name and data number such as 2009Ja  2222
year='2009'
xpath='D:\Lidar_data\'+year+'\*' ; assign month
Dnm=''
Bnm=''
f1=file_search(xpath)
;nf1=size(f1)
IX=n_elements(f1);
print,'Total files: ',IX
stop

A=strarr(2,IX)
NQ=intarr(IX)

for k=0,IX-1 do begin
print,f1[k]
dnm=strmid(f1[k],19,12)
Bnm=f1[k]+'\a*'
Q2=file_search(Bnm);
Nx=n_elements(Q2)
;A[k]=strmid(f1[k],19,4)
;print,dnm,Nx
A[0,k]=dnm
A[1,k]=Nx
endfor
stop
read,Iend,prompt='number of lines to list'
AF=A[*,0:Iend-1]
outpath='D:\lidar_data\Data_list\'
outfile=outpath+'FilesJan.txt'
openw,1,outfile
print,1,AF
close,1

STOP
MN=strmid(AF,0,2);
file_path=xpath+Mn+'\*'
fls=file_search(file_path)
help,fls
n2=n_elements(fls)
print,'number of data of this month: ',n2
stop

end


