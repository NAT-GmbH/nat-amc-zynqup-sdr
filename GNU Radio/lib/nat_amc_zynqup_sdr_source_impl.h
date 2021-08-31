/* -*- c++ -*- */
/*
 * Copyright 2021(c) Gesellschaft fuer Netzwerk- und Automatisierungstechnologie m.b.H (NAT GmbH)
 * Author: Thomas Florkowski <thomas.florkowski@nateurope.com>
 *
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifndef INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SOURCE_IMPL_H
#define INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SOURCE_IMPL_H

#include <string>
#include <vector>

#include <iio/nat_amc_zynqup_sdr_source.h>

#include "device_source_impl.h"

namespace gr {
  namespace iio {

    class nat_amc_zynqup_sdr_source_impl : public nat_amc_zynqup_sdr_source
			       , public device_source_impl
    {
     private:
      std::vector<std::string> get_channels_vector(
		    const std::vector<int> &rx_en);

     public:
      nat_amc_zynqup_sdr_source_impl(struct iio_context *ctx, bool destroy_ctx,
		    unsigned long samplerate,
		    const std::vector<int> &rx_en,
		    unsigned long buffer_size,
            const std::vector<std::string> &gain_mode,
			const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &rx_qec,
            const std::vector<int> &rx_phase_corr,
            const std::vector<double> &gain,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &hd2_tracking);

      void set_params(unsigned long samplerate,
            const std::vector<std::string> &gain_mode,
	   		const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &rx_qec,
            const std::vector<int> &rx_phase_corr,
            const std::vector<double> &gain,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &hd2_tracking);
    };

  } // namespace iio
} // namespace gr

#endif /* INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SOURCE_IMPL_H */
