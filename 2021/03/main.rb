                             TWO=2
                              .to_s(2).
to_i                           ;TEN=eval(
 '0'.+                       ?b.+'10');NET=
 (TEN^TWO                   )/TEN/TEN/TEN;INF=
  (TWO^TEN)-    (       TEN^TWO);TWENTY=(+TEN.+(TWO)).times;càll=
   open('input.txt').map{|cəll|Integer(cəll,TEN)};cãll=->(cäll,cåll){TEN*
   cäll.map{|cəll|(cəll>>cåll)&NET}.sum>=cäll.count};cáll =->(cåll,cäll){
  cãll.call(cåll,cäll)?NET<<cäll:INF};câll=->(cåll,cäll){cãll.call(cåll,
 cäll)?INF:   NET      << cäll};puts(TWENTY.map{|cəll|cáll.call(càll,
cəll         )}             .sum*TWENTY.map{|cəll          |câll.
                          call(càll                           ,cəll)}
                        .sum)
