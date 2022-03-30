%******************************************************************************
%******************************************************************************
%                                                                             *
%     NNNNNN         N                A             TTTTTTT TTTTTTTTTT        *
%     N NNNNN        N               AAA                  T TTTTT             *
%     NN NNNNN       N              AAAAA                 T TTTTT             *
%     N N NNNNN      N             A AAAAA                T TTTTT             *
%     N  N NNNNN     N            A A AAAAA               T TTTTT             *
%     N   N NNNNN    N           A   A AAAAA              T TTTTT             *
%     N    N NNNNN   N          A     A AAAAA             T TTTTT             *
%     N     N NNNNN  N         AAAAAAAAA AAAAA            T TTTTT             *
%     N      N NNNNN N        A         A AAAAA           T TTTTT             *
%     N       N NNNNNN       A           A AAAAA          T TTTTT             *
%     N        N NNNNN  OO  A             A AAAAA  OO     T TTTTT     OO      *
%                       OO                         OO                 OO      *
%                                                                             *
%     Gesellschaft fuer Netzwerk- und Automatisierungstechnologie m.b.H       *
%        Konrad-Zuse-Platz 9, D-53227 Bonn, Tel.:+49 228/965 864-0            *
%                            www.nateurope.com                                *
%                                                                             *
%******************************************************************************
%******************************************************************************
%
% Module      : Rx.m
%
% Description : Rx Class for the NAT-AMC-ZYNQUP-SDR4
%
% Author      : Analog Devices, Inc. / Thomas Florkowski
%
%*****************************************************************************
%*****************************************************************************
%
%Copyright 2021(c) Gesellschaft fuer Netzwerk- und Automatisierungstechnologie m.b.H (NAT GmbH)
%Copyright 2019(c) Analog Devices, Inc.
%All rights reserved.
%
%*****************************************************************************
%*****************************************************************************

classdef Rx < nat.ZYNQUP_SDR4.Base & adi.common.Rx
    % nat.ZYNQUP_SDR4.Rx Receive data from the ZYNQUP SDR 8
    %   The nat.ZYNQUP_SDR4.Rx System object is a signal source that can receive
    %   complex data from the ZYNQUP SDR 8.
    %
    %   rx = nat.ZYNQUP_SDR4.Rx;
    %   rx = nat.ZYNQUP_SDR4.Rx('uri','192.168.2.1');
    %
    %   <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf">ADRV9009 Datasheet</a>
    %   <a href="https://nateurope.com/products/NAT-AMC-ZYNQUP-SDR.html">NAT-AMC-ZYNQUP-SDR4</a>

    properties
        %GainControlMode Gain Control Mode
        %   specified as one of the following:
        %   'slow_attack' — For signals with slowly changing power levels
        %   'manual' — For setting the gain manually with the Gain property
        GainControlModePhy = 'slow_attack';
        GainControlModePhyB = 'slow_attack';
        %GainChannelX Gain Channel X
        %   Channel X gain, specified as a scalar from -4 dB to 71 dB. The acceptable
        %   minimum and maximum gain setting depends on the center
        %   frequency.
        GainChannel0 = 10;
        GainChannel1 = 10;
        GainChannel2 = 10;
        GainChannel3 = 10;
    end

    properties (Logical) % MUST BE NONTUNABLE OR SIMULINK WARNS
        %EnableQuadratureTrackingChannelX Enable Quadrature Tracking Channel X
        %   Option to enable quadrature tracking, specified as true or
        %   false. When this property is true, IQ imbalance compensation is
        %   applied to the input signal.
        EnableQuadratureTrackingChannel0 = true;
        EnableQuadratureTrackingChannel1 = true;
        EnableQuadratureTrackingChannel2 = true;
        EnableQuadratureTrackingChannel3 = true;

        %EnableHarmonicDistortionTrackingChannelX Enable Harmonic Distortion Tracking Channel X
        %   Option to enable quadrature tracking, specified as true or
        %   false. When this property is true, IQ imbalance compensation is
        %   applied to the input signal.
        EnableHarmonicDistortionTrackingChannel0 = false;
        EnableHarmonicDistortionTrackingChannel1 = false;
        EnableHarmonicDistortionTrackingChannel2 = false;
        EnableHarmonicDistortionTrackingChannel3 = false;
    end

    properties(Logical, Nontunable)
        %EnableQuadratureCalibration Enable Quadrature Calibration
        %   Option to enable quadrature calibration on initialization,
        %   specified as true or false. When this property is true, IQ
        %   imbalance compensation is applied to the input signal.
        EnableQuadratureCalibrationPhy = true;
        EnableQuadratureCalibrationPhyB = true;
        %EnablePhaseCorrection Enable Phase Correction
        %   Option to enable phase tracking, specified as true or
        %   false. When this property is true, Phase differences between
        %   transceivers will be deterministic across power cycles and LO
        %   changes
        EnablePhaseCorrectionPhy = false;
        EnablePhaseCorrectionPhyB = false;
    end

    properties(Logical)
        %PowerdownChannelX Powerdown Channel X
        %   Logical which will power down RX channel X when set
        PowerdownChannel0 = false;
        PowerdownChannel1 = false;
        PowerdownChannel2 = false;
        PowerdownChannel3 = false;
    end

    properties(Constant, Hidden)
        GainControlModePhySet = matlab.system.StringSet({'manual','slow_attack'});
        GainControlModePhyBSet = matlab.system.StringSet({'manual','slow_attack'});
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = false;
    end

    properties(Nontunable, Hidden, Constant)
        Type = 'Rx';
    end

    properties(Nontunable, Hidden)
        channel_names = {'voltage0_i','voltage0_q','voltage1_i','voltage1_q', ...
            'voltage2_i','voltage2_q','voltage3_i','voltage3_q'};
    end

    properties (Nontunable, Hidden)
        devName = 'axi-adrv9009-rx-hpc';
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            coder.allowpcode('plain');
            obj = obj@nat.ZYNQUP_SDR4.Base(varargin{:});
        end

