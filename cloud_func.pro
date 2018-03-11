function cloud_func,X,P
;; Exponential functions for a disintegrating debris cloud

;nlength = n_elements(X)
;y = fltarr(nlength) + 1.0E
;lowp = where(X LT P[1])
;;midp = where(X GE P[1] and X LT P[2])
;highp = where(X GE P[1])
;if lowp NE [-1] then begin
;   y[lowp] = y[lowp] - P[0] * exp((X[lowp] - P[1])/P[2])
;endif
;
;;if lowp NE [-1] then y[lowp] = poly(x[lowp],P)
;if highp NE [-1] then begin
;   y[highp] = y[highp] - P[0] * exp(-(X[highp] - P[1])/P[3])
;endif

;y = 1E - P[0] * exp((-X - P[1])/P[2])
x2 = x - P[1]
  y = P[0] * (-p[5] * atan(P[1],x2^2 - x2 * atan(P[2],P[3] + P[4] * x2)))
  y = y + 1E

return,y
end
