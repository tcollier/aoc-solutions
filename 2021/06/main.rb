                     #tom
                     #aoc
                     #day
                     #six
                     S={}.
                     dup;F=
                     ->a,b{#
                     b>00&&b>
                     -0+a ?S[[
                     a,b]  ]||=
                     F[6,   b-a-
                    1]+F[    8,b-
                   a-1]:1     };f=
                  $<.gets      .#f==
                 gsub(ac=       /\d/).
                map{ |_|_        .to_i};
               o=f.  map{         |a|F[a,#
              0120   ]}.#          swim fish
             sum;    ;t=f.          map{  |b|b
            F[b,     01<<07          <<1]   }.#.
          sum;G      =%| ><|         +(?(*    +4)+
         'º'+?>      ;X=?·;E=        "\033"     +?[;
       K=0x20.       chr* 10;+       1;alias     :_#_:
      :print;W       =->{  +1+1      ;sleep(q      =0.2)}
    Z=->  z{_(       G+E+   ?G);     ;+z. size      .tap{|a
   |(01   ..a)      .%(1)    {|n|    W[];  _(w=       z[n-01]+
 G+(E     .dup     <<?D)*     9)}}   ;h=1   ..5;       h.%( 1){;
W[]};     puts    K};Z[o.     to_s]  ;Z[p    ||t.        to_s  ];+0
