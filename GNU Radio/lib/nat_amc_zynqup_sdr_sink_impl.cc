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
#include <iostream>
#include <numeric>
#include <gnuradio/io_signature.h>
#include "nat_amc_zynqup_sdr_sink_impl.h"
#include "device_source_impl.h"

#include <gnuradio/blocks/float_to_short.h>
#include <gnuradio/blocks/complex_to_float.h>


using namespace gr::blocks;

namespace gr {
  namespace iio {

    nat_amc_zynqup_sdr_sink_f32c::nat_amc_zynqup_sdr_sink_f32c(const std::vector<int> &tx_en,
		    nat_amc_zynqup_sdr_sink::sptr sink_block) :
	    hier_block2("nat_amc_zynqup_sdr_sink_f32c",
			    io_signature::make(
                    std::accumulate(tx_en.begin(), tx_en.end(), 0),
                    std::accumulate(tx_en.begin(), tx_en.end(), 0),
				    sizeof(gr_complex)),
			    io_signature::make(0, 0, 0)),
	    zynqup_sdr_block(sink_block)
    {
      basic_block_sptr hier = shared_from_this();
      unsigned int num_streams = std::accumulate(tx_en.begin(), tx_en.end(), 0);

      for (unsigned int i = 0; i < num_streams; i++) {
	float_to_short::sptr f2s1 = float_to_short::make(1, 32768.0);
	float_to_short::sptr f2s2 = float_to_short::make(1, 32768.0);
	complex_to_float::sptr c2f = complex_to_float::make();

	connect(hier, i, c2f, 0);
	connect(c2f, 0, f2s1, 0);
	connect(c2f, 1, f2s2, 0);
	connect(f2s1, 0, sink_block, i * 2);
	connect(f2s2, 0, sink_block, i * 2 + 1);
      }
    }

    nat_amc_zynqup_sdr_sink::sptr
    nat_amc_zynqup_sdr_sink::make(const std::string &uri,
		    unsigned long samplerate,
            const std::vector<int> &tx_en,
		    unsigned long buffer_size, bool cyclic,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &tx_qec,
            const std::vector<int> &tx_lol,
            const std::vector<double> &attenuation,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &leak_tracking)
    {
      return gnuradio::get_initial_sptr(
	    new nat_amc_zynqup_sdr_sink_impl(device_source_impl::get_context(uri), true,
		    samplerate, tx_en, buffer_size, cyclic, lo_frequency, tx_qec, tx_lol,
		    attenuation, quad_tracking, leak_tracking));
    }

    nat_amc_zynqup_sdr_sink::sptr
    nat_amc_zynqup_sdr_sink::make_from(struct iio_context *ctx,
		    unsigned long samplerate,
            const std::vector<int> &tx_en,
		    unsigned long buffer_size, bool cyclic,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &tx_qec,
            const std::vector<int> &tx_lol,
            const std::vector<double> &attenuation,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &leak_tracking)
    {
      return gnuradio::get_initial_sptr(
	    new nat_amc_zynqup_sdr_sink_impl(ctx, false, samplerate,
		    tx_en,
		    buffer_size, cyclic, lo_frequency, tx_qec, tx_lol,
		    attenuation, quad_tracking, leak_tracking));
    }

    std::vector<std::string> nat_amc_zynqup_sdr_sink_impl::get_channels_vector(
		    const std::vector<int> &tx_en)
    {
        /* adrv9009-phy
         * - voltage 0-3
         * adrv9009-phy-b
         * - voltage 4-7
         * adrv9009-phy-c
         * - voltage 8-11
         * adrv9009-phy-d
         * - voltage 12-15
        */

	    std::vector<std::string> channels;
	    for(int i = 0; i < tx_en.size(); i++){
        if (tx_en[i]){
		    channels.push_back("voltage" +
			    boost::to_string(i * 2));
		    channels.push_back("voltage" +
			    boost::to_string((i * 2) + 1));
            }
        }
                return channels;
    }