%--------------------GainControlMode---------------------------------------------------------
        % Check GainControlMode
        function set.GainControlModePhy(obj, value)
            obj.GainControlModePhy = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeRAW(id,'gain_control_mode',value,false,'adrv9009-phy');
            end
        end
        function set.GainControlModePhyB(obj, value)
            obj.GainControlModePhyB = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeRAW(id,'gain_control_mode',value,false,'adrv9009-phy-b');
            end
        end

%-------------------GainChannelX------------------------------------------------------------
        % Check GainChannelX
        function set.GainChannel0(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -4,'<=', 71}, ...
                '', 'Gain');
            assert(mod(value,1/4)==0, 'Gain must be a multiple of 0.25');
            obj.GainChannel0 = value;
            if obj.ConnectedToDevice && strcmp(obj.GainControlModePhy,'manual')
                id = 'voltage0';
                obj.setAttributeLongLong(id,'hardwaregain',value,false,'adrv9009-phy');
            end
        end
        function set.GainChannel1(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -4,'<=', 71}, ...
                '', 'Gain');
            assert(mod(value,1/4)==0, 'Gain must be a multiple of 0.25');
            obj.GainChannel1 = value;
            if obj.ConnectedToDevice && strcmp(obj.GainControlModePhy,'manual')
                id = 'voltage1';
                obj.setAttributeLongLong(id,'hardwaregain',value,false,'adrv9009-phy');
            end
        end
        function set.GainChannel2(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -4,'<=', 71}, ...
                '', 'Gain');
            assert(mod(value,1/4)==0, 'Gain must be a multiple of 0.25');
            obj.GainChannel2 = value;
            if obj.ConnectedToDevice && strcmp(obj.GainControlModePhyB,'manual')
                id = 'voltage0';
                obj.setAttributeLongLong(id,'hardwaregain',value,false,'adrv9009-phy-b');
            end
        end
        function set.GainChannel3(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -4,'<=', 71}, ...
                '', 'Gain');
            assert(mod(value,1/4)==0, 'Gain must be a multiple of 0.25');
            obj.GainChannel3 = value;
            if obj.ConnectedToDevice && strcmp(obj.GainControlModePhyB,'manual')
                id = 'voltage1';
                obj.setAttributeLongLong(id,'hardwaregain',value,false,'adrv9009-phy-b');
            end
        end

%----------------------EnableQuadratureTrackingChannelX---------------------------------------------
        % Check EnableQuadratureTrackingChannel0
        function set.EnableQuadratureTrackingChannel0(obj, value)
            obj.EnableQuadratureTrackingChannel0 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeBool(id,'quadrature_tracking_en',value,false,'adrv9009-phy');
            end
        end
        function set.EnableQuadratureTrackingChannel1(obj, value)
            obj.EnableQuadratureTrackingChannel1 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeBool(id,'quadrature_tracking_en',value,false,'adrv9009-phy');
            end
        end
        function set.EnableQuadratureTrackingChannel2(obj, value)
            obj.EnableQuadratureTrackingChannel2 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeBool(id,'quadrature_tracking_en',value,false,'adrv9009-phy-b');
            end
        end
        function set.EnableQuadratureTrackingChannel3(obj, value)
            obj.EnableQuadratureTrackingChannel3 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeBool(id,'quadrature_tracking_en',value,false,'adrv9009-phy-b');
            end
        end

%------------------------EnableHarmonicDistortionTrackingChannelX------------------------------------
        % Check EnableHarmonicDistortionTrackingChannel0
        function set.EnableHarmonicDistortionTrackingChannel0(obj, value)
            obj.EnableHarmonicDistortionTrackingChannel0 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeBool(id,'hd2_tracking_en',value,false,'adrv9009-phy');
            end
        end
        function set.EnableHarmonicDistortionTrackingChannel1(obj, value)
            obj.EnableHarmonicDistortionTrackingChannel1 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeBool(id,'hd2_tracking_en',value,false,'adrv9009-phy');
            end
        end
        function set.EnableHarmonicDistortionTrackingChannel2(obj, value)
            obj.EnableHarmonicDistortionTrackingChannel2 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeBool(id,'hd2_tracking_en',value,false,'adrv9009-phy-b');
            end
        end
        function set.EnableHarmonicDistortionTrackingChannel3(obj, value)
            obj.EnableHarmonicDistortionTrackingChannel3 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeBool(id,'hd2_tracking_en',value,false,'adrv9009-phy-b');
            end
        end

