#!/usr/bin/env ruby

puts $<.sum { [[4+3i,1+1i,7+2i],[8+4i,5+5i,2+6i],[3+8i,9+9i,6+7i]][_1[-2].ord&3][(_1[0].ord&3)-1] }
