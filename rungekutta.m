h = 0.1:0.1:1; % Steps size

errors = zeros(1, length(h));

% Runge-Kutta
function result = f(y, x)
    result = -y + 26*x.^2 + 4*x + 97;
endfunction


function f = f_(x)
    f = -144 * exp(-x) + 26*x.^2-48*x +145;
endfunction

_k1 = @(x,y) -y+26*x.^2+4*x+97;
_k2 = @(x,y,h) _k1(x+h/2,y+(_k1(x,y)*h/2));
_k3 = @(x,y,h) _k1(x+h/2,y+(_k2(x,y,h)*h/2));
_k4 = @(x,y,h) _k1(x+h,y+h*_k3(x,y,h));

for j=1:length(h)
    x = 0:h(j):4; % array of 0.0, 0.1, 0.2 .. 3.9, 4.0
    F_ = -144 * exp(-x) + 26*x.^2-48*x +145; % Analytical solution of the ODE
    y = zeros(1, length(x)); % array of 1, 0, 0, 0
    y(1) = 1; % Initial value
    y_lsode = lsode(@f, 1, x);
    for i=1:length(x)-1
        y(i+1)=y(i)+1/6*h(j)*(_k1(x(i),y(i))+2*_k2(x(i),y(i),h(j))+2*_k3(x(i),y(i),h(j))+_k4(x(i),y(i),h(j)));
    end
    errors(j) = sum(abs(y - transpose(y_lsode)))/length(x);
    disp(errors(j))
    figure(j)
    plot(
        x, y, ";Runge-kutta;",
        x, y_lsode, ";Octave;",
        x, F_, ";Analytical;"
    )
 
end

figure(11);
disp(errors);
plot(h, errors);
