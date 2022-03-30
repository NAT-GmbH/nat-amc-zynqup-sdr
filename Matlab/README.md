# Supported Tools and Releases

Tested with:
* R2020b  
* Communications Toolbox Support Package for Xilinx Zynq-Based Radio version 20.2.1
* Analog Devices Inc. Transceiver Toolbox version 20.2.2

# Installation

1. Follow the instructions on https://wiki.analog.com/resources/tools-software/transceiver-toolbox  
 to install the Analog Devices Inc. Transceiver Toolbox and all of its dependencies
2. Place the +nat folder inside the installation folder of the Analog Devices Inc. Transceiver Toolbox  
  * Under Windows the Toolbox is located at `C:\Users\*username*\AppData\Roaming\MathWorks\MATLABAdd-Ons\Toolboxes\Analog Devices, Inc. Transceiver Toolbox`  
  * Under Linux the toolbox is located at `/home/*username*/MATLAB Add-Ons/Toolboxes/Analog Devices, Inc. Transceiver Toolbox`  
3. After the insertion, your directory should look like this  
Analog Devices, Inc. Transceiver Toolbox  
      ├── +adi  
      ├── CI  
      ├── deps  
      ├── doc  
      ├── hdl  
      ├── info.xml  
      ├── jenkins  
      ├── Jenkinsfile  
      ├── LICENSE  
      ├── **+nat**  
      ├── README.md  
      ├── resources  
      ├── test  
      └── trx_examples

# Parameters

Some parameters configure an individual channel, other an ADRV9009 chip.  
The documentation sets parameters always for adrv9009-phy (RX/TX 1 and 2).
If you want to set the parameter for a different ADRV9009 chip, add B to D and the end e.g.
1. CenterFrequencyPhy   
2. CenterFrequencyPhyB  
3. CenterFrequencyPhyC
4. CenterFrequencyPhyD

The documentation sets parameters always for channel 0 (RX1/TX1).  
If you want to set the parameter for a different channel change the number at the end e.g.
1. GainChannel0
2. GainChannel1
3. GainChannel2
4. GainChannel3
5. GainChannel4
6. GainChannel5
7. GainChannel6
8. GainChannel7

# Rx Configuration
## Parameters

###### CenterFrequencyPhy
* Default Value: 2400000000
* Set for Channel/ADRV9009 Chip: Chip
* Can be changed during run time: Yes

###### GainControlModePhy
* Default Value: slow_attack
* Set for Channel/ADRV9009 Chip: Chip
* Can be changed during run time: Yes
* Available Values: slow_attack, manual


###### EnableQuadratureCalibrationPhy
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: No

###### EnablePhaseCorrectionPhy
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: No

###### GainChannel0
* Default Value: 10
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes
* Comment: Is only used with GainControleMode `manual`

###### EnableQuadratureTrackingChannel0
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### EnableHarmonicDistortionTrackingChannel0
* Default Value: false
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### PowerdownChannel0
* Default Value: false
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### EnabledChannels
* Add all Channel you want to enable to the Vector ([1,2,3,4,5,6,7,8] enables all Channel)
* Default Value: 1
* Can be changed during run time: No

###### SamplesPerFrame
* Default Value: 32768
* Max Value for SA Mode: 524288
* Can be changed during run time: No

###### SamplingFrequency
* Default Value: 245.76e6
* Available Values: 245760000, 30720000, 15360000, 7680000, 3840000
* Can be changed during run time: No

###### uri
* Address of the SDR
* Can be changed during run time: No

## Functions

###### calibratePhy()
* Calibrates adrv9009-phy
* Is automatic called when the object is created

###### calibratePhyB()
* Calibrates adrv9009-phy-b
* Is automatic called when the object is created

###### calibratePhyC()
* Calibrates adrv9009-phy-c
* Is automatic called when the object is created

###### calibratePhyD()
* Calibrates adrv9009-phy-d
* Is automatic called when the object is created

###### release()
* Command for releasing the SDR connection at the end of the script

