pro licel_file__move
;move txt files to a new location
Path1='f:\lidar_data\2007\Ap\'
path2=path1+'AP_tex'
dfile=path1+'t*'
Result = FILE_SEARCH(dfile)
help,result
s=size(result)
nf=strarr(s[1]+1)  ;number files
print,nf
N=indgen(nf/2)+1  ; these are the txt files
file_move,result(2*n+1),path2
stop
end
