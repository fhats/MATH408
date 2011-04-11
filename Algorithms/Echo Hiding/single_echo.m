function [ processed_wave ] = single_echo( wav, Fs, time, decay )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if time > 10
        % time is probably in ms... so treat it as such
        time = time / 1000;
    end
    h = dfilt.delay(round(time * Fs));
    delayed_wav = filter(h, wav);
    processed_wave = wav + (delayed_wav * decay);
end

