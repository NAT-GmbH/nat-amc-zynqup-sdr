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
% Module      : Tx.m
%
% Description : Tx Class for the NAT-AMC-ZYNQUP-SDR4
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

classdef Tx < nat.ZYNQUP_SDR4.Base & adi.common.Tx
    % nat.ZYNQUP_SDR4.Tx Transmit data from the ZYNQUP SDR4 transceiver
    %   The nat.ZYNQUP_SDR4.Tx System object is a signal sink that can tranmsit
    %   complex data from the ZYNQUP SDR4.
    %
    %   tx = nat.ZYNQUP_SDR4.Tx;
    %   tx = nat.ZYNQUP_SDR4.Tx('uri','192.168.2.1');
    %
    %   <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf">ADRV9009 Datasheet</a>
    %   <a href="https://nateurope.com/products/NAT-AMC-ZYNQUP-SDR.html">NAT-AMC-ZYNQUP-SDR4</a>

    properties
        %AttenuationChannelX Attenuation Channel X
        %   Attentuation specified as a scalar from -41.95 to 0 dB with a
        %   resolution of 0.05 dB.
        AttenuationChannel0 = -30;
        AttenuationChannel1 = -30;
        AttenuationChannel2 = -30;
        AttenuationChannel3 = -30;
    end

    properties (Logical)
        %EnableQuadratureTrackingChannelX Enable Quadrature Tracking Channel X
        %   Option to enable quadrature tracking, specified as true or
        %   false. When this property is true, IQ imbalance compensation is
        %   applied to the transmitted signal.
        EnableQuadratureTrackingChannel0 = true;
        EnableQuadratureTrackingChannel1 = true;
        EnableQuadratureTrackingChannel2 = true;
        EnableQuadratureTrackingChannel3 = true;

        %EnableLOLeakageTrackingChannelX Enable LO Leakage Tracking Channel X
        %   Option to enable quadrature tracking, specified as true or
        %   false. When this property is true, LO leakage compensation is
        %   applied to the transmitted signal.
        EnableLOLeakageTrackingChannel0 = true;
        EnableLOLeakageTrackingChannel1 = true;
        EnableLOLeakageTrackingChannel2 = true;
        EnableLOLeakageTrackingChannel3 = true;
    end

    properties(Logical, Nontunable)
        %EnableQuadratureCalibration Enable Quadrature Calibration
        %   Option to enable quadrature calibration on initialization,
        %   specified as true or false. When this property is true, IQ
        %   imbalance compensation is applied to the input signal.
        EnableQuadratureCalibrationPhy = true;
        EnableQuadratureCalibrationPhyB = true;
        %EnableLOLeakageCorrection Enable LO Leakage Correction
        %   Option to enable phase tracking, specified as true or
        %   false. When this property is true, at initialization LO leakage
        %   correction will be applied
        EnableLOLeakageCorrectionPhy = true;
        EnableLOLeakageCorrectionPhyB = true;
        %EnableLOLeakageCorrectionExternal Enable LO Leakage Correction External
        %   Option to enable phase tracking, specified as true or
        %   false. When this property is true, at initialization LO leakage
        %   correction will be applied within an external loopback path.
        %   Note this requires external cabling.
        EnableLOLeakageCorrectionExternalPhy = false;
        EnableLOLeakageCorrectionExternalPhyB = false;
    end

    properties(Logical)
        %PowerdownChannelX Powerdown Channel X
        %   Logical which will power down TX channel X when set
        PowerdownChannel0 = false;
        PowerdownChannel1 = false;
        PowerdownChannel2 = false;
        PowerdownChannel3 = false;
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = true;
    end

    properties(Nontunable, Hidden, Constant)
        Type = 'Tx';
    end

    properties(Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3','voltage4','voltage5', ...
            'voltage6', 'voltage7'};
    end


    properties (Nontunable, Hidden)
        devName = 'axi-adrv9009-tx-hpc';
    end

    methods
        %% Constructor
        function obj = Tx(varargin)
            coder.allowpcode('plain');
            obj = obj@nat.ZYNQUP_SDR4.Base(varargin{:});
        end
        % Check Attentuation
        function set.AttenuationChannel0(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -41.95,'<=', 0}, ...
                '', 'Attenuation');
            assert(mod(value,1/20)==0, 'Attentuation must be a multiple of 0.05');
            obj.AttenuationChannel0 = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeLongLong(id,'hardwaregain',value,true,'adrv9009-phy');
            end
        end
        function set.AttenuationChannel1(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -41.95,'<=', 0}, ...
                '', 'Attenuation');
            assert(mod(value,1/20)==0, 'Attentuation must be a multiple of 0.05');
            obj.AttenuationChannel1 = value;
            if obj.ConnectedToDevice
                id = 'voltage1';
                obj.setAttributeLongLong(id,'hardwaregain',value,true,'adrv9009-phy');
            end
        end
        function set.AttenuationChannel2(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -41.95,'<=', 0}, ...
                '', 'Attenuation');
            assert(mod(value,1/20)==0, 'Attentuation must be a multiple of 0.05');
            obj.AttenuationChannel2 = value;
            if obj.ConnectedToDevice
                obj.setAttributeLongLong('voltage0','hardwaregain',value,true,'adrv9009-phy-b');
            end
        end
        function set.AttenuationChannel3(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'scalar', 'finite', 'nonnan', 'nonempty', '>=', -41.95,'<=', 0}, ...
                '', 'Attenuation');
            assert(mod(value,1/20)==0, 'Attentuation must be a multiple of 0.05');
            obj.AttenuationChannel3 = value;
            if obj.ConnectedToDevice
                obj.setAttributeLongLong('voltage1','hardwaregain',value,true,'adrv9009-phy-b');
            end
        end

        % Check PowerdownChannel0
        function set.PowerdownChannel0(obj, value)
            obj.PowerdownChannel0 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage0','powerdown',value,true,'adrv9009-phy');
            end
        end
        function set.PowerdownChannel1(obj, value)
            obj.PowerdownChannel1 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage1','powerdown',value,true,'adrv9009-phy');
            end
        end
        function set.PowerdownChannel2(obj, value)
            obj.PowerdownChannel2 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage0','powerdown',value,true,'adrv9009-phy-b');
            end
        end
        function set.PowerdownChannel3(obj, value)
            obj.PowerdownChannel3 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage1','powerdown',value,true,'adrv9009-phy-b');
            end
        end

        % Check EnableQuadratureTrackingChannel0
        function set.EnableQuadratureTrackingChannel0(obj, value)
            obj.EnableQuadratureTrackingChannel0 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage0','quadrature_tracking_en',value,true,'adrv9009-phy');
            end
        end
        function set.EnableQuadratureTrackingChannel1(obj, value)
            obj.EnableQuadratureTrackingChannel1 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage1','quadrature_tracking_en',value,true,'adrv9009-phy');
            end
        end
        function set.EnableQuadratureTrackingChannel2(obj, value)
            obj.EnableQuadratureTrackingChannel2 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage0','quadrature_tracking_en',value,true,'adrv9009-phy-b');
            end
        end
        function set.EnableQuadratureTrackingChannel3(obj, value)
            obj.EnableQuadratureTrackingChannel3 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage1','quadrature_tracking_en',value,true,'adrv9009-phy-b');
            end
        end

        % Check EnableLOLeakageTrackingChannel0
        function set.EnableLOLeakageTrackingChannel0(obj, value)
            obj.EnableLOLeakageTrackingChannel0 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage0','lo_leakage_tracking_en',value,true,'adrv9009-phy');
            end
        end
        function set.EnableLOLeakageTrackingChannel1(obj, value)
            obj.EnableLOLeakageTrackingChannel1 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage1','lo_leakage_tracking_en',value,true,'adrv9009-phy');
            end
        end
        function set.EnableLOLeakageTrackingChannel2(obj, value)
            obj.EnableLOLeakageTrackingChannel2 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage0','lo_leakage_tracking_en',value,true,'adrv9009-phy-b');
            end
        end
        function set.EnableLOLeakageTrackingChannel3(obj, value)
            obj.EnableLOLeakageTrackingChannel3 = value;
            if obj.ConnectedToDevice
                obj.setAttributeBool('voltage1','lo_leakage_tracking_en',value,true,'adrv9009-phy-b');
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
            
            obj.setAttributeLongLong('voltage0','sampling_frequency',obj.SamplingFrequency,true,obj.devName);

            obj.setAttributeLongLong('altvoltage0','frequency',obj.CenterFrequencyPhy ,true,'adrv9009-phy');
            obj.setAttributeLongLong('altvoltage0','frequency',obj.CenterFrequencyPhyB ,true,'adrv9009-phy-b');

            obj.setAttributeLongLong('voltage0','hardwaregain',obj.AttenuationChannel0,true,'adrv9009-phy');
            obj.setAttributeLongLong('voltage1','hardwaregain',obj.AttenuationChannel1,true,'adrv9009-phy');
            obj.setAttributeLongLong('voltage0','hardwaregain',obj.AttenuationChannel2,true,'adrv9009-phy-b');
            obj.setAttributeLongLong('voltage1','hardwaregain',obj.AttenuationChannel3,true,'adrv9009-phy-b');

            obj.setAttributeBool('voltage0','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel0,true,'adrv9009-phy');
            obj.setAttributeBool('voltage1','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel1,true,'adrv9009-phy');
            obj.setAttributeBool('voltage0','lo_leakage_tracking_en',obj.EnableLOLeakageTrackingChannel0,true,'adrv9009-phy');
            obj.setAttributeBool('voltage1','lo_leakage_tracking_en',obj.EnableLOLeakageTrackingChannel1,true,'adrv9009-phy');
            obj.setAttributeBool('voltage0','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel2,true,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','quadrature_tracking_en',obj.EnableQuadratureTrackingChannel3,true,'adrv9009-phy-b');
            obj.setAttributeBool('voltage0','lo_leakage_tracking_en',obj.EnableLOLeakageTrackingChannel2,true,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','lo_leakage_tracking_en',obj.EnableLOLeakageTrackingChannel3,true,'adrv9009-phy-b');

            % Do one shot cals
            obj.setDeviceAttributeRAW('calibrate_tx_qec_en',num2str(obj.EnableQuadratureCalibrationPhy),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate_tx_lol_en',num2str(obj.EnableLOLeakageCorrectionPhy),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate_tx_lol_ext_en',num2str(obj.EnableLOLeakageCorrectionExternalPhy),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy');
            obj.setDeviceAttributeRAW('calibrate_tx_qec_en',num2str(obj.EnableQuadratureCalibrationPhyB),'adrv9009-phy-b');
            obj.setDeviceAttributeRAW('calibrate_tx_lol_en',num2str(obj.EnableLOLeakageCorrectionPhyB),'adrv9009-phy-b');
            obj.setDeviceAttributeRAW('calibrate_tx_lol_ext_en',num2str(obj.EnableLOLeakageCorrectionExternalPhyB),'adrv9009-phy-b');
            obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy-b');

            % Bring stuff back up as desired
            obj.setAttributeBool('voltage0','powerdown',obj.PowerdownChannel0,true,'adrv9009-phy');
            obj.setAttributeBool('voltage1','powerdown',obj.PowerdownChannel1,true,'adrv9009-phy');
            obj.setAttributeBool('voltage0','powerdown',obj.PowerdownChannel2,true,'adrv9009-phy-b');
            obj.setAttributeBool('voltage1','powerdown',obj.PowerdownChannel3,true,'adrv9009-phy-b');


            obj.ToggleDDS(strcmp(obj.DataSource,'DDS'));
            if strcmp(obj.DataSource,'DDS')
                obj.DDSUpdate();
            end
        end

    end

end