###### [data,valid] = rx()
* Returns data received from the radio
* hardware associated with the receiver system object, rx.
The output 'valid' indicates, whether the object has received
data from the radio hardware. The first valid data frame can
contain transient values, resulting in packets containing
undefined data.
* The output 'data' will be an [NxM] vector, where N is
'SamplesPerFrame' and M is the number of elements in
'EnabledChannels'. 'data' will be complex.

# Tx Configuration
## Parameters

###### CenterFrequencyPhy
* Default Value: 2400000000
* Set for Channel/ADRV9009 Chip: Chip
* Can be changed during run time: Yes

###### EnableQuadratureCalibrationPhy
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: No

###### EnableLOLeakageCorrectionPhy
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: No

###### EnableLOLeakageCorrectionExternalPhy
* Default Value: false
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: No

###### AttenuationChannel0
* Default Value: -30
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### EnableQuadratureTrackingChannel0
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### EnableLOLeakageTrackingChannel0
* Default Value: true
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### PowerdownChannel0
* Default Value: false
* Set for Channel/ADRV9009 Chip: Channel
* Can be changed during run time: Yes

###### EnabledChannels
* Add all Channel you want to enable to the Vector ([1,2,3,4,5,6,7,8] enables all Channel)
* Default Value: 1
* Can be changed during run time: No

###### SamplesPerFrame
* Default Value: 32768
* Max Value for SA Mode: 524288
* Can be changed during run time: No

###### SamplingFrequency
* Default Value: 245.76e6
* Available Values: 245760000, 30720000, 15360000, 7680000, 3840000
* Can be changed during run time: No

###### DataSource
* Default Value: DMA
* Available Values: DMA, DDS
* Can be changed during run time: No

###### EnableCyclicBuffers
* Enables Cyclic Buffers to continuously send the content in the Buffer
* Default Value: false
* Can be changed during run time: No

###### uri
* Address of the SDR
* Can be changed during run time: No

###### DDSFrequencies
* Default Value: [5e5,5e5; 5e5,5e5]
* Can be changed during run time: Yes
* Frequencies values in Hz of the DDS tone generators.
* For complex data devices the input is a [2x16] matrix.

###### DDSScales
* Default Value: [1,0;0,0]
* Can be changed during run time: Yes
* Scale of DDS tones in range [0,1].
* For complex data devices the input is a [2x16] matrix.

###### DDSPhases
* Default Value: [0,0;0,0]
* Can be changed during run time: Yes
* Phases of DDS tones in range [0,360000].
* For complex data devices the input is a [2x16] matrix.

## Functions

###### calibratePhy()
* Calibrates adrv9009-phy
* Is automatic called when the object is created

###### calibratePhyB()
* Calibrates adrv9009-phy-b
* Is automatic called when the object is created

###### calibratePhyC()
* Calibrates adrv9009-phy-c
* Is automatic called when the object is created

###### calibratePhyD()
* Calibrates adrv9009-phy-d
* Is automatic called when the object is created

###### valid = tx(data)
* Returns a logical value that indicates data was sent to the device correctly.
* When 'DataSource' is 'DMA' the input 'data' will be an [NxM]
vector, where N is the length of the input data and M is the
number of elements in 'EnabledChannels'. 'data' must be
complex.
* When 'DataSource' is 'DDS' the operator will take no inputs.
Running the operator simply will force a DDS settings update
and connect to the device if never run before.

###### release()
* Command for releasing the SDR connection at the end of the script
* If you release the connection using DMA Mode with cyclic buffer enabled, your buffer is deleted and the SDR changes back into sending with DDS Mode

# Direct Digital Synthesizer (DDS)
DDS on the radio hardware as the source for transmitting signals

DDS ignores the EnabledChannels attribute, therefore a [2x16] matrix is used to configure all Tx channels.  
The following example sends a sine with different frequencies on Tx 1 to 3

