Pro windowfilter
;function v=window(V)
   ; %mean value by Blackman window
    N=length(V);
    w=0;
    for n=1,(N-1)/2 do begin
      w=w+V(n)*(0.42-0.5*cos(2*pi*n/N)+0.08*cos(4*pi*n/N));
      w=w+V(N-n+1)*(0.42-0.5*cos(2*pi*n/N)+0.08*cos(4*pi*n/N));
    endfor
    if(n eq (N/2-1)) then w=w+V(N/2);

    v=w/N/0.42;
    stop
    end
