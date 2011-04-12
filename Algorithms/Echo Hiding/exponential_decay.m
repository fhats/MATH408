function [ processed_wave ] = exponential_decay( wav, Fs, time, decay )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if time > 10
        % time is probably in ms... so treat it as such
        time = time / 1000;
    end
    processed_wave = wav;
    N = (time)*Fs;
    for n=N+1:length(wav),
        processed_wave(n) = (decay * processed_wave(n-N)) + wav(n);
    end

end