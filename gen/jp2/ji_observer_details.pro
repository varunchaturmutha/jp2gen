;
; Pass in an observer and measurement, and get the JP2 encoding options
;
FUNCTION JI_OBSERVER_DETAILS,observer,measurement
;
; Supported observers, usually an observatory/instrument/detector
; triplet, and their properties
;
  nicknames = (ji_hv_oidm2('EIT')).nicknames
  nn = n_elements(nicknames)
  supported = {observer:strarr(nn)}
  for i = 0,nn-1 do begin
     oidm = ji_hv_oidm2(nicknames[i])
     supported.observer[i] = oidm.observatory + '_' + $
                             oidm.instrument + '_' + $
                             oidm.detector
  endfor
;
; Default jp2 encoding options
;
  jp2_default = {n_layers:8,n_levels:8,bit_rate:[0.5,0.01],idl_bitdepth = 256}
;
; Is the passed observer supported?
;
  observer_index = (where(observer eq supported.observer))[0]
;
; If so, continue
;
  if ( observer_index ne -1) then begin
     name = nicknames[observer_index]
     supported_yn = 1
;
; EIT
;
     case name of
        'EIT':   case measurement of
           '304': jp2 = jp2_default
           '171': jp2 = jp2_default
           '195': jp2 = jp2_default
           '284': jp2 = jp2_default
        endcase
;
; MDI
;
        'MDI': case measurement of 
           'INT': jp2 = jp2_default
           'MAG': jp2 = jp2_default
        endcase
;
; LASCO C2
;
        'C2': case measurement of
           'WL': jp2 = jp2_default
        endcase
;
; LASCO C3
;
        'C3': case measurement of
           'WL': jp2 = {n_layers:8,n_levels:8,bit_rate:[4.0,0.01],idl_bitdepth = 256}
        endcase

     endcase
  endif else begin
     supported_yn = 0
     jp2 = jp2_default
  endelse
;
; Return the selection
;
  answer = {supported_yn:supported_yn,jp2:jp2}
  return,answer
end