```
tx = nat.ZYNQUP_SDR8.Tx('uri',ip);
tx.DataSource = 'DDS';
toneFreq1 = 10e6;
toneFreq2 = 20e6;
toneFreq3 = 30e6;
tx.DDSFrequencies = [toneFreq1,toneFreq1,toneFreq2,toneFreq2, toneFreq3, toneFreq3,0,0,0,0,0,0,0,0,0,0;...
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
tx.DDSScales = [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0;...
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
tx.DDSPhases = [90000,0,90000,0,90000,0,0,0,0,0,0,0,0,0,0,0;...
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
tx();
tx.release();
```
If you only want to send a sine on channel Tx 1 and don't care about the other channel, you can use the following code:


```
tx = nat.ZYNQUP_SDR8.Tx('uri',ip);
tx.DataSource = 'DDS';
toneFreq1 = 10e6;
tx.DDSFrequencies = [toneFreq1,toneFreq1;0,0];
tx.DDSScales = [1,1;0,0];
tx.DDSPhases = [90000,0;0,0];
tx();
tx.release();
```
But on every other Tx channel there will be sine with 40 MHz frequency, because that is the default DDS configuration for every channel

# Read IIO-Attributes
* Depending on the data type of the attribute, there are several different functions
* These functions work for rx and tx
* Example you want to read the Attribute `in_voltage0_powerdown` from `adrv9009-phy`
* id: Id of the Attriute (e.g. voltage0)
* attr: Name of the Attribute (e.g. powerdown)
* isOutput: Is the Attribute an output or input (e.g. 0 for false)
* phyDevName: Name of the ADRV9009 Chip (e.g. adrv9009-phy)


rValue = getAttributeLongLong(id,attr,isOutput,phyDevName)  
rValue = getAttributeDouble(id,attr,isOutput,phyDevName)  
rValue = getAttributeBool(id,attr,isOutput,phyDevName)  
rValue = getAttributeRAW(id,attr,isOutput,phyDevName)  


To see all available attributes, use the following commands on the console of the SDR:
```
cd /sys/bus/iio/devices/iio:device3
grep "" *
```

# Known Issues
1. Warning: The GainChannel1 property is not relevant in this configuration of the System object.   
  * Just ignore this warning
2. Warning: The EnableQuadratureTrackingChannel1 property is not relevant in this configuration of the System object.  
  * Just ignore this warning
3. Warning: The SamplesPerFrame property is not relevant in this configuration of the System object.
  * Just ignore this warning
4. Warning: The AttenuationChannel1 property is not relevant in this configuration of the System object.
  * Just ignore this warning
5. Warning: The EnableQuadratureTrackingChannel1 property is not relevant in this configuration of the System object.
  * Just ignore this warning
6. Warning: The EnableQuadratureTrackingChannel1 property is not relevant in this configuration of the System object.
  * Just ignore this warning
7. You can't use calibrate together with EnableLOLeakageCorrectionExternal


# Examples

More information on how to use the NAT-AMC-ZYQNUP-SDR8 with MATLAB are shown in the following examples:

### Tx
```
amplitude = 2^15; frequency = 1e6;
swv1 = dsp.SineWave(amplitude, frequency);
swv1.ComplexOutput = true;
swv1.SamplesPerFrame = 524288;
swv1.SampleRate = 245.76e6;
x1 = swv1();

tx = nat.ZYNQUP_SDR8.Tx('uri','192.168.1.160');
tx.SamplesPerFrame=524288;
tx.DataSource = 'DMA';
tx.EnableCyclicBuffers = true;
tx.EnabledChannels = 1; % Enable Tx Channel 1
tx(x1);
tx.release();
```

### Rx
```
rx = nat.ZYNQUP_SDR8.Rx('uri',192.168.1.160);
rx.SamplesPerFrame=524288;
rx.EnabledChannels = [1 2 4]; % Enable Rx Channel 1,2 and 4
[y, valid] = rx();
rx.release();
```

### Read IIO-Attributes
```
rx = nat.ZYNQUP_SDR8.Rx('uri',192.168.1.160);
rx();
temp0 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy')
temp1 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-b')
temp2 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-c')
temp3 = rx.getAttributeLongLong('temp0','input',0,'adrv9009-phy-d')
rx.release();
```
