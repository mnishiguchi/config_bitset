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
      self.class.list.each_with_object([]) do |flag_hash, acc|
        acc << flag_hash if send("#{flag_hash[:name]}?")
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
      # Registers a config flag and generates utility methods for it.
      # name: string|symbol
      # index: integer
      # display_name: string (optional)
      def define_flag(name, index, display_name = nil)
        # Standardize on lower-case string.
        name = name.to_s.downcase

        value = 1 << index

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

      # e.g. 9 => 512
      def index_to_value(index)
        1 << index
      end

      # e.g. 512 => 9
      def value_to_index(value)
        value.to_s(2).size - 1
      end

      def list
        # Create an array on first access.
        @list ||= []
      end

      private def register_flag(flag_hash)
        puts "Already registered: #{flag_hash.inspect}" if already_registered?(flag_hash)
        @list << flag_hash
      end

      private def already_registered?(flag_hash)
        ensure_list_initialized
        list.map do |registered_flag|
          registered_flag[:name] == flag_hash[:name] || registered_flag[:value] == flag_hash[:value]
        end.any?
      end
      
      private def ensure_list_initialized
        list
      end
    end
  end
end
