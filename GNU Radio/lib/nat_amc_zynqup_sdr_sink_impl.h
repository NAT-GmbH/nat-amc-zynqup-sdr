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

#ifndef INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SINK_IMPL_H
#define INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SINK_IMPL_H

#include <string>
#include <vector>

#include <iio/nat_amc_zynqup_sdr_sink.h>

#include "device_sink_impl.h"

namespace gr {
  namespace iio {

    class nat_amc_zynqup_sdr_sink_impl : public nat_amc_zynqup_sdr_sink, public device_sink_impl
    {
     private:
      bool cyclic;

      std::vector<std::string> get_channels_vector(const std::vector<int> &tx_en);

     public:
      nat_amc_zynqup_sdr_sink_impl(struct iio_context *ctx, bool destroy_ctx,
            unsigned long samplerate,
            const std::vector<int> & tx_en,
		    unsigned long buffer_size, bool cyclic,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &tx_qec,
            const std::vector<int> &tx_lol,
            const std::vector<double> &attenuation,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &leak_tracking);

      int work(int noutput_items,
		    gr_vector_const_void_star &input_items,
		    gr_vector_void_star &output_items);

      void set_params(unsigned long samplerate,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &tx_qec,
            const std::vector<int> &tx_lol,
              const std::vector<double> &attenuation,
              const std::vector<int> &quad_tracking,
              const std::vector<int> &leak_tracking);
    };

  } // namespace iio
} // namespace gr

#endif /* INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SINK_IMPL_H */
