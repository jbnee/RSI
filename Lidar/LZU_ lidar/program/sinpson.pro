pro sinpson, sigma1, Zb, Zt, S, AVE, resol


top=uint(Zt*1000.0/75.0-1)
base=uint(Zb*1000.0/75.0-1)


S=0.5*(sigma1(base)+sigma1(top))*resol+total(sigma1(base+1:top-1))*resol
AVE=MEAN(sigma1(base:top))



return
end
