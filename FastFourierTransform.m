pkg load signal;
audiofile = 'multiple_frequency_signal.wav'

[x, fs] = audioread(audiofile);#reading complex multiple requency s
  
L = 2^8; % Let L be the len(s)
x = x(1:(L),1); # cut s

disp("(Using built in FastFourierTransform) and time = ")
tic;
built_in_FastFourierTransform = fft(x);
toc;

function retval = FastFourierTransform (s)
  len = length(s);
  if len == 1
     retval = s;
     return 
  else
    n = len/2; # half
    odd = s((1:n) * 2 - 1); #all odds
    even = s((1:n) * 2); # all evens
    
    t = zeros(1, len); 
    t(1:n) = FastFourierTransform(odd); #recursive call to odds
    t((n + 1):len) = FastFourierTransform(even); #recursive call to evens
    
    retval(1:n) = t(1:n) +  exp(-i*2*pi*(0:(n-1))/len) .* t((n+1):len);
                  
    retval((n + 1):len) = t(1:n) - exp(-i*2*pi*(0:(n-1))/len) .* t((n+1):len);
  endif
endfunction

function retval = DiscreteFourierTransform (s)
  len = length(s);
  retval = zeros(1, len);
  for k = 0:len - 1
    for n = 0:len - 1
      retval(k+1) = retval(k+1) + s(n+1)*exp(-j*2*pi*n*k/len);
    end
  end
endfunction


disp("Handmade DiscreteFourierTransform time = ")
tic;
my_DiscreteFourierTransform = DiscreteFourierTransform(x);
toc;

disp("Handmade FastFourierTransform time =")
tic;
my_FastFourierTransform = transpose(FastFourierTransform(x)); #to vector
toc;

error = my_DiscreteFourierTransform - my_FastFourierTransform;#difference
error = error.^2;
#quadratic error plotting
disp("Handmade DiscreteFourierTransform vs Handmade FastFourierTransform error ="), disp(sum(error))

error = my_FastFourierTransform - built_in_FastFourierTransform;#difference
error = error.^2;
#quadratic error plotting
disp("Handmade FastFourierTransform vs built in FastFourierTransform error = "), disp(sum(error))

error = my_DiscreteFourierTransform - built_in_FastFourierTransform;#difference
error = error.^2;
#quadratic error plotting
disp("Handmade DiscreteFourierTransform vs built in FastFourierTransform error = "), disp(sum(error))

# Period of sampling
T = 1/fs; 

# Our vector of time
t = (0:L-1)*T;      

figure(1)

subplot(411);
plot(t, x);
title('Audio we have');
xlabel('time in seconds');
ylabel('function X(t)');

f = fs*(0:(L/2))/L;

P1 = abs(built_in_FastFourierTransform / L)(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

subplot(412);
stem(f, P1);
title('FastFourierTransform');
xlabel('frequency in Hz | f (Hz)');
ylabel('|P1(f)|');

P1 = abs(my_FastFourierTransform / L)(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

subplot(413);
stem(f, P1);
title('My FastFourierTransform');
xlabel('frequency in Hz | f (Hz)');
ylabel('|P1(f)|');

P1 = abs(my_DiscreteFourierTransform / L)(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

subplot(414);
stem(f, P1);
title('My DiscreteFourierTransform');
xlabel('frequency in Hz | f (Hz)');
ylabel('|P1(f)|');