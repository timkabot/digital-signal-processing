pkg load signal;

%FIRST PART
sound = 'test.ogg';
[y, fs] = audioread(sound);

y = y(6000:1:end,1);
len_mono = size(y)

echo_waves = [15000,30000]

player=audioplayer(y, fs, 8)
play(player);

h = zeros(1, echo_waves(1));
h = [h transpose(y) * 0.5];


h2 = zeros(1, echo_waves(2));
h2 = [h2 transpose(y) * 0.25];
figure(10);
plot(h2);
N = size(h2)(2);
M = size(h)(2);
%add original signal to second echo wave
for i = 1:len_mono
  h2(i) = h2(i) + y(i);
endfor
%add first echo wave
for i = 1:M
  h2(i) = h2(i) + h(i);
endfor
player=audioplayer(h2, fs, 8)
play(player);

%Plot original signal
figure(1);
plot(y);

%Plot signal with echo
figure(2);
plot(h2);

%SECOND PART

len_wave2 = size(h2)(2)
ext = zeros(1, len_wave2);
ext1 = zeros(1, len_wave2);
echo_ext = [ext h2 ext1];
c = zeros(1, 2*len_wave2+1);
for n = -len_wave2:len_wave2
  z1 = zeros(1,len_wave2-n);
  z2 = zeros(1,len_wave2+n);
  x_n = [z1 h2 z2];
  c(n + len_wave2 + 1) = c(n + len_wave2 +1 ) + dot(echo_ext, x_n);
endfor

c = c(N:(2*N-1));
#filter to smooth graphic, this helps to find peaks easier
cFiltered=filter([1 1 1 1 1],[1],c);
figure(4);
plot(cFiltered);
[peaks,locations] = findpeaks(cFiltered, 'DoubleSided', 'MinPeakDistance', 0.2*44100);


% Œ—“€À‹
locations = locations - 3
disp(locations)

echo_waves_found = [locations(2),locations(3) ]

%Subtracting echo waves
for i = 1:len_mono
  h2(echo_waves_found(1) + i) = h2(echo_waves_found(1) + i) - h2(i) * 0.5;
  h2(echo_waves_found(2) + i) = h2(echo_waves_found(2) + i) - h2(i) * 0.25;
endfor

h2 = h2(1:len_mono)
figure(5);
plot(h2);

player=audioplayer(h2, fs, 8)
play(player);
