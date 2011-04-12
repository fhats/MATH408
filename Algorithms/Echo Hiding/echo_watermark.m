function [ processed_wave ] = echo_watermark( wav, Fs, watermark_data, zero_delay, one_delay, decay_rate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    zero_delay_signal = single_echo(wav, Fs, zero_delay, decay_rate);
    one_delay_signal = single_echo(wav, Fs, one_delay, decay_rate);
    
    watermark = dec2bin(watermark_data);
    segment_length = round(max([zero_delay*Fs one_delay*Fs]))*5;
    segment_transition_time = round((1/5)*segment_length);
    
    one_mixer_signal = zeros(size(wav,1), 1);
    zero_mixer_signal = zeros(size(wav,1), 1);
    original_mixer_signal = zeros(size(wav,1), 1);
    
    % generate the one mixer signal based on watermark information
    last_bit = 2;
    one_mixer_position = 1;

    for char=1:size(watermark,1),
        for bit=1:size(watermark,2),
            watermark_bit = str2num(watermark(char, bit));
            % write the transition if necessary
            for i=1:segment_transition_time,
                if watermark_bit == last_bit || last_bit == 2
                    one_mixer_signal(one_mixer_position + i) = watermark_bit;
                else
                    if watermark_bit == 1,
                        trans_val = (i/segment_transition_time);
                    else
                        trans_val = (segment_transition_time - i)/segment_transition_time;
                    end
                    one_mixer_signal(one_mixer_position + i) = trans_val;
                end
            end
            
            one_mixer_position = one_mixer_position + segment_transition_time;
            % write the echo
            for i=1:segment_length,
                one_mixer_signal(one_mixer_position + i) = watermark_bit;
            end
            one_mixer_position = one_mixer_position + segment_length;
            last_bit = watermark_bit;
        end
    end

    zero_mixer_signal = 1 - one_mixer_signal;
    original_mixer_signal = 1 - (zero_mixer_signal + one_mixer_signal);
    
    zero_signal = zero_delay_signal .* zero_mixer_signal;
    one_signal = one_delay_signal .* one_mixer_signal;
    original_signal = wav .* original_mixer_signal;
    
    processed_wave = zero_signal + one_signal + original_signal;
end

