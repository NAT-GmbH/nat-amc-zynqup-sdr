/* -*- c++ -*- */

#define IIO_API

%include "gnuradio.i"

%{
#include "iio/device_source.h"
#include "iio/device_sink.h"
#include "iio/nat_amc_zynqup_sdr_sink.h"
#include "iio/nat_amc_zynqup_sdr_source.h"
%}

%include "iio/device_source.h"
%include "iio/device_sink.h"
%include "iio/nat_amc_zynqup_sdr_sink.h"
%include "iio/nat_amc_zynqup_sdr_source.h"

GR_SWIG_BLOCK_MAGIC2(iio, device_source);
GR_SWIG_BLOCK_MAGIC2(iio, device_sink);
GR_SWIG_BLOCK_MAGIC2(iio, nat_amc_zynqup_sdr_sink);
GR_SWIG_BLOCK_MAGIC2(iio, nat_amc_zynqup_sdr_sink_f32c);
GR_SWIG_BLOCK_MAGIC2(iio, nat_amc_zynqup_sdr_source);
GR_SWIG_BLOCK_MAGIC2(iio, nat_amc_zynqup_sdr_source_f32c);
