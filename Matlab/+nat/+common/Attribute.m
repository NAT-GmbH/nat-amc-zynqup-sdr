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
% Module      : Attribute.m
%
% Description : Patched Attribute.m file to work with the NAT-AMC-ZYNQUP-SDR
%
% Author      : Analog Devices, Inc. / Thomas Florkowski
%
%*****************************************************************************
%*****************************************************************************
%
%Copyrigth 2021(c) Gesellschaft fuer Netzwerk- und Automatisierungstechnologie m.b.H (NAT GmbH)
%Copyright 2019(c) Analog Devices, Inc.
%All rights reserved.
%
%*****************************************************************************
%*****************************************************************************


classdef (Abstract) Attribute < adi.common.RegisterReadWrite & ...
        adi.common.DebugAttribute & adi.common.DeviceAttribute
    % Attribute IIO attribute function calls

    methods (Hidden)

        function setAttributeLongLong(obj,id,attr,value,isOutput,phyDevName,tol,phydev)
            if nargin < 8
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            status = iio_channel_attr_write_longlong(obj,chanPtr,attr,value);
            cstatus(obj,status,['Attribute write failed for : ' attr ' with value ' num2str(value)]);
            % Check
            [status, rValue] = iio_channel_attr_read_longlong(obj,chanPtr,attr);
            cstatus(obj,status,['Error reading attribute: ' attr]);
            if nargin<7
                tol = sqrt(eps);
            end
            if abs(value - rValue) > tol
                status = -1;
                cstatus(obj,status,['Attribute ' attr ' return value ' num2str(rValue) ', expected ' num2str(value)]);
            end
        end

        function setAttributeDouble(obj,id,attr,value,isOutput,phyDevName,tol,phydev)
            if nargin < 8
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            status = iio_channel_attr_write_double(obj,chanPtr,attr,value);
            cstatus(obj,status,['Attribute write failed for : ' attr ' with value ' num2str(value)]);
            % Check
            [status, rValue] = iio_channel_attr_read_double(obj,chanPtr,attr);
            cstatus(obj,status,['Error reading attribute: ' attr]);
            if nargin<7
                tol = sqrt(eps);
            end
            if abs(value - rValue) > tol
                status = -1;
                cstatus(obj,status,['Attribute ' attr ' return value ' num2str(rValue) ', expected ' num2str(value)]);
            end
        end

        function rValue = getAttributeLongLong(obj,id,attr,isOutput,phyDevName,phydev)
            if nargin < 6
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            [status, rValue] = iio_channel_attr_read_longlong(obj,chanPtr,attr);
            cstatus(obj,status,['Error reading attribute: ' attr]);
        end

        function rValue = getAttributeDouble(obj,id,attr,isOutput,phyDevName,phydev)
            if nargin < 6
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            [status, rValue] = iio_channel_attr_read_double(obj,chanPtr,attr);
            cstatus(obj,status,['Error reading attribute: ' attr]);
        end


        function setAttributeBool(obj,id,attr,value,isOutput,phyDevName,phydev)
            if nargin < 7
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            status = iio_channel_attr_write_bool(obj,chanPtr,attr,value);
            cstatus(obj,status,['Attribute write failed for : ' attr]);
            % Check
            [status, rValue] = iio_channel_attr_read_bool(obj,chanPtr,attr);
            cstatus(obj,status,['Error reading attribute: ' attr]);
            if value ~= rValue
                status = -1;
                cstatus(obj,status,['Attribute ' attr ' return value ' num2str(rValue) ', expected ' num2str(value)]);
            end
        end

        function rValue = getAttributeBool(obj,id,attr,isOutput,phyDevName,phydev)
            if nargin < 6
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            [status, rValue] = iio_channel_attr_read_bool(obj,chanPtr,attr);
            cstatus(obj,status,['Error reading attribute: ' attr]);
        end

        function setAttributeRAW(obj,id,attr,value,isOutput,phyDevName,phydev)
            if nargin < 7
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            bytes = iio_channel_attr_write(obj,chanPtr,attr,value);
            if bytes <= 0
                status = -1;
                cstatus(obj,status,['Attribute write failed for : ' attr ' with value ' value]);
            end
        end

        function rValue = getAttributeRAW(obj,id,attr,isOutput,phyDevName,phydev)
            if nargin < 6
                phydev = getDev(obj, phyDevName);
            end
            chanPtr = iio_device_find_channel(obj,phydev,id,isOutput);%FIXME (INVERSION)
            status = cPtrCheck(obj,chanPtr);
            cstatus(obj,status,['Channel: ' id ' not found']);
            [bytes, rValue] = iio_channel_attr_read(obj,chanPtr,attr,1024);
            if bytes <= 0
                status = -1;
                cstatus(obj,status,['Attribute read failed for : ' attr]);
            end
        end

        function setDeviceAttributeRAW(obj,attr,value,phyDevName,phydev)
            if nargin < 5
                phydev = getDev(obj, phyDevName);
            end
            bytes = iio_device_attr_write(obj,phydev,attr,value);
            if bytes <= 0
                status = -1;
                cstatus(obj,status,['Attribute write failed for : ' attr ' with value ' value]);
            end
        end

        function rValue = getDeviceAttributeRAW(obj,attr,len,phyDevName,phydev)
            if nargin < 5
                phydev = getDev(obj, phyDevName);
            end
            [status, rValue] = iio_device_attr_read(obj,phydev,attr,len);
            if status == 0
                cstatus(obj,-1,['Error reading attribute: ' attr]);
            end
        end

    end
end
