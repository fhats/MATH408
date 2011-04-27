function [ recovered_watermark ] = detect_echo_watermark( encoded_wav, Fs, delay_1, delay_2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % divide up a signal into windows
    delay_1 = delay_1 / 1000;
    delay_2 = delay_2 / 1000;
    
    nx = length(encoded_wav);                            % size of signal
    w = hamming(2000);                          % hamming window
    nw = length(w);                            % size of window
    pos=1;
    
    delay_1_signal = [];
    delay_2_signal = [];
    decision_signal = [];
    
    while (pos+nw <= nx)                       % while enough signal left
            y = encoded_wav(pos:pos+nw-1).*w;           % make window y
            c = abs(rceps(y));
            ac = autoceps(y);
            
            delay_1_signal(pos) = c(round(delay_1 * Fs) + 1);
            delay_2_signal(pos) = c(round(delay_2 * Fs) + 1);
            if c(round(delay_1 * Fs)+1) > c(round(delay_2 * Fs)+1)
                decision_signal(pos) = 0;
            else
                decision_signal(pos) = 1;
            end
            
            pos = pos + round(nw/50);                 % next window
    end

    figure(2);
    hold on;
    axis([-20, length(decision_signal), -0.1, 1.1]);
    plot(decision_signal);
    
    
    
end