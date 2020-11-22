clc;
clear;
function [x] = create_DTMF(digit, len, fs)
  #low frequencies
  freq_low = [697 770 852 941]; 
  len_low = length(freq_low)
  #high frequencies
  freq_high = [1209 1336 1477]; 
  len_high = length(freq_high)
  combinations  = [];
  for i = 1 : len_low
    for j = 1 : len_high
      combinations = [combinations [freq_low(i);freq_high(j)]];
    endfor
  endfor
  N = len * fs;
  samples_num = (0 : N-1) / fs;
  #additive checks for case 0 * #
  if digit == 0
    digit = 11;
 
  elseif digit == "*"
    digit = 10;
  
  elseif digit == "#"
    digit = 12;
  endif
  #FORMULA 
  x = (sin(2*pi*samples_num*combinations(1, digit))) + (sin(2*pi*samples_num*combinations(2, digit)));
endfunction

function [res] = generate_tonal_sequence(dtmf_seq, pause, len, fs )
    frequency = 8000
    res = []
    for i= 1 : length(dtmf_seq)
        res = [res create_DTMF(dtmf_seq(i), len, fs) zeros(1, frequency * pause)];
    end
end
seq = [8,7,6,"*", 9, 8, 7, 6, "*",9,8,7,6, "*",9,8,7,8,6] #star ward melody

#interval between sounds
interval = 0.2
# Duration of each sound
duration = 0.2 
# Sampling frequency
fs = 8000 
# Too loud without gain
gain = 0.05 
a = generate_tonal_sequence(seq, interval, duration, fs);
wavwrite(gain*a, fs, "star_wars.wav")