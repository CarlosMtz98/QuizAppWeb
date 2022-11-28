class Question

    attr_reader :id, :value, :options

    def initialize(id, value, options)
        @id = id
        @value = value
        @options = options
    end

    def to_s
        puts "Question: #{@id}, #{@value}"
        options.each do |opt|
            puts opt.to_s
        end
    end

end