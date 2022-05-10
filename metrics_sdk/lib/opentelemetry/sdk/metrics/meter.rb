# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module SDK
    # The Metrics module contains the OpenTelemetry metrics reference
    # implementation.
    module Metrics
      # {Meter} is the SDK implementation of {OpenTelemetry::Metrics::Meter}.
      class Meter < OpenTelemetry::Metrics::Meter
        # @api private
        #
        # Returns a new {Meter} instance.
        #
        # @param [String] name Instrumentation package name
        # @param [String] version Instrumentation package version
        #
        # @return [Meter]
        def initialize(name, version, meter_provider)
          @mutex = Mutex.new
          @registry = {}
          @instrumentation_library = InstrumentationLibrary.new(name, version)
          @meter_provider = meter_provider
        end

        def create_instrument(kind, name, unit, description, callback)
          super do
            case kind
            when :counter then OpenTelemetry::SDK::Metrics::Instrument::Counter.new(name, unit, description, self)
            when :observable_counter then OpenTelemetry::SDK::Metrics::Instrument::ObservableCounter.new(name, unit, description, callback, self)
            when :histogram then OpenTelemetry::SDK::Metrics::Instrument::Histogram.new(name, unit, description, self)
            when :observable_gauge then OpenTelemetry::SDK::Metrics::Instrument::ObservableGauge.new(name, unit, description, callback, self)
            when :up_down_counter then OpenTelemetry::SDK::Metrics::Instrument::UpDownCounter.new(name, unit, description, self)
            when :observable_up_down_counter then OpenTelemetry::SDK::Metrics::Instrument::ObservableUpDownCounter.new(name, unit, description, callback, self)
            end
          end
        end
      end
    end
  end
end
