pkg load signal;
#read SPEECH sound
[a, fs] = audioread("a.ogg"); 
train = [a b c];
labels = ['a' 'b' 'c'];

for i = 1:3
  subplot(3, 3, 3 * i - 2);
  plot(train(:,i));
  title(labels(i));
endfor

# test
test_file = "a_t.ogg"

[y, fs] = audioread(test_file);
sound(y, fs);

scores = zeros(3, 1);
for i = 1:3
  l = min(length(y), length(train(:,i)));
  corr = xcorr(y(1:l), train(:,i)(1:l));
  
  subplot(3, 3, 3 * i - 1);
  plot(corr);
  title(["cross-corr " labels(i)]);
  
  scores(i) += max(abs(corr(l - 1000:l + 1000)));
endfor

scores

[_, i] = max(scores);

subplot(3, 3, 3*i);
plot(y);
title(labels(i));

