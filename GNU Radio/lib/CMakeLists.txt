# Copyright 2011,2012 Free Software Foundation, Inc.
#
# This file is part of GNU Radio
#
# GNU Radio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# GNU Radio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GNU Radio; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.

########################################################################
# Setup library
########################################################################
include(GrPlatform) #define LIB_SUFFIX

include_directories(${Boost_INCLUDE_DIR} ${IIO_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})


list(APPEND iio_sources
	device_source_impl.cc
	device_sink_impl.cc
    nat_amc_zynqup_sdr_sink_impl.cc
	nat_amc_zynqup_sdr_source_impl.cc
)

set(iio_sources "${iio_sources}" PARENT_SCOPE)
if(NOT iio_sources)
	MESSAGE(STATUS "No C++ sources... skipping lib/")
	return()
endif(NOT iio_sources)

add_library(gnuradio-nat SHARED ${iio_sources})
target_link_libraries(gnuradio-nat
	gnuradio::gnuradio-runtime
	gnuradio::gnuradio-blocks
	gnuradio::gnuradio-analog
	gnuradio::gnuradio-pmt
	gnuradio::gnuradio-filter
	gnuradio::gnuradio-fft
	${IIO_LIBRARIES}
)
target_include_directories(gnuradio-nat
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include>
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/>
    PUBLIC $<INSTALL_INTERFACE:include>
  )

if(APPLE)
    set_target_properties(gnuradio-nat PROPERTIES
        INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib"
    )
endif(APPLE)

########################################################################
# Install built library files
########################################################################
include(GrMiscUtils)
GR_LIBRARY_FOO(gnuradio-nat)

set_target_properties(gnuradio-nat PROPERTIES
    #VERSION ${GR_IIO_VERSION}
    #SOVERSION ${GR_IIO_VERSION_MAJOR}
    VERSION "1"
    SOVERSION "1"
    DEFINE_SYMBOL "gnuradio_nat_EXPORTS"
)
