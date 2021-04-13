%This example reads the temperature of each AD9009 and plots the received signal from all 8 rx channel

clear;

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
        [y, valid] = rx();
    end
end

%Get temperature of the AD9009 Devices
temp1 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy');
temp2 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-b');
temp3 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-c');
temp4 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-d');

rx.release();

%Plot the content of the buffer
figure(1);
for i = 1:length(rx.EnabledChannels)
    plot(0:numel(y(:,i))-1, real(y(:,i))); %Plot only the real part
    hold on
end

N=length(rx.EnabledChannels);
Legend=cell(N,1);
for iter=1:N
  Legend{iter}=strcat('Rx', num2str(iter));
end
legend(Legend)

hold off;
xlabel('sample index');
xlim([0 500]);
grid on;
