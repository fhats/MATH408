function [ recovered_watermark ] = detect_echo_watermark( encoded_wav, Fs, delay_0, delay_1 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % divide up a signal into windows
    delay_0 = delay_0 / 1000;
    delay_1 = delay_1 / 1000;
    
    nx = length(encoded_wav);                            % size of signal
    w = hamming(2000);                          % hamming window
    nw = length(w);                            % size of window
    pos=1;
    
    delay_0_signal = [];
    delay_1_signal = [];
    decision_signal = [];

    while (pos+nw <= nx)                       % while enough signal left
            y = encoded_wav(pos:pos+nw-1).*w;           % make window y
            c = abs(rceps(y));
            ac = autoceps(y);
            
            delay_0_signal(pos) = c(round(delay_0 * Fs) + 1);
            delay_1_signal(pos) = c(round(delay_1 * Fs) + 1);
            
            pos = pos + round(nw/50);                 % next window
    end
    
    last_recorded_bit = 0;
    for pos=1:length(delay_0_signal),
            if delay_1_signal(pos) - delay_0_signal(pos) > 0
                decision_signal(pos) = 1;
                last_recorded_bit = 1;
            elseif delay_1_signal(pos) - delay_0_signal(pos) < 0
                decision_signal(pos) = 0;
                last_recorded_bit = 0;
            else
                decision_signal(pos) = last_recorded_bit;
            end        
    end
    
    figure(2);
    hold on;
    %axis([-20, length(decision_signal), -0.1, 1.1]);
    plot(decision_signal);
    figure(3);
    plot(delay_1_signal - delay_0_signal);
    figure(4);
    plot(delay_1_signal);
    figure(5);
    plot(delay_0_signal);
    
end