function cloud_func_fixed,X,P
;; fixed KIC 1255 function

x2 = x - P[1]

y1 = 1E + P[0] * 0.001E * (-3.2E) * atan(0.00093E,x2^2 - x2 * atan(0.012E,1.1E + 26E * x2))
return,y1

end
