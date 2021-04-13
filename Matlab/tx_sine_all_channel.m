%This example sends a sine over all 8 tx channel
clear;

%Create sine signal
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
tx.EnabledChannels = [1 2 3 4 5 6 7 8]; % Enable Tx 1 to 8
tx.DataSource = 'DMA';
tx.EnableCyclicBuffers = 1;
tx.CenterFrequencyPhy = LO_freq;
tx.CenterFrequencyPhyB = LO_freq;
tx.CenterFrequencyPhyC = LO_freq;
tx.CenterFrequencyPhyD = LO_freq;

tx([x,x,x,x,x,x,x,x]); % Load sine into the buffer of Tx 1 to 8 and repeat infinitely

%If you release the connection the tx mode changes back to DDS and your buffer is deleted
%tx.release();
