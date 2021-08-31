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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <cstdio>
#include <numeric>
#include <gnuradio/io_signature.h>
#include "nat_amc_zynqup_sdr_source_impl.h"

#include <gnuradio/blocks/short_to_float.h>
#include <gnuradio/blocks/float_to_complex.h>


using namespace gr::blocks;

namespace gr {
  namespace iio {

    nat_amc_zynqup_sdr_source_f32c::nat_amc_zynqup_sdr_source_f32c(const std::vector<int> &rx_en,
                    nat_amc_zynqup_sdr_source::sptr src_block) :
            hier_block2("zynqup_sdr_f32c",
                io_signature::make(0, 0, 0),
                io_signature::make(
			std::accumulate(rx_en.begin(), rx_en.end(), 0),
			std::accumulate(rx_en.begin(), rx_en.end(), 0),
			sizeof(gr_complex))),
            zynqup_sdr_block(src_block)
    {
      basic_block_sptr hier = shared_from_this();
      unsigned int num_streams = std::accumulate(rx_en.begin(), rx_en.end(), 0);

      for (unsigned int i = 0; i < num_streams; i++) {
        short_to_float::sptr s2f1 = short_to_float::make(1, 2048.0);
        short_to_float::sptr s2f2 = short_to_float::make(1, 2048.0);
        float_to_complex::sptr f2c = float_to_complex::make(1);

        connect(src_block, i * 2, s2f1, 0);
        connect(src_block, i * 2 + 1, s2f2, 0);
        connect(s2f1, 0, f2c, 0);
        connect(s2f2, 0, f2c, 1);
        connect(f2c, 0, hier, i);
      }
    }

    nat_amc_zynqup_sdr_source::sptr
    nat_amc_zynqup_sdr_source::make(const std::string &uri, unsigned long samplerate,
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
      return gnuradio::get_initial_sptr
        (new nat_amc_zynqup_sdr_source_impl(device_source_impl::get_context(uri), true,
				  samplerate,rx_en, buffer_size,
				  gain_mode, lo_frequency, rx_qec, rx_phase_corr, gain, quad_tracking, hd2_tracking));
    }

    nat_amc_zynqup_sdr_source::sptr
    nat_amc_zynqup_sdr_source::make_from(struct iio_context *ctx,
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
      return gnuradio::get_initial_sptr
        (new nat_amc_zynqup_sdr_source_impl(ctx, false, samplerate,rx_en, buffer_size,
				  gain_mode, lo_frequency, rx_qec, rx_phase_corr, gain, quad_tracking, hd2_tracking));
    }

    std::vector<std::string> nat_amc_zynqup_sdr_source_impl::get_channels_vector(
		    const std::vector<int> &rx_en)
    {
	    std::vector<std::string> channels;
        for(int i = 0; i < rx_en.size(); i++){
        if (rx_en[i]){
		    channels.push_back("voltage" + boost::to_string(i) + "_i");
		    channels.push_back("voltage" + boost::to_string(i) + "_q");
            }
        }
	    return channels;
    }

    nat_amc_zynqup_sdr_source_impl::nat_amc_zynqup_sdr_source_impl(struct iio_context *ctx,
		    bool destroy_ctx,
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
      : gr::sync_block("nat_amc_zynqup_sdr_source",
              gr::io_signature::make(0, 0, 0),
              gr::io_signature::make(1, -1, sizeof(short)))
      , device_source_impl(ctx, destroy_ctx, "axi-adrv9009-rx-hpc",
		      get_channels_vector(rx_en),
		      "adrv9009-phy", std::vector<std::string>(),
		      buffer_size, 0)
    {
	    set_params(samplerate, gain_mode, lo_frequency, rx_qec, rx_phase_corr, gain, quad_tracking, hd2_tracking);
    }

    void nat_amc_zynqup_sdr_source_impl::set_params(
		    unsigned long samplerate,
            const std::vector<std::string> &gain_mode,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &rx_qec,
            const std::vector<int> &rx_phase_corr,
            const std::vector<double> &gain,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &hd2_tracking)
    {
        const std::vector<std::string> phy_devices = {"adrv9009-phy","adrv9009-phy-b","adrv9009-phy-c","adrv9009-phy-d"};


        for(int i = 0; i < lo_frequency.size(); i++) //2 channel per device
            {
            //configure each phy_device
            std::vector<std::string> params;
        	params.push_back("out_altvoltage0_TRX_LO_frequency=" +
			    boost::to_string(lo_frequency[i]));
            //std::cout << lo_frequency[i] << std::endl;
            if (gain_mode[i] == "manual"){
                params.push_back("in_voltage0_gain_control_mode=manual");
                params.push_back("in_voltage1_gain_control_mode=manual");
	            params.push_back("in_voltage0_hardwaregain=" +
			        boost::to_string(gain[i*2]));
		        params.push_back("in_voltage1_hardwaregain=" +
			        boost::to_string(gain[i*2+1]));
            }
            else{
                params.push_back("in_voltage0_gain_control_mode=slow_attack");
                params.push_back("in_voltage1_gain_control_mode=slow_attack");
            }

	        params.push_back("in_voltage0_quadrature_tracking_en=" +
			    boost::to_string(quad_tracking[i*2]));
		    params.push_back("in_voltage1_quadrature_tracking_en=" +
			    boost::to_string(quad_tracking[i*2+1]));

	        params.push_back("in_voltage0_hd2_tracking_en=" +
			    boost::to_string(hd2_tracking[i*2]));
		    params.push_back("in_voltage1_hd2_tracking_en=" +
			    boost::to_string(hd2_tracking[i*2+1]));


		    params.push_back("calibrate_rx_qec_en=" +
			    boost::to_string(rx_qec[i]));
		    params.push_back("calibrate_rx_phase_correction_en=" +
			    boost::to_string(rx_phase_corr[i]));
		    params.push_back("calibrate=1");
            //std::cout << phy_devices[i].c_str() << std::endl;
            //for(int j = 0; j < params.size(); j++)
            //    std::cout << params[j] << std::endl;
            device_source_impl::set_params(iio_context_find_device(this->ctx,phy_devices[i].c_str()), params);
            }

        std::vector<std::string> param_sampl;
		param_sampl.push_back("in_voltage_sampling_frequency=" + boost::to_string(samplerate));
        device_source_impl::set_params(iio_context_find_device(this->ctx,"axi-adrv9009-rx-hpc"), param_sampl);
    }

  } /* namespace iio */
} /* namespace gr */
