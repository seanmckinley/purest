# frozen_string_literal: true

module Purest
  class CustomExceptions
    class ConflictingArguments < StandardError
    end

    class RequiredArgument < StandardError
    end

    class ArgumentMismatch < StandardError
    end
  end
end
