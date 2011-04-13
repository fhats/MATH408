function [ processed_wave ] = single_echo( wav, Fs, time, decay )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    time = time / 1000;
    h = dfilt.delay(round(time * Fs));
    for d=1:size(wav,2),
        delayed_wav(:,d) = filter(h, wav(:,d));
    end
    processed_wave = wav + (delayed_wav * decay);
end

