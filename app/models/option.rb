class Option

    attr_reader :id, :text

    def initialize(id, text)
        @id = id
        @text = text
    end

    def to_s
        "Option: #{@id}, #{@text}"
    end
end