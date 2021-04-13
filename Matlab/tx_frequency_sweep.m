%This example sweeps through a frequency range while sending a sine
clear;

%Create Sine signal
amplitude = 2^15; frequency = 1e6;
swv = dsp.SineWave(amplitude, frequency);
swv.ComplexOutput = true;
swv.SamplesPerFrame = 524288;
swv.SampleRate = 245.76e6;
x = swv();

LO_freq = 1600e6;
ip = 'ip:192.168.1.160';

tx = nat.ZYNQUP_SDR8.Tx('uri',ip);
tx.SamplesPerFrame=524288;
tx.EnabledChannels = 1; % Enable Tx 1
tx.DataSource = 'DMA';
tx.EnableCyclicBuffers = true;
tx.CenterFrequencyPhy = LO_freq;

tx(x); % Load sine into the buffer of Tx 1 and repeat infinitely

for k=1:100
    tx.CenterFrequencyPhy = LO_freq + k*1e6; %Sweep through frequencies
    pause(1); %Wait a second
end

%If you release the connection the tx mode changes back to DDS and your buffer is deleted
tx.release();
