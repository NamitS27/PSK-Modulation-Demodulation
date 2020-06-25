function [ carrier_wave_e,carrier_wave, time_axis, no_samp_in_symb, x, y ] = qpsk_modulation( carrier_freq, number_of_bits, original_signal, amp_err, freq_err )

    sampling_frequency = 20000; % sampling frequency [Hz]
    amplitude = 0.5;          % amplitude
    signal_length = (1/carrier_freq)*(number_of_bits/2);
    symbol_length = (1/carrier_freq);
    
    num_samples = signal_length*sampling_frequency;
    no_samp_in_symb = symbol_length*sampling_frequency;
    time_axis = 0:1/(sampling_frequency):(num_samples-1)/(sampling_frequency);
    
    carrier_wave_e = zeros(1, no_samp_in_symb*(number_of_bits/2));
    carrier_wave = zeros(1, no_samp_in_symb*(number_of_bits/2));
    x= zeros(1, floor(number_of_bits/2));
    y= zeros(1, floor(number_of_bits/2));
    
    for i = 1:(number_of_bits/2)
        if original_signal(2*i) == 0
                if original_signal((2*i)-1) == 0
                    offset = 0.625;
                end 
                if original_signal((2*i)-1) == 1
                    offset = 0.875;
                end
        end
        if original_signal(2*i) == 1
                if original_signal((2*i)-1) == 0
                    offset = 0.375;
                end 
                if original_signal((2*i)-1) == 1
                    offset = 0.125;
                end
        end
        amplitude_dev = amp_err*randn();
        freq_dev = freq_err*randn();
        x(i)=(amplitude_dev+amplitude)*cos(2*pi*(offset + freq_dev));
        y(i)=(amplitude_dev+amplitude)*sin(2*pi*(offset + freq_dev));

        for j = 1:no_samp_in_symb
            carrier_wave_e(((i-1)*no_samp_in_symb)+j) = (amplitude_dev+amplitude)*cos(2*pi*carrier_freq*time_axis(((i-1)*no_samp_in_symb)+j) + 2*pi*(offset + freq_dev));
            carrier_wave(((i-1)*no_samp_in_symb)+j) = amplitude*cos(2*pi*carrier_freq*time_axis(((i-1)*no_samp_in_symb)+j) + 2*pi*offset);        
        end
    end
end