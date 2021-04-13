%This example sends a signal using DDS on Tx 1 to 3

clear;

ip = 'ip:192.168.1.160';
toneFreq1 = 10e6;
toneFreq2 = 20e6;
toneFreq3 = 30e6;

tx = nat.ZYNQUP_SDR8.Tx('uri',ip);
tx.DataSource = 'DDS';
tx.CenterFrequencyPhy = 2.4e9;
tx.CenterFrequencyPhyB = 2.4e9;
tx.DDSFrequencies = [toneFreq1,toneFreq1,toneFreq2,toneFreq2, toneFreq3, toneFreq3,0,0,0,0,0,0,0,0,0,0;...
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
tx.DDSScales = [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0;...
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
tx.DDSPhases = [90000,0,90000,0,90000,0,0,0,0,0,0,0,0,0,0,0;...
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
tx();
tx.release();
