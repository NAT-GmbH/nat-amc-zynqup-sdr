%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Scipt for measuring phase difference on the NAT-AMC-ZYNQUP-SDR8 
%   All measurement results are relativ to channel 1
%   
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;


LO_freq = 1600e6;
ip = 'ip:192.168.1.160';

rx = nat.ZYNQUP_SDR8.Rx('uri',ip);
rx.CenterFrequencyPhy = LO_freq;
rx.CenterFrequencyPhyB = LO_freq;
rx.CenterFrequencyPhyC = LO_freq;
rx.CenterFrequencyPhyD = LO_freq;
rx.SamplesPerFrame=524288;
rx.EnabledChannels = [1 2 3 4 5 6 7 8];

for k=1:10 % Flush the first values
    valid = false;
    while ~valid
        [rx_data, valid] = rx();
    end
end

%Get temperature of the AD9009 Devices
temp1 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy');
temp2 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-b');
temp3 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-c');
temp4 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-d');

rx.release();



%% Plot Waveform

figure(1);
hold on
labels = strings(length(rx.EnabledChannels),1);
for i=1:length(rx.EnabledChannels)
    plot(real(rx_data(:,i)));
    labels(i)= sprintf('RX%u',rx.EnabledChannels(i));
end
legend(labels);
title('Real Part of the Input Signals');
xlabel('Samples') 
ylabel('Amplitude')
xlim([0, 1000])
hold off

%calculate phase differences
phase = zeros (length(rx.EnabledChannels),rx.SamplesPerFrame);
for i=1:length(rx.EnabledChannels)
    phase(i,:)= rad2deg(angle(rx_data(:,1).*conj(rx_data(:,i))));
end

figure(2)
hold on
axis([0 inf -210 210])
labels = strings(length(rx.EnabledChannels)-1,1);

for i=2:length(rx.EnabledChannels)
    plot(phase(i,:));
    labels(i-1)= sprintf('RX%u to RX%u',rx.EnabledChannels(1),rx.EnabledChannels(i));
end
hold off
legend(labels);
title('Phase Difference Relative to RX1');
xlabel('Samples') 
ylabel('Phase Difference in degree')

%% mean phase
mean_phase = mean(phase,2);


%write data to file
fid=fopen('results.txt','a'); % Open text file
    fprintf(fid,'%.2f ,',mean_phase);
    fprintf(fid,'\n');
fclose(fid);

% subtract mean phase value
phase = phase - mean_phase;


%% claculate moving average
averaging_value = 100;
mean_phase_avg = movmean(phase, averaging_value,2);


%% plot phases
figure(3)
hold on
axis([0 inf -10 10])
labels = strings(length(rx.EnabledChannels)-1,1);
for i=2:length(rx.EnabledChannels)
    plot(mean_phase_avg(i,:));
    labels(i-1)= sprintf('RX%u to RX%u',rx.EnabledChannels(1),rx.EnabledChannels(i));
end
hold off
title('Phase Difference Relative to RX1 after Removing Avg');
legend(labels);
xlabel('Samples') 
ylabel('Phase Difference in degree')