    nat_amc_zynqup_sdr_sink_impl::nat_amc_zynqup_sdr_sink_impl(struct iio_context *ctx,
		    bool destroy_ctx,
		    unsigned long samplerate,
            const std::vector<int> &tx_en,
		    unsigned long buffer_size, bool cyclic,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &tx_qec,
            const std::vector<int> &tx_lol,
            const std::vector<double> &attenuation,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &leak_tracking)
	    : gr::sync_block("nat_amc_zynqup_sdr_sink",
			    gr::io_signature::make(1, -1, sizeof(short)),
			    gr::io_signature::make(0, 0, 0)),
	      device_sink_impl(ctx, destroy_ctx, "axi-adrv9009-tx-hpc",
			    get_channels_vector(tx_en),
			    "adrv9009-phy", std::vector<std::string>(),
			    buffer_size, 0, cyclic),
	      cyclic(cyclic)
    {
	    set_params(samplerate, lo_frequency, tx_qec, tx_lol, attenuation, quad_tracking,leak_tracking);
    }

    void nat_amc_zynqup_sdr_sink_impl::set_params(
		    unsigned long samplerate,
            const std::vector<unsigned long int> &lo_frequency,
            const std::vector<int> &tx_qec,
            const std::vector<int> &tx_lol,
            const std::vector<double> &attenuation,
            const std::vector<int> &quad_tracking,
            const std::vector<int> &leak_tracking)
    {
        const std::vector<std::string> phy_devices = {"adrv9009-phy","adrv9009-phy-b","adrv9009-phy-c","adrv9009-phy-d"};


        for(int i = 0; i < lo_frequency.size(); i++) //2 channel per device
            {
            //configure each phy_device
            std::vector<std::string> params;
        	params.push_back("out_altvoltage0_TRX_LO_frequency=" +
			    boost::to_string(lo_frequency[i]));
            //std::cout << lo_frequency[i] << std::endl;
	        params.push_back("out_voltage0_hardwaregain=" +
			    boost::to_string(-attenuation[i*2]));
		    params.push_back("out_voltage1_hardwaregain=" +
			    boost::to_string(-attenuation[i*2+1]));

	        params.push_back("out_voltage0_quadrature_tracking_en=" +
			    boost::to_string(quad_tracking[i*2]));
		    params.push_back("out_voltage1_quadrature_tracking_en=" +
			    boost::to_string(quad_tracking[i*2+1]));

	        params.push_back("out_voltage0_lo_leakage_tracking_en=" +
			    boost::to_string(leak_tracking[i*2]));
		    params.push_back("out_voltage1_lo_leakage_tracking_en=" +
			    boost::to_string(leak_tracking[i*2+1]));

		    params.push_back("calibrate_tx_qec_en=" +
			    boost::to_string(tx_qec[i]));
		    params.push_back("calibrate_tx_lol_en=" +
			    boost::to_string(tx_lol[i]));
		    params.push_back("calibrate=1");

            //std::cout << phy_devices[i].c_str() << std::endl;
            //for(int j = 0; j < params.size(); j++)
            //    std::cout << params[j] << std::endl;
            device_source_impl::set_params(iio_context_find_device(this->ctx,phy_devices[i].c_str()), params);

            }
        //configure the sampling frequency for the tx device
        //not working: Unable to write attribute out_voltage_sampling_frequency: -22


        std::vector<std::string> param_sampl;
		param_sampl.push_back("out_voltage_sampling_frequency=" + boost::to_string(samplerate));
        device_source_impl::set_params(iio_context_find_device(this->ctx,"axi-adrv9009-tx-hpc"), param_sampl);

    }

    int nat_amc_zynqup_sdr_sink_impl::work(int noutput_items,
		    gr_vector_const_void_star &input_items,
		    gr_vector_void_star &output_items)
    {
	    int ret = device_sink_impl::work(noutput_items, input_items,
			    output_items);
	    if (ret < 0 || !cyclic)
		    return ret;
	    else
		    return WORK_DONE;
    }
  } /* namespace iio */
} /* namespace gr */
