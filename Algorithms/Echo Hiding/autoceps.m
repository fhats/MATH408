function [ xhat ] = autoceps( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    h = fft(x);
    [ah,nd] = rcunwrap(angle(h));
    logh = log(abs(h))+i*ah;
    logh .^ 2;
    xhat = real(ifft(logh));
end

%--------------------------------------------------------------------------
function [y,nd] = rcunwrap(x)
%RCUNWRAP Phase unwrap utility used by CCEPS.
%   RCUNWRAP(X) unwraps the phase and removes phase corresponding
%   to integer lag.  See also: UNWRAP, CCEPS.

%   Author(s): L. Shure, 1988
%   	   L. Shure and help from PL, 3-30-92, revised

n = length(x);
y = unwrap(x);
nh = fix((n+1)/2);

idx = nh+1; 
% Special case the index for scalar input.
if length(y) == 1, idx = 1; end

nd = round(y(idx)/pi);
y(:) = y(:)' - pi*nd*(0:(n-1))/nh;
end