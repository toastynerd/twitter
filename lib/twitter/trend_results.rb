require 'memoizable'
require 'twitter/creatable'
require 'twitter/enumerable'
require 'twitter/null_object'

module Twitter
  class TrendResults
    include Twitter::Creatable
    include Twitter::Enumerable
    include Memoizable
    attr_reader :attrs
    alias_method :to_h, :attrs
    alias_method :to_hash, :attrs
    alias_method :to_hsh, :attrs

    class << self
      # Construct a new TrendResults object from a response hash
      #
      # @param response [Hash]
      # @return [Twitter::Base]
      def from_response(response = {})
        new(response[:body].first)
      end
    end

    # Initializes a new TrendResults object
    #
    # @param attrs [Hash]
    # @return [Twitter::TrendResults]
    def initialize(attrs = {})
      @attrs = attrs
      @collection = Array(@attrs[:trends]).map do |trend|
        Trend.new(trend)
      end
    end

    # Time when the object was created on Twitter
    #
    # @return [Time]
    def as_of
      Time.parse(@attrs[:as_of]) unless @attrs[:as_of].nil?
    end
    memoize :as_of

    def as_of?
      !!@attrs[:as_of]
    end
    memoize :as_of?

    # @return [Twitter::Place, NullObject]
    def location
      location? ? Place.new(@attrs[:locations].first) : NullObject.new
    end
    memoize :location

    # @return [Boolean]
    def location?
      !@attrs[:locations].nil? && !@attrs[:locations].first.nil?
    end
    memoize :location?
  end
end
