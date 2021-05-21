# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module Redis
      # The Instrumentation class contains logic to detect and install the Redis
      # instrumentation
      class Instrumentation < OpenTelemetry::Instrumentation::Base
        install do |_config|
          require_dependencies
          patch_client
        end

        present do
          defined?(::Redis)
        end

        option :peer_service, default: nil, validate: :string
        option :enable_statement_obfuscation, default: true, validate: :boolean

        private

        def require_dependencies
          require_relative 'patches/client'
        end

        def patch_client
          ::Redis::Client.prepend(Patches::Client)
        end
      end
    end
  end
end
