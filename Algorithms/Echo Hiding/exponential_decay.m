function [ processed_wave ] = exponential_decay( wav, Fs, time, decay )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    time = time / 1000;
    processed_wave = wav;
    N = round((time)*Fs);
    for d=1:size(wav,2),
        for n=N+1:length(wav),
            processed_wave(n,d) = (decay * processed_wave(n-N,d)) + wav(n,d);
        end
    end
end