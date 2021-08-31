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


#ifndef INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SOURCE_H
#define INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SOURCE_H

#include <iio/api.h>
#include <gnuradio/hier_block2.h>
#include <gnuradio/sync_block.h>

#include "device_source.h"

namespace gr {
  namespace iio {

    /*!
     * \brief <+description of block+>
     * \ingroup iio
     *
     */
    class IIO_API nat_amc_zynqup_sdr_source : virtual public gr::sync_block
    {
     public:
      typedef boost::shared_ptr<nat_amc_zynqup_sdr_source> sptr;

      /*!
       * \brief Return a shared_ptr to a new instance of iio::device.
       *
       * To avoid accidental use of raw pointers, iio::device's
       * constructor is in a private implementation
       * class. iio::device::make is the public interface for
       * creating new instances.
       */
      static sptr make(const std::string &uri,
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

      static sptr make_from(struct iio_context *ctx,
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

      virtual void set_params(unsigned long samplerate,
            const std::vector<std::string> &gain_mode,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &rx_qec,
            const std::vector<int> &rx_phase_corr,
            const std::vector<double> &gain,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &hd2_tracking) = 0;
    };

    class IIO_API nat_amc_zynqup_sdr_source_f32c : virtual public gr::hier_block2
    {
    public:
      typedef boost::shared_ptr<nat_amc_zynqup_sdr_source_f32c> sptr;

      static sptr make(const std::string &uri,
		    unsigned long samplerate,
		    const std::vector<int> &rx_en,
		    unsigned long buffer_size,
            const std::vector<std::string> &gain_mode,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &rx_qec,
            const std::vector<int> &rx_phase_corr,
            const std::vector<double> &gain,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &hd2_tracking)
      {
	      nat_amc_zynqup_sdr_source::sptr block = nat_amc_zynqup_sdr_source::make(uri,
			      samplerate,rx_en, buffer_size, gain_mode, lo_frequency, rx_qec, rx_phase_corr, gain, quad_tracking, hd2_tracking);

	      return gnuradio::get_initial_sptr(
			      new nat_amc_zynqup_sdr_source_f32c(rx_en, block));
      }

      void set_params(unsigned long samplerate,
            const std::vector<std::string> &gain_mode,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &rx_qec,
            const std::vector<int> &rx_phase_corr,
            const std::vector<double> &gain,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &hd2_tracking)
      {
              zynqup_sdr_block->set_params(samplerate, gain_mode, lo_frequency, rx_qec, rx_phase_corr, gain, quad_tracking, hd2_tracking);
      }
    private:
      nat_amc_zynqup_sdr_source::sptr zynqup_sdr_block;

    protected:
      explicit nat_amc_zynqup_sdr_source_f32c(const std::vector<int> &rx_en,
		      nat_amc_zynqup_sdr_source::sptr block);
    };

  } // namespace iio
} // namespace gr

#endif /* INCLUDED_IIO_NAT_AMC_ZYNQUP_SDR_SOURCE_H */
