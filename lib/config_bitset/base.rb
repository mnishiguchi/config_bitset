# An abstract class that implements utility methods for managing config flags.
module ConfigBitset
  class Base
    attr_reader :state

    def initialize(state = 0)
      raise ArgumentError, "state must be an integer" unless state.is_a?(Integer)
      @state = state
    end

    def to_i
      @state
    end

    def to_a
      self.class.list.each_with_object([]) do |hash, acc|
        acc << hash if send("#{hash[:name]}?")
      end
    end

    # A binary string
    def to_s
      @state.to_s(2)
    end

    def clear
      @state = 0
    end

    class << self
      # TODO: use shift instead of int value.
      # Registers a config flag and generates utility methods for it.
      # name: string|symbol
      # value: integer
      # display_name: string (optional)
      def define_flag(name, value, display_name = nil)
        raise ArgumentError, "value must be an integer" unless value.is_a?(Integer)

        # Standardize on lower-case string.
        name = name.to_s.downcase

        # Register a flag.
        register_flag(name: name, value: value, display_name: display_name.presence || name.titleize)

        # Returns true if the flag of the method name is enabled.
        define_method(name + "?") do
          @state & value != 0
        end

        # Accepts a boolean value and switches on/off the flag of the method name.
        define_method(name + "=") do |set|
          if set
            @state |= value
          else
            @state &= ~value
          end
        end
      end

      def list
        # Create an array on first access.
        @registered_flags ||= []
      end

      private def register_flag(flag_hash)
        ensure_registered_flags_initialized
        puts "Already registered: #{flag_hash.inspect}" if already_registered?(flag_hash)
        @registered_flags << flag_hash
      end

      private def ensure_registered_flags_initialized
        list
      end

      private def already_registered?(flag_hash)
        ensure_registered_flags_initialized
        @registered_flags.map do |registered_flag|
          registered_flag[:name] == flag_hash[:name] || registered_flag[:value] == flag_hash[:value]
        end.any?
      end
    end
  end
end
