class PNGSignature

  def initialize
    @valid_signature = "\x89PNG\x0D\x0A\x1A\x0A"
  end

  def read(input)
    @signature = input.read(8)
  end

  def write(output)
    output.write(@valid_signature)
  end

  def is_valid
    @signature == @valid_signature
  end

end