class Complex
  alias :x :real
    alias :y :imag
      end;hv, hvg = 2.
        times.map { Hash.
          new{ 0 } };R = ->{
            _1<_2 ? _1.._2 : _2..
              _1}; C = -> g { g.
                count { _2>1 } }
                  $<.each do |line|
                    p1, p2 = line.
                      chomp.split(' -> '
                        ).map do |pair|
                          pair.split(',').
                            map(&:to_i).zip(
                              [1, 1i]).map{_1.
                                inject(&:*) }.
                                  inject(&:+);end
                                    if(p2-p1).x==0
                                    R[p1.y, p2.y].
                                  each do;hv[p1.
                                x + _1 * 1i]+=
                              1;hvg[p1.x+_1*
                            1i]+=1;end
                          elsif(p2-p1).y==
                        0;R[p1.x,p2.x].
                      each do;hv[_1+
                    p1.y*1i]+=1;hvg[
                  _1+p1.y*1i]+=1
                end;else;R[p1.x,
              p2.x].each do
            m=(p2.y-p1.y)/
          (p2.x-p1.x);b=
        p1.y-m*p1.x
      hvg[_1+(m*_1+
    b)*1i]+=1;end
  end;end;[hv,hvg].
each{puts C[_1]}
