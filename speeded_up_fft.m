function [retval] = speeded_up_fft(x)
  N=length(x) / 2; #half of length
  k=1:N;
  
  B=zeros(N, 1); # Create zero vector B
  A=zeros(N, 1); # Create zero vector A
  Br(k)=0.5*(1+sin(pi/(2*N)*k));  # Create coefficients vector B
  Bi(k)=0.5*(cos(pi/(2*N)*k));      # Create coefficients vector B
  Ar(k)=0.5 * (1-sin(pi/(2*N)*k));  # Create coefficients vector A
  Ai(k)=0.5 * (-cos(pi/(2*N)*k));     # Create coefficients vector A


  
  # Create N-sequence from 2N where N is half of length
  even=x(k*2-1); #evens
  odd=x(k*2);#odds
  g=even+i*odd;
    
  # Use FastFourierTransform
  G=fft(g);
  G(N + 1)=G(1);
  
  Gr=real(G)'; #real part
  Gi=imag(G)'; #imaginary part
  
  # Rending/Ripping/Splitting
  Xr=zeros(2*N,1);
  Xi=zeros(2*N,1);
  k=1:N/2;
  Xr(k)=Gr(k).*Ar(k)-Gi(k).*Ai(k)+Gr(N-k+2).*Br(k)+Gi(N-k+2).*Bi(k);
  Xi(k)=Gi(k).*Ar(k)+Gr(k).*Ai(k)+Gr(N-k+2).*Bi(k)-Gi(N-k+2).*Br(k);
  
  k = 2:N;
  Xr(N+1)=Gr(1)-Gi(1);
  Xi(N+1)=0;
  Xr(2*N-k+2)=Xr(k);
  Xi(2*N-k+2)=-Xi(k);
  #calculating the result
  retval=Xr+i*Xi;
endfunction