%-----------------------PowerdownChannelX------------------------------------------------------------
        % Check PowerdownChannel0
        function set.PowerdownChannel0(obj, value)
            obj.PowerdownChannel0 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeBool(id,'powerdown',value,false,'adrv9009-phy');
            end
        end
        function set.PowerdownChannel1(obj, value)
            obj.PowerdownChannel1 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeBool(id,'powerdown',value,false,'adrv9009-phy');
            end
        end
        function set.PowerdownChannel2(obj, value)
            obj.PowerdownChannel2 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeBool(id,'powerdown',value,false,'adrv9009-phy-b');
            end
        end
        function set.PowerdownChannel3(obj, value)
            obj.PowerdownChannel3 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeBool(id,'powerdown',value,false,'adrv9009-phy-b');
            end
        end
    end
    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required sine Simulink support doesn't support
            % modification to nontunable variables at SetupImpl

            % Channels need to be powered up first so we can changed things
            obj.setAttributeBool('voltage0','powerdown',false,true,'adrv9009-phy');
            obj.setAttributeBool('voltage1','powerdown',false,true,'adrv9009-phy');
            obj.setAttributeBool('voltage0','powerdown',false,true,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','powerdown',false,true,'adrv9009-phy-b');

            obj.setAttributeLongLong('voltage0_i','sampling_frequency',obj.SamplingFrequency,false,obj.devName);

            obj.setAttributeRAW('voltage0','gain_control_mode',obj.GainControlModePhy,false,'adrv9009-phy');
            obj.setAttributeRAW('voltage0','gain_control_mode',obj.GainControlModePhyB,false,'adrv9009-phy-b');

            obj.setAttributeBool('voltage0','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel0,false,'adrv9009-phy');
            obj.setAttributeBool('voltage1','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel1,false,'adrv9009-phy');
            obj.setAttributeBool('voltage0','hd2_tracking_en',obj.EnableHarmonicDistortionTrackingChannel0,false,'adrv9009-phy');
            obj.setAttributeBool('voltage1','hd2_tracking_en',obj.EnableHarmonicDistortionTrackingChannel1,false,'adrv9009-phy');
            obj.setAttributeBool('voltage0','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel2,false,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel3,false,'adrv9009-phy-b');
            obj.setAttributeBool('voltage0','hd2_tracking_en',obj.EnableHarmonicDistortionTrackingChannel2,false,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','hd2_tracking_en',obj.EnableHarmonicDistortionTrackingChannel3,false,'adrv9009-phy-b');

            id = 'altvoltage0';
            obj.setAttributeLongLong(id,'frequency',obj.CenterFrequencyPhy ,true,'adrv9009-phy');
            obj.setAttributeLongLong(id,'frequency',obj.CenterFrequencyPhyB ,true,'adrv9009-phy-b');

            if strcmp(obj.GainControlModePhy,'manual')
                obj.setAttributeLongLong('voltage0','hardwaregain',obj.GainChannel0,false,'adrv9009-phy');
                obj.setAttributeLongLong('voltage1','hardwaregain',obj.GainChannel1,false,'adrv9009-phy');
            end
            if strcmp(obj.GainControlModePhyB,'manual')
                obj.setAttributeLongLong('voltage0','hardwaregain',obj.GainChannel2,false,'adrv9009-phy-b');
                obj.setAttributeLongLong('voltage1','hardwaregain',obj.GainChannel3,false,'adrv9009-phy-b');
            end

            % Do one shot cals
            obj.setDeviceAttributeRAW('calibrate_rx_qec_en',num2str(obj.EnableQuadratureCalibrationPhy),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate_rx_phase_correction_en',num2str(obj.EnablePhaseCorrectionPhy),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate_rx_qec_en',num2str(obj.EnableQuadratureCalibrationPhy),'adrv9009-phy-b');
            obj.setDeviceAttributeRAW('calibrate_rx_phase_correction_en',num2str(obj.EnablePhaseCorrectionPhy),'adrv9009-phy-b');
            obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy-b');

            % Bring stuff back up as desired
            obj.setAttributeBool('voltage0','powerdown',obj.PowerdownChannel0,true,'adrv9009-phy');
            obj.setAttributeBool('voltage1','powerdown',obj.PowerdownChannel1,true,'adrv9009-phy');
            obj.setAttributeBool('voltage0','powerdown',obj.PowerdownChannel2,true,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','powerdown',obj.PowerdownChannel3,true,'adrv9009-phy-b');

        end

    end

end
