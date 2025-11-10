class Token
    attr_accessor :type, :text, :start_pos, :end_pos
    def initialize (type, text, start_pos, end_pos)
        @type = type
        @text = text
        @start_pos = start_pos
        @end_pos = end_pos
    end

    def to_s
        "#{type}, \'#{text}\', #{start_pos}, #{end_pos}"
    end
end